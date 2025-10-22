import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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

    }catch(error, stack){
      Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('update_user_request_error', {
            'module': 'update_user_request',
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