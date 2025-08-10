import 'package:flutter/widgets.dart';
import 'package:high_flyers_app/models/login_model.dart';
import 'package:high_flyers_app/screens/admin/admin_screen.dart';
import 'package:high_flyers_app/screens/customer/customer_screen.dart';
import 'package:high_flyers_app/screens/driver/driver_screen.dart';

class LoginScreenController {
  final model = LoginScreenModel();

  void usernameInputController(String username) {
    model.username = username;
  }

  void passwordInputController(String password) {
    model.password = password;
  }

  void login(context) async {
    final authenticated = await model.login();

    if (!authenticated) {
      print(model.errorMessage);
      return;
    }

    if (model.role == "driver") {
      Navigator.pushNamed(context, DriverScreen.id);
    } else if (model.role == "customer") {
      Navigator.pushNamed(context, CustomerScreen.id);
    } else if (model.role == "admin") {
      Navigator.pushNamed(context, AdminScreen.id);
    }

    print("authenticated");
  }
}
