import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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

    }catch(error, stack){

      Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('delete_user_request_error', {
            'module': 'delete_user_request',
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