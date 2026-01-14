import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/auth_model.dart';
import 'package:high_flyers_app/screens/login_screen.dart';

class AuthController {

  AuthController();

  static void signOut() async {

    final signedOutSuccessfully = await AuthModel.signOut();

    if(!signedOutSuccessfully){
      showToastWidget(ToastNotification(message: "Error signing out", isError: true));
    }

    // Navigator.of(context).pushNamedAndRemoveUntil(
    //   LoginScreen.id,
    //   (route) => false,
    // );

  }

}