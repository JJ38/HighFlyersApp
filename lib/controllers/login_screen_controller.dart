import 'package:high_flyers_app/models/login_screen_model.dart';

class LoginScreenController {

  final model = LoginScreenModel();

  void usernameInputController(String username){
    
    model.username = username;

  }

  void passwordInputController(String password){
    
    model.password = password;

  }


  void login() async {

    final authenticated = await model.login();

    if(!authenticated){
      print(model.errorMessage);
      return;
    }

    print("authenticated");

  }

}