import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/change_password_dialog_box_model.dart';

class ChangePasswordDialogBoxController {

  final ChangePasswordDialogBoxModel model = ChangePasswordDialogBoxModel();
  final void Function() updateState;

  ChangePasswordDialogBoxController({required this.updateState});

  
  void onPasswordChange(String input){

    model.newPassword = input;

  }


  void onUpdatePasswordTap(BuildContext context, String uid) async{

    model.isUpdatingPassword = true;
    updateState();

    print("onUpdatePasswordTap");

    final updatedPasswordSuccessfully = await model.updateUserPassword(uid);

    model.isUpdatingPassword = false;
    updateState();

    if(!updatedPasswordSuccessfully){
      showToastWidget(ToastNotification(message: "Error updating user password", isError: true)); 
      return;
    }

    showToastWidget(ToastNotification(message: "Successfully updated user password", isError: false));

    if(context.mounted){
      Navigator.of(context).pop();
    } 

  }
  
}