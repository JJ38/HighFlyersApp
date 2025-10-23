import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    
    final expectedPayment = stop['stopData']['payment'];  
    
    final Map<String, dynamic>? deferredPayment = shouldDeferPayment(stopStatus, stop, formDetails, expectedPayment);


    try{

      final databaseName = dotenv.env['DATABASE_NAME'];

      if(databaseName == null){
        return false;
      }

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
        return false;
      }

      String runStatus = "Enroute";

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
        'stops': newStops
      };


      await runDocRef.update(fieldsToUpdate);
      
      //updates client that holds info for run
      runData['currentStopNumber'] = newStopNumber;
      runData['runStatus'] = runStatus;
      runData['stops'] = newStops;

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

  Map<String, dynamic>? shouldDeferPayment(stopStatus, currentStop, formDetails, expectedPayment){


    //has the order been fufilled and were they meant to pay at this stop?
    final didPay = formDetails?['collectedPayment'] ?? false; //set to false if stop was skipped

    print("didPay: $didPay");
    print("stop['stopType']: ${currentStop['stopType']}");
    print("stopStatus: $stopStatus");



    //If the stop was skipped or payment wasnt made when expected on ***delivery*** no adjustments should be made in any circumstance
    //As if it was skipped on collection no payment is needed as nothing has been fufilled and if payment wasnt made on delivery
    //When expected there are no stops left to adjust the payment status for
    if(stopStatus == "Complete" && currentStop['stopType'] == "collection"){

      if(expectedPayment != didPay){

        print("Payment wasnt made when it should have been");

        //create a deferred payment document
        final Map<String, dynamic> deferredPayment = {
          
          "orderID": currentStop['orderID'],
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