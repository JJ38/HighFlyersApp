import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/add_user_dialog_box_model.dart';

class AddUserDialogBoxController{

  final AddUserDialogBoxModel model = AddUserDialogBoxModel();
  final void Function() updateState;
  final void Function() loadUsers;


  AddUserDialogBoxController({required this.updateState, required this.loadUsers});


  void onRoleSelect(String? input){
    model.role = input;
  }

  void onUsernameChange(String? input){
    model.username = input;
  }

  void onPasswordChange(String? input){
    model.password = input;
  }

  void onConfirmPasswordChange(String? input){
    model.confirmPassword = input;
  }

  void onCreateUserTap(BuildContext context) async {

    //check password and confirm password are the same
    final validationMessage = model.validateUserDetails();

    if(validationMessage != null){
      showToastWidget(ToastNotification(message: validationMessage, isError: true));
      return;
    }
    
    model.isCreatingUser = true;
    updateState();

    final successfullyCreatedUser = await model.createUser();

    model.isCreatingUser = false;
    updateState();
    
    if(!successfullyCreatedUser){
      showToastWidget(ToastNotification(message: "Error creating user", isError: true));
      return;
    }

    showToastWidget(ToastNotification(message: "Successfully created user", isError: false));

    loadUsers();

    if(context.mounted){
      Navigator.of(context).pop();
    } 
  }

  void validateCreateUserForm(){

    if(model.password != model.confirmPassword){
      showToastWidget(ToastNotification(message: "Password and confirm password must be the same", isError: true));
      return;
    }

  }

}