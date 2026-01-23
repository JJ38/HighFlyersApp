import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/stop_form_model.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class StopFormDialogModel{ 

  String? animalType;
  int? quantity;
  bool? collectedPayment;
  String? notes;
  Map<String, dynamic>? formDetails;
  Map<String, dynamic> stop;
  Map<String, dynamic>? runData;
  String? progressedRunID;
  String errorMessage = "";
  bool shouldCallAdmin = false;
  bool calledAdmin = false;


  StopFormDialogModel({required this.stop, this.runData, this.progressedRunID}){

    Map<String, dynamic>? formDetails = stop['formDetails']; 

    if(formDetails == null){
      return;
    }

    animalType = formDetails['animalType'];
    quantity = formDetails['quantity'];
    collectedPayment = formDetails['collectedPayment'];
    notes = formDetails['notes'];

  }

  bool isFormValid(){

    if(animalType == null){
      errorMessage = "Please select an animal type";
      return false;
    }

    if(quantity == null || quantity! <= 0){
      errorMessage = "Please enter a valid number. Quantity must be greater than 0";
      return false;
    }

    if(collectedPayment == null){
      errorMessage = "Please select if payment was collected";
      return false;
    }

    formDetails = 
    {
      'animalType': animalType,
      'quantity': quantity,
      'collectedPayment': collectedPayment,
      'notes': notes
    };
  
    return true;

  }

  Future<bool> completeStop() async{

    print(stop);

    shouldCallAdmin = false;
    String stopStatus = "Complete";
    
    //If is an early deferred payment is associated with this stop(paid on collection when promised on delivery), Then on the current expectedPayment value is false.(The opposite of what the formdetails where
    //when creating the deferred payment)
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


    if(runData == null){
      return false;
    }

    try{
      
      final databaseName = dotenv.env['DATABASE_NAME'];
      
      DocumentReference<Map<String, dynamic>> deferredPaymentDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('DeferredPayments').doc();

      DocumentReference<Map<String, dynamic>> runDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('ProgressedRuns').doc(progressedRunID);
      
      final stops = runData!['stops'];

      List<dynamic> newStops = [...stops];

      //find stop to update
      final currentStopPrimaryKey = "${stop['orderID']}_${stop['stopType']}";

      bool foundStop = false; 

      for(int i = 0; i < newStops.length; i++){
        
        final stopPrimaryKey = "${newStops[i]['orderID']}_${newStops[i]['stopType']}";

        if(stopPrimaryKey == currentStopPrimaryKey){
          
          newStops[i]['stopStatus'] = stopStatus;
          newStops[i]['formDetails'] = formDetails;

          foundStop = true;
          break;
        }

      }

      if(!foundStop){
        Sentry.logger.fmt.info("Couldnt find stop %s", [currentStopPrimaryKey]);
        return false;
      }

      String runStatus = "En route";

      Map<String, dynamic> fieldsToUpdate = 
      {
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
      runData!['stops'] = newStops;

      calledAdmin = false;
      shouldCallAdmin = false;

      final user = FirebaseAuth.instance.currentUser;
      final String? username = user?.email?.replaceAll("@placeholder.com", "");

      Sentry.logger.fmt.info("%s Successfully completed stop from the overview panel. Stop data: %s Form details: %s", [username, stop, formDetails]);

      return false;

    }catch(error, stack){

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('stop_form_dialog_model', {
            'module': 'complete_stop_form_dialog',
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
    //whereas if it was skipped on collection no payment is needed as nothing has been fufilled and if payment wasnt made on delivery
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
  

}