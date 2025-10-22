
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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

    }catch(error, stack){

      Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('create_user_request_error', {
            'module': 'create_user_request',
            'details': error.toString(),
            'endpoint': endpoint
          });
        },
      );
      
      print(error);
      
    }

    return endpoint ?? "";

  }

}