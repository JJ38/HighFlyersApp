class StopFormModel {

  String? animalType;
  int? quantity;
  bool? collectedPayment;
  String? notes;
  Future<bool> Function()? completeStop;

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
  
    return true;

  }
  

}