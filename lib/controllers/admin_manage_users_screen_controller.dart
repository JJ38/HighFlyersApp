import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/change_user_password_dialog_box.dart';
import 'package:high_flyers_app/components/delete_user_dialog_box.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/admin_manage_users_screen_model.dart';

class AdminManageUsersScreenController {

  final AdminManageUsersScreenModel model = AdminManageUsersScreenModel();
  final void Function() updateState;

  AdminManageUsersScreenController({required this.updateState});

  void onAddUserTap(){

  }

  void loadUsers() async{

    model.isLoading = true;
    updateState();

    final successfullyLoadedUsers = await model.loadUsers();

    model.isLoading = false;
    updateState();

    if(!successfullyLoadedUsers){
      showToastWidget(ToastNotification(message: "Error loading users", isError: true));
      return;
    }
  }

  void onDeleteUserTap(BuildContext context, dynamic userDoc){

    showDialog(
      context: context, 
      builder: (context){
        return DeleteUserDialogBox(onDeleteUserSlide: onDeleteUserSlide,);
      }
    );
  }

  void onDeleteUserSlide(ActionSliderController controller) async{
    print("delete user");
  }

  void onChangeUserPasswordTap(BuildContext context, dynamic userDoc){

    print(userDoc.id);

    showDialog(
      context: context, 
      builder: (context){
        return ChangeUserPasswordDialogBox(uid: userDoc.id);
      }
    );
  }


}