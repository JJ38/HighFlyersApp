import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentStopModel {

  Map<String, dynamic>? stop = {};
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


  CurrentStopModel({required this.stop}){
    shouldAutoShowForm();
  }

  void shouldAutoShowForm(){

    if(stop?['formDetails'] != null){
      showStopForm = true;
    }

  }

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

    if(stop == null){
      return false;
    }
    
    //reset value as form could have been misclick on whether payment was collected or not
    shouldCallAdmin = false;

    final bool expectedPayment = stop?['deferredPayment'] == true ? !stop!['deferredPaymentDoc']['formDetails']['collectedPayment'] : stop!['stopData']['payment'];  
    final bool didPay = (formDetails?['collectedPayment'] == true) && stopStatus == "Complete"; //set to false if stop was skipped
    
    final Map<String, dynamic>? deferredPayment = shouldDeferPayment(stopStatus, stop, formDetails, expectedPayment, didPay);

    final bool isDeferredPayment = stop?['deferredPayment'] ?? false;

    bool isLateDeferredPayment = false;

    if(isDeferredPayment){
      isLateDeferredPayment = !stop?['deferredPaymentDoc']['deferredPaymentType']; //true is early deferred payment. In that case no need to withhold next stop
    }

    final bool createDeferredPayment = expectedPayment != didPay;

    //if they didnt pay on delivery and they should have. If theyve not tapped "call kev". If the payment is a late deferred payment rather than an early one
    if((createDeferredPayment) && stop?['stopType'] == "delivery" && !calledAdmin){

      if(isLateDeferredPayment){
        // is updated payment as wasnt paid on collection when they said they would
        shouldCallAdmin = true;
        return false;
      }

      if(stop?['stopData']['payment'] && !isDeferredPayment){
        //said they would pay on delivery and wouldnt
        shouldCallAdmin = true;
        return false;
      }
      //dont allow stop to be passed until they call kev

    }


    //Infer if deferred payment already exists - This is to handle edge cases where a form has been updated
    final bool doesDeferredPaymentExist = stop?['formDetails'] == null ? false : (stop?['formDetails']['collectedPayment'] != expectedPayment);
  
    final bool shouldDeleteDeferredPaymentDoc = (!createDeferredPayment && doesDeferredPaymentExist) || (doesDeferredPaymentExist && stopStatus == "Skipped");
    final bool shouldCreateNewDeferredPaymentDoc = createDeferredPayment && !doesDeferredPaymentExist;

    try{
      
      final databaseName = dotenv.env['DATABASE_NAME'];
      
      DocumentReference<Map<String, dynamic>> deferredPaymentDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('DeferredPayments').doc();

      DocumentReference<Map<String, dynamic>> runDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('ProgressedRuns').doc(progressedRunID);
      
      final stops = runData['stops'];

      List<dynamic> newStops = [...stops];

      //find stop to update
      final currentStopPrimaryKey = "${stop?['orderID']}_${stop?['stopType']}";

      bool foundStop = false; 

      int newStopNumber = runData['currentStopNumber'];


      for(int i = 0; i < newStops.length; i++){
        
        final stopPrimaryKey = "${newStops[i]['orderID']}_${newStops[i]['stopType']}";

        if(stopPrimaryKey == currentStopPrimaryKey){
          
          newStops[i]['stopStatus'] = stopStatus;
          newStops[i]['formDetails'] = formDetails;

          final List allForms = newStops[i]['allForms'] ?? [];

          allForms.add(formDetails);

          newStops[i]['allForms'] = allForms;

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


      // return false;

      //check if a stop for the newstopnumber exists


      DocumentReference<Map<String, dynamic>>? deferredPaymentRef = await CurrentStopModel.getDeferredPaymentReference(shouldDeleteDeferredPaymentDoc,stop, databaseName);


      await FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).runTransaction((transaction) async {

        final runDoc = await transaction.get(runDocRef);

        if (!runDoc.exists) {
          Sentry.logger.fmt.info("Run doc was false on next stop attempt", []);
          throw StateError('Run document does not exist');
        }

        if(deferredPayment != null && shouldCreateNewDeferredPaymentDoc){
          Sentry.logger.fmt.info("Attempt to create deferred payment %s", [deferredPayment]);
          transaction.set(deferredPaymentDocRef, deferredPayment);
        }

        transaction.update(runDocRef, fieldsToUpdate);

        if(shouldDeleteDeferredPaymentDoc && deferredPaymentRef != null){
          transaction.delete(deferredPaymentRef);
        }

      });


      //updates client that holds info for run
      runData['runStatus'] = runStatus;
      runData['stops'] = newStops;

      calledAdmin = false;
      shouldCallAdmin = false;

      final user = FirebaseAuth.instance.currentUser;
      final String? username = user?.email?.replaceAll("@placeholder.com", "");

      Sentry.logger.fmt.info("%s Successfully %s stop. Stop data: %s Form details: %s", [username, stopStatus == "Complete" ? "Completed" : stopStatus, stop, formDetails]);

      if(runStatus == "Completed"){
        Sentry.logger.fmt.info("%s Successfully completed run %s", [username, runData['runName']]);
      }

      //find the new stop after the one just skipped/completed
      for(int i = 0; i < newStops.length; i++){

        if(newStopNumber == newStops[i]['stopNumber']){
          stop = newStops[i];
          runData['currentStopNumber'] = newStopNumber; 
          if(stop != null){
            updateCurrentStop(stop!);
          }
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

  static Future<DocumentReference<Map<String, dynamic>>?> getDeferredPaymentReference(shouldDeleteDeferredPaymentDoc, stop, databaseName) async {

    if(shouldDeleteDeferredPaymentDoc){

      //find deferredPaymentDoc
      final String stopPrimaryKey = "${stop?['orderID']}_${stop?['stopType']}";
      Query<Map<String, dynamic>> deferredPaymentQueryRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('DeferredPayments').where("stopIDCreated", isEqualTo: stopPrimaryKey).limit(1);
      final QuerySnapshot<Map<String, dynamic>> deferredPaymentSnapshot = await deferredPaymentQueryRef.get();

      if(deferredPaymentSnapshot.docs.isNotEmpty){
        return FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('DeferredPayments').doc(deferredPaymentSnapshot.docs[0].id);
      }

    }

    return null;

  }

  static Map<String, dynamic>? shouldDeferPayment(stopStatus, currentStop, formDetails, expectedPayment, didPay){

    //If the stop was skipped no adjustments should be made in any circumstance
    if(stopStatus == "Complete"){

      if(expectedPayment != didPay){

        String deferredStopType = currentStop?['stopType'] == "collection" ? "delivery" : didPay ? "overpaid" : "chase";

        //create a deferred payment document
        final Map<String, dynamic> deferredPayment = {
          
          "orderID": currentStop?['orderID'],
          "stopID": "${currentStop?['orderID']}_$deferredStopType",//this refers to the stop that it updates
          "stopIDCreated": "${currentStop?['orderID']}_${currentStop?['stopType']}",
          "orderData": currentStop?['orderData'],
          "formDetails": formDetails,
          "deferredStopType": deferredStopType,
          "deferredPaymentType": didPay, //If true it was an early payment if false its a late payment

        };

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
      final Uri uriPhoneNumber = Uri(scheme: 'tel', path: adminPhoneNumber);

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


  
  Future<bool> callCustomer() async {


    try{

      final String? customerPhoneNumber = stop?['stopData']?['phoneNumber'];

      if(customerPhoneNumber == null){
        return false;
      }
      
      final Uri uriPhoneNumber = Uri(scheme: 'tel', path: customerPhoneNumber);

      if (await canLaunchUrl(uriPhoneNumber)) {

        await launchUrl(uriPhoneNumber);

        calledAdmin = true;

      } else {

        throw Exception("Error calling customer phonenumber");

      }

      return true;

    }catch(error, stack){

      print(error);

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('call_customer_error', {
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