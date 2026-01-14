import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/login_model.dart';
import 'package:high_flyers_app/screens/admin/admin_screen.dart';
import 'package:high_flyers_app/screens/customer/customer_screen.dart';
import 'package:high_flyers_app/screens/driver/driver_screen.dart';

class LoginScreenController {

  final model = LoginScreenModel();
  final void Function() updateState;

  LoginScreenController({required this.updateState});

  void usernameInputController(String username) {
    model.username = username;
  }

  void passwordInputController(String password) {
    model.password = password;
  }


  //This code is essentially deadcode in prod. However leave for debug as AuthBootstrap, which is what makes this code redundant in prod, isnt used in debug. 
  //This is because if AuthBootstap was used in debug on every hot reload a splach screen would show and the state of the application will be lost.
  void login(context) async {

    model.isLoading = true;
    updateState();

    final authenticated = await model.login();

    model.isLoading = false;
    updateState();


    if (!authenticated) {
      
      showToastWidget(
        ToastNotification(message: model.errorMessage!, isError: true),
        context: context,
      );

      return;

    }

    if(kDebugMode){
      //If in prod a different auth flow is being used to handle auto sign in on cold restart
      return;
    }

    if (model.role == "driver") {

      Navigator.pushNamed(context, DriverScreen.id);

    } else if (model.role == "customer") {

      Navigator.pushNamed(context, CustomerScreen.id);

    } else if (model.role == "admin" || model.role == "staff") {

      Navigator.pushNamed(context, AdminScreen.id);

    }

  }
}
