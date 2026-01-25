import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/current_stop_model.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
      'notes': notes,
      'updatedAt': Timestamp.now()
    };
  
    return true;

  }

  Future<bool> completeStop() async{

    print(stop);

    shouldCallAdmin = false;
    String stopStatus = "Complete";
    
    //If is an early deferred payment is associated with this stop(paid on collection when promised on delivery), Then on the current expectedPayment value is false.(The opposite of what the formdetails where
    //when creating the deferred payment)
    final expectedPayment = stop['deferredPayment'] == true ? !stop['deferredPaymentDoc']['formDetails']['collectedPayment'] : stop['stopData']['payment'];  //stop['deferredPayment'] will only exist on delivery stops
    final didPay = formDetails?['collectedPayment'] ?? false; //set to false if stop was skipped
    
    final Map<String, dynamic>? deferredPayment = CurrentStopModel.shouldDeferPayment(stopStatus, stop, formDetails, expectedPayment, didPay);

    final bool isDeferredPayment = stop['deferredPayment'] ?? false;

    bool isLateDeferredPayment = false;

    if(isDeferredPayment){
      isLateDeferredPayment = !stop['deferredPaymentDoc']['deferredPaymentType']; //true is early deferred payment. In that case no need to withhold next stop
    }


    final bool createDeferredPayment = expectedPayment != didPay;


    //if they didnt pay on delivery and they should have. If theyve not tapped "call kev". If the payment is a late deferred payment rather than an early one
    if((createDeferredPayment) && stop['stopType'] == "delivery" && !calledAdmin){

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

    }

    if(runData == null){
      return false;
    }

    //Infer if deferred payment already exists - This is to handle edge cases where a form has been updated
    final bool doesDeferredPaymentExist = stop['formDetails'] == null ? false : (stop['formDetails']['collectedPayment'] != expectedPayment);

    // bool doesDeferredPaymentExist = stop['formDetails'] == null ? false : (stop['formDetails']['collectedPayment'] != stop['stopData']['payment']);
    final bool shouldDeleteDeferredPaymentDoc = !createDeferredPayment && doesDeferredPaymentExist;
    final bool shouldCreateNewDeferredPaymentDoc = createDeferredPayment && !doesDeferredPaymentExist;


    try{
      
      final databaseName = dotenv.env['DATABASE_NAME'];
      
      //creates new docref in collection
      DocumentReference<Map<String, dynamic>> deferredPaymentDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('DeferredPayments').doc();

      DocumentReference<Map<String, dynamic>> runDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('ProgressedRuns').doc(progressedRunID);
      
      final stops = runData!['stops'];

      List<dynamic> newStops = [...stops];
   
      final currentStopPrimaryKey = "${stop['orderID']}_${stop['stopType']}";

      bool foundStop = false; 




      //find stop to update
      for(int i = 0; i < newStops.length; i++){
        
        final stopPrimaryKey = "${newStops[i]['orderID']}_${newStops[i]['stopType']}";

        if(stopPrimaryKey == currentStopPrimaryKey){
          
          newStops[i]['stopStatus'] = stopStatus;
          newStops[i]['formDetails'] = formDetails;

          final List allForms = newStops[i]['allForms'] ?? [];

          allForms.add(formDetails);

          newStops[i]['allForms'] = allForms;

          foundStop = true;
          break;
        }

      }

      if(!foundStop){
        Sentry.logger.fmt.info("Couldnt find stop %s", [currentStopPrimaryKey]);
        return false;
      }

      Map<String, dynamic> fieldsToUpdate = 
      {
        'stops': newStops,
        'updatedAt': FieldValue.serverTimestamp()
      };


      //Manage deleting deferred payment
      DocumentReference<Map<String, dynamic>>? deferredPaymentRef = await CurrentStopModel.getDeferredPaymentReference(shouldDeleteDeferredPaymentDoc, stop, databaseName);

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
      runData!['stops'] = newStops;

      calledAdmin = false;
      shouldCallAdmin = false;

      final user = FirebaseAuth.instance.currentUser;
      final String? username = user?.email?.replaceAll("@placeholder.com", "");

      Sentry.logger.fmt.info("%s Successfully completed stop from the overview panel. Stop data: %s Form details: %s", [username, stop, formDetails]);

      return true;

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
            'module': 'stop_form_dialog',
            'details': error.toString(),
          });
        },
      );

      return false;

    }


  }

}