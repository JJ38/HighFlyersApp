import 'package:high_flyers_app/models/login_screen_model.dart';

class LoginScreenController {

  final model = LoginScreenModel();

  void usernameInputController(String username){
    
    model.username = username;

  }

  void passwordInputController(String password){
    
    model.password = password;

  }


  void login(){

    print(model.username);
    print(model.password);


  }

}