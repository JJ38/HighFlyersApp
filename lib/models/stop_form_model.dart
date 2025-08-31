class StopFormModel {

  String? animalType;
  int? quantity;
  bool? collectedPayment;
  String? notes;
  Map<String, dynamic>? formDetails;
  Future<bool> Function(Map<String, dynamic>?)? completeStop;

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
      'notes': notes
    };
  
    return true;

  }
  

}