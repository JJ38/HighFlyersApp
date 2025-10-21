import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/delete_user_dialog_box_model.dart';

class DeleteUserDialogBoxController {

  final DeleteUserDialogBoxModel model = DeleteUserDialogBoxModel();
  final void Function() updateState;
  final void Function() loadUsers;

  DeleteUserDialogBoxController({required this.updateState, required this.loadUsers});

  void deleteUser(BuildContext context, ActionSliderController slideController) async{

    slideController.loading();

    final successfullyDeleteUser = await model.deleteUser();

    if(!successfullyDeleteUser){
      showToastWidget(ToastNotification(message: "Error deleting user", isError: true));
      slideController.reset();
      return;
    }

    slideController.success();

    showToastWidget(ToastNotification(message: "Successfully deleted user", isError: false));

    loadUsers();

    if(context.mounted){
      Navigator.of(context).pop();
    }

  }

}