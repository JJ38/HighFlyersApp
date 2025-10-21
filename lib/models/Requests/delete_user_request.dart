import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';

class DeleteUserRequest extends JSONRequest {

  final String uid;
  final String role;

  DeleteUserRequest({required this.uid, required this.role}){
    setBody({"uid": uid, "role": role});
  }


  @override
  String getEndpoint(){

    String? endpoint = "";

    try{

      endpoint = dotenv.env['DELETE_USER_ENDPOINT'];

    }catch(e){
      print(e);
    }

    return endpoint ?? "";

  }

}