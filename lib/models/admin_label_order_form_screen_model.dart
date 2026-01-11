class AdminLabelOrderFormScreenModel {

  Map<String, dynamic> stop;

  final List<String> methodsOfContact = ["Told", "Text", "Voicemail"];
  final List<String> callBeforeArrival = ["Yes", "No"];

  final List<bool> methodOfContactIsSelected = [false, false, false];
  final List<bool> callBeforeArrivalIsSelected = [false, false];

  bool shouldShowNoticeInput = false;
  String message = "";

  AdminLabelOrderFormScreenModel({required this.stop});

  void methodOfContactOnPressed(int index){

    for(int i = 0; i < methodOfContactIsSelected.length; i++){

      if(i == index){
        methodOfContactIsSelected[i] = true;
      }else{
        methodOfContactIsSelected[i] = false;
      }

    }

  }

  
  void callBeforeArrivalOnPressed(int index){

    for(int i = 0; i < callBeforeArrivalIsSelected.length; i++){

      if(i == index){
        callBeforeArrivalIsSelected[i] = true;
      }else{
        callBeforeArrivalIsSelected[i] = false;
      }

    }

    if(callBeforeArrival[index] == "Yes"){
      shouldShowNoticeInput = true;
      return;
    }

    shouldShowNoticeInput = false;

  }

  void onMessageChange(String input){
    message = input;
    print(message);
  }
  
}