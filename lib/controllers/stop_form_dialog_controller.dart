import 'package:flutter/material.dart';
import 'package:high_flyers_app/models/stop_form_dialog_model.dart';

class StopFormDialogController {

  late StopFormDialogModel model;
  Map<String, dynamic> stop;
  void Function() updateState;
  
  StopFormDialogController({required this.updateState, required this.stop}){
    model = StopFormDialogModel(stop: stop);
  }

  void closeDialog(BuildContext context){

    if(context.mounted){
      Navigator.of(context).pop();
    }

  }

}