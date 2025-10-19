import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';

class UpdateUserPasswordRequest extends JSONRequest{

  final String uid;
  final String newPassword;

  UpdateUserPasswordRequest({required this.uid, required this.newPassword}){
    setBody({"uid": uid, "newPassword": newPassword});
  }

  @override
  String getEndpoint(){

    String? endpoint = "";

    try{

      endpoint = dotenv.env['UPDATE_USER_PASSWORD_ENDPOINT'];

    }catch(e){
      print(e);
    }

    return endpoint ?? "";

  }

}