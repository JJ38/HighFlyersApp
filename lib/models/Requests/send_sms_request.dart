import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SendSMSRequest extends JSONRequest{

  SendSMSRequest({message = ""}){
    setBody({"message": message});
  }

  @override
  String getEndpoint(){

    String? endpoint = "";

    try{

      endpoint = dotenv.env['SEND_SMS_ENDPOINT'];

    }catch(error, stack){
      
      Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('send_sms_request_error', {
            'module': 'send_sms_request',
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