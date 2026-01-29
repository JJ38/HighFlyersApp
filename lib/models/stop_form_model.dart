import 'package:cloud_firestore/cloud_firestore.dart';

class StopFormModel {

  String? animalType;
  int? quantity;
  bool? collectedPayment;
  String? notes;
  Map<String, dynamic>? formDetails;
  Map<String, dynamic>? Function() getStop;
  Future<bool> Function(Map<String, dynamic>?)? completeStop;
  bool confirmedPaymentInput = false;

  StopFormModel({required this.getStop, required this.completeStop}){
    updateStopFormData();
  }
  
  void setConfirmationAnswer(bool confirmationAnswer){
    confirmedPaymentInput = confirmationAnswer;
  }

  void updateStopFormData(){

    formDetails = getStop()?['formDetails'];

    if(formDetails != null){
      animalType = formDetails!['animalType'];
      quantity = formDetails!['quantity'];
      collectedPayment = formDetails!['collectedPayment'];
      notes = formDetails!['notes'];
    }

  }

  bool isFormValid(){

    if(animalType == null){
      return false;
    }

    if(quantity == null || quantity! < 0){
      return false;
    }

    if(collectedPayment == null){
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

  bool doesCreateDeferredPayment(){

    final Map<String, dynamic>? stop = getStop();

    if(stop == null){
      return false;
    }

    if(stop['stopData']['payment'] != collectedPayment){
      return true;
    }   

    return false;

  }
  

}