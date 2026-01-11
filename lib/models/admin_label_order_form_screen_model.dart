import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdminLabelOrderFormScreenModel {

  final String runDocID;
  late Map<String, dynamic> stop;
  late Map<String, dynamic> runData;

  final List<String> methodsOfContact = ["told", "text", "voicemail"];
  final List<String> callBeforeArrival = ["yes", "no"];

  final List<bool> methodOfContactIsSelected = [false, false, false];
  final List<bool> callBeforeArrivalIsSelected = [false, false];

  bool shouldShowNoticeInput = false;
  String message = "";
  String noticePeriod = "";

  AdminLabelOrderFormScreenModel({required this.runDocID, required this.stop, required this.runData});
  

  void setFormData(){

    final initialLabelData = stop['label'];

    print(initialLabelData);

    if(initialLabelData == null){
      print("No previous label data");
      return;
    }

    final int methodOfContactIndex = findIndexOfValue(methodsOfContact, initialLabelData['methodOfContact']);
    final int callBeforeArrivalIndex = findIndexOfValue(callBeforeArrival, initialLabelData['arrivalNotice']);

    if(methodOfContactIndex != -1){
      methodOfContactIsSelected[methodOfContactIndex] = true;
    }

    if(callBeforeArrivalIndex != -1){
      callBeforeArrivalIsSelected[callBeforeArrivalIndex] = true;

      if(callBeforeArrival[callBeforeArrivalIndex] == "yes"){
        shouldShowNoticeInput = true;
        noticePeriod = initialLabelData['noticePeriod'] ?? "";
        print(noticePeriod);
      }

    }

    message = initialLabelData['message'] ?? "";

    print("shouldShowNoticeInput: $shouldShowNoticeInput");

  }

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

    if(callBeforeArrival[index] == "yes"){
      shouldShowNoticeInput = true;
      return;
    }

    shouldShowNoticeInput = false;

  }

  void onMessageChange(String input){
    message = input;
  }

  void noticePeriodOnChange(String input){
    noticePeriod = input;
  }

  Future<bool> saveLabel() async{
        
    final indexOfMethodOfContact = findIndexOfValue(methodOfContactIsSelected, true);

    if(indexOfMethodOfContact == -1){
      debugPrint("indexOfMethodOfContact == -1");
      return false;
    }

    final indexOfArrivalNotice = findIndexOfValue(callBeforeArrivalIsSelected, true);

    if(indexOfArrivalNotice == -1){
      debugPrint("indexOfArrivalNotice == -1");
      return false;
    }

    try{

      final databaseName = dotenv.env['DATABASE_NAME'];

      if(databaseName == null){
        return false;
      }

      //create copy of list of stops
      final stopsCopy = List<dynamic>.from(runData['stops']);
    
      //add label
      Map<String, dynamic> label = {
        "message": message,
        "methodOfContact": methodsOfContact[indexOfMethodOfContact],
        "arrivalNotice": callBeforeArrival[indexOfArrivalNotice],
      };

      if(callBeforeArrival[indexOfArrivalNotice] == "yes"){
        label.addAll({"noticePeriod": noticePeriod});
      }

      stop['label'] = label;
      
      bool foundStop = false;

      for(int i = 0; i <  stopsCopy.length; i++){

        if(stopsCopy[i]['orderID'] == stop['orderID']){
          stopsCopy[i] = stop;
          foundStop = true;
          break;
        }

      }

      if(!foundStop){
        return false;
      }

      //attempt save
      DocumentReference<Map<String, dynamic>> runDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Runs').doc(runDocID);

      runDocRef.update(
        {
          "stops": stopsCopy
        }
      );

      //update client


    }catch(error, stack){

      return false;
    }

    return true;

  }

  int findIndexOfValue(list, value){

    for(int i = 0; i < list.length; i++){
      if(list[i] == value){
        return i;
      }
    }

    return -1;

  }
  
}