class StopFormDialogModel { 

  Map<String, dynamic> stop;
  String? animalType;
  String? quantity;
  bool? collectedPayment;
  String? notes;

  StopFormDialogModel({required this.stop}){

    Map<String, dynamic>? formDetails = stop['formDetails'];

    if(formDetails == null){
      return;
    }

    animalType = formDetails['animalType'];
    quantity = formDetails['quantity'].toString();
    collectedPayment = formDetails['collectedPayment'];
    notes = formDetails['notes'];

  }

}