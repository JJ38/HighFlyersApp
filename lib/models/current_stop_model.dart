import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentStopModel {

  Map<String, dynamic> stop = {};
  bool showStopForm = false;
  late String progressedRunID;
  late Map<String, dynamic> runData;
  List<AvailableMap>? availableMaps;
  bool isDefaultMapAvailable = false;
  late void Function(Map<String, dynamic>) updateCurrentStop;
  bool isRunCompleted = false;
  String? currentDriverUsername;
  bool calledAdmin = false;
  bool shouldCallAdmin = false;

  bool getShouldCallAdmin(){
    return shouldCallAdmin;
  }

  void setCalledAdmin(newCalledAdmin){
    calledAdmin = newCalledAdmin;
  }

  Future<bool> skipStop() async{

    final bool successfullySkippedStop = await nextStop("Skipped");

    if(!successfullySkippedStop){
      return false;
    }

    return true;

  }

  Future<bool> completeStop(Map<String, dynamic>? formDetails) async{

    return await nextStop("Complete", formDetails);

  }


  Future<bool> nextStop(String stopStatus, [Map<String, dynamic>? formDetails]) async{
    
    //reset value as form could have been misclick on whether payment was collected or not
    shouldCallAdmin = false;

    final expectedPayment = stop['deferredPayment'] == true ? !stop['deferredPaymentDoc']['formDetails']['collectedPayment'] : stop['stopData']['payment'];  
    final didPay = formDetails?['collectedPayment'] ?? false; //set to false if stop was skipped
    
    final Map<String, dynamic>? deferredPayment = shouldDeferPayment(stopStatus, stop, formDetails, expectedPayment, didPay);

    final bool isDeferredPayment = stop['deferredPayment'] ?? false;

    bool isLateDeferredPayment = false;

    if(isDeferredPayment){
      isLateDeferredPayment = !stop['deferredPaymentDoc']['deferredPaymentType']; //true is early deferred payment. In that case no need to withhold next stop
    }


    //if they didnt pay on delivery and they should have. If theyve not tapped "call kev". If the payment is a late deferred payment rather than an early one
    if((expectedPayment != didPay) && stop['stopType'] == "delivery" && !calledAdmin){

      if(isLateDeferredPayment){
        // is updated payment as wasnt paid on collection when they said they would
        shouldCallAdmin = true;
        return false;
      }

      if(stop['stopData']['payment'] && !isDeferredPayment){
        //said they would pay on delivery and wouldnt
        shouldCallAdmin = true;
        return false;
      }
      //dont allow stop to be passed until they call kev

    }

    // return false;

    try{
      
      final databaseName = dotenv.env['DATABASE_NAME'];
      
      DocumentReference<Map<String, dynamic>> deferredPaymentDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('DeferredPayments').doc();

      //update ProgressedRun doc stops[i] with stop status to skipped
      DocumentReference<Map<String, dynamic>> runDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('ProgressedRuns').doc(progressedRunID);
      
      final stops = runData['stops'];

      List<dynamic> newStops = [...stops];

      //find stop to update
      final currentStopPrimaryKey = "${stop['orderID']}_${stop['stopType']}";

      bool foundStop = false; 

      int newStopNumber = runData['currentStopNumber'];


      for(int i = 0; i < newStops.length; i++){
        
        final stopPrimaryKey = "${newStops[i]['orderID']}_${newStops[i]['stopType']}";

        if(stopPrimaryKey == currentStopPrimaryKey){
          
          newStops[i]['stopStatus'] = stopStatus;
          newStops[i]['formDetails'] = formDetails;

          newStopNumber += 1;
          foundStop = true;
          break;
        }

      }

      if(!foundStop){
        Sentry.logger.fmt.info("Couldnt find stop %s", [currentStopPrimaryKey]);
        return false;
      }

      String runStatus = "En route";

      //is there a stop to show next? - is the run completed?
      if(newStopNumber > stops.length){

        isRunCompleted = true;
        runStatus = "Completed";
        newStopNumber = newStopNumber - 1;

      }

      Map<String, dynamic> fieldsToUpdate = 
      {
        'currentStopNumber': newStopNumber,
        'runStatus': runStatus,
        'stops': newStops,
        'updatedAt': FieldValue.serverTimestamp()
      };

      bool runDocExists = true;

      await FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).runTransaction((transaction) async {

        final runDoc = await transaction.get(runDocRef);

        if (!runDoc.exists) {
          Sentry.logger.fmt.info("Run doc was false on next stop attempt", []);
          runDocExists = false;
          return false;
        }

        if(deferredPayment != null){
          Sentry.logger.fmt.info("Attempt to create deferred payment %s", [deferredPayment]);
          transaction.set(deferredPaymentDocRef, deferredPayment);
        }

        transaction.update(runDocRef, fieldsToUpdate);

      });

      if(!runDocExists){
        return false;
      }

      
      //updates client that holds info for run
      runData['currentStopNumber'] = newStopNumber;
      runData['runStatus'] = runStatus;
      runData['stops'] = newStops;

      calledAdmin = false;
      shouldCallAdmin = false;

      final user = FirebaseAuth.instance.currentUser;
      final String? username = user?.email?.replaceAll("@placeholder.com", "");

      Sentry.logger.fmt.info("%s Successfully %s stop. Stop data: %s Form details: %s", [username, stopStatus, stop, formDetails]);

      if(runStatus == "Completed"){
        Sentry.logger.fmt.info("%s Successfully completed run %s", [username, runData['runName']]);
      }

      //find the new stop after the one just skipped/completed
      for(int i = 0; i < newStops.length; i++){

        if(newStopNumber == newStops[i]['stopNumber']){
          stop = newStops[i];
          updateCurrentStop(stop);
          print(stop['coordinates']);
          return true;
        }

      }


      return false;

    }catch(error, stack){

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('current_stop_error', {
            'module': 'current_stop',
            'details': error.toString(),
          });
        },
      );
      
      print(error);
      return false;
    }

  }

  Map<String, dynamic>? shouldDeferPayment(stopStatus, currentStop, formDetails, expectedPayment, didPay){


    //has the order been fufilled and were they meant to pay at this stop?

    print("didPay: $didPay");
    print("stop['stopType']: ${currentStop['stopType']}");
    print("stopStatus: $stopStatus");



    //If the stop was skipped or payment wasnt made when expected on ***delivery*** no adjustments should be made in any circumstance
    //As if it was skipped on collection no payment is needed as nothing has been fufilled and if payment wasnt made on delivery
    //When expected there are no stops left to adjust the payment status for
    if(stopStatus == "Complete" && currentStop['stopType'] == "collection"){

      if(expectedPayment != didPay){

        print("Payment wasnt made when it should have been");

        
        String deferredStopType = currentStop['stopType'] == "collection" ? "delivery" : "chase";

        //create a deferred payment document
        final Map<String, dynamic> deferredPayment = {
          
          "orderID": currentStop['orderID'],
          "stopID": "${currentStop['orderID']}_$deferredStopType",//this refers to the stop that it updates
          "orderData": currentStop['orderData'],
          "formDetails": formDetails,
          "deferredPaymentType": didPay //If true it was an early payment if false its a late payment

        };

        print(deferredPayment);

        return deferredPayment;

      }

    }

    return null;

  }



  Future<bool> callAdmin() async {

    try{
      
      //update to read from document. Could just do i here or at start of run. Doesnt matter as either way no signal and it cant fetch or call.
      final String? adminPhoneNumber = dotenv.env['ADMIN_PHONE_NUMBER'];

      if(adminPhoneNumber == null){
        return false;
      }
      final Uri uriPhoneNumber = Uri(scheme: 'tel', path: "07842133519");

      if (await canLaunchUrl(uriPhoneNumber)) {

        await launchUrl(uriPhoneNumber);

        calledAdmin = true;

      } else {

        throw Exception("Error calling admin phonenumber");

      }

      return true;

    }catch(error, stack){

      print(error);

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('call_admin_error', {
            'module': 'current_stop',
            'details': error.toString(),
          });
        },
      );

      return false;

    }


  }

  Future<MapType?> getMapPreference() async {

    try{

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? mapPreference = prefs.getString('maptype_preference');

      if(mapPreference == null){
        return null;
      }

      switch (mapPreference){

        case "Apple Maps":
          return MapType.apple;

        case "Google Maps":
          return MapType.google;

        case "Waze":
          return MapType.waze;

      }

      return null;

    }catch(error, stack){

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('get_map_preference_error', {
            'module': 'current_stop',
            'details': error.toString(),
          });
        },
      );
      
      print(error);
      return null;
    }

  }

}