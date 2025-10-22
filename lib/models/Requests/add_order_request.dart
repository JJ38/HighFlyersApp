import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AddOrderRequest extends JSONRequest{

  final Map<String, dynamic> order;

  AddOrderRequest({required this.order}){
    setBody({"orderDetails": [order]});
  }

  @override
  String getEndpoint(){

    String? endpoint = "";

    try{

      endpoint = dotenv.env['STORE_ORDER_ENDPOINT'];

    }catch(error, stack){
      
      Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('store_order_request_error', {
            'module': 'store_order_request',
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