import 'package:high_flyers_app/models/Requests/create_user_request.dart';
import 'package:high_flyers_app/models/request_model.dart';
import 'package:high_flyers_app/models/validator.dart';

class AddUserDialogBoxModel extends RequestModel{

  String? role;
  String? username;
  String? password;
  String? confirmPassword;
  bool isCreatingUser = false;

  Future<bool> createUser() async{


    try{

      final createUserRequest = CreateUserRequest(password: password!, username: username!, role: role!);
      final bool successfullyCreatedUser = await submitAuthenticatedRequest(createUserRequest);

      if(!successfullyCreatedUser){
        return false;
      }

      return true;

    }catch(e){

      print(e);
      return false;

    }

  }

  String? validateUserDetails(){

    final Validator validator = Validator();

    print(!validator.isValidString(password));

    if(!validator.isValidString(username)){
      return "Please enter a username";
    }

    if(!validator.isValidString(password)){
      return "Please enter a password";
    }

    if(!validator.isValidString(role)){
      return "Please select a role";
    }

    if(password != confirmPassword){
      return "Password and confirm password must be the same";
    }

    if(password!.length < 6){
      return "Password must be greate than 6 characters";
    }

    return null;
  }

}