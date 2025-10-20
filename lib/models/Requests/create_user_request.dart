
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';

class CreateUserRequest extends JSONRequest{

  String password;
  String username;
  String role;


  CreateUserRequest({required this.password, required this.username, required this.role}){
    setBody({"password": password, "username": username, "role": role});
  }

  @override
  String getEndpoint(){

    String? endpoint = "";

    try{

      endpoint = dotenv.env['CREATE_USER_ENDPOINT'];

    }catch(e){
      print(e);
    }

    return endpoint ?? "";

  }

}