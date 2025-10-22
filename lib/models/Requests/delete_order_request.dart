
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DeleteOrderRequest extends JSONRequest{

  final String uuid;

  DeleteOrderRequest({required this.uuid}){
    setBody({"uuid": uuid});
  }

  @override
  String getEndpoint(){

    String? endpoint = "";

    try{

      endpoint = dotenv.env['DELETE_ORDER_ENDPOINT'];

    }catch(error, stack){

      Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('delete_order_request_error', {
            'module': 'delete_order_request',
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