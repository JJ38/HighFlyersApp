import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/run_model.dart';

class RunScreenController {

  final RunModel model = RunModel();
  final List<bool> selectedToggleView = <bool>[true, false, false];
  int currentSelectedIndex = 0;

  RunScreenController();

  void toggleRunViewButtonsController(selectedIndex){

    // The button that is tapped is set to true, and the others to false.
    for (int i = 0; i < selectedToggleView.length; i++) {

      if(i == selectedIndex){

        selectedToggleView[i] = true;
        currentSelectedIndex = i;
        
      }else{
        selectedToggleView[i] = false;
      } 

    }
    
  }

  void startRun(context) async{

    //write to document to say run has started

    final bool runStarted = await model.startRun();

    if(!runStarted){
  
      showToastWidget(
        ToastNotification(message: 'Error starting run', isError: true),
        context: context
      );

    }

    //update stop screen to shjow details of first stop. This can show another button saying start stop

  }

}