import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';
import 'package:sentry_flutter/sentry_flutter.dart';


class CustomerOrderRequest extends JSONRequest{

  final List<dynamic> orders;
  final String profileEmail;

  CustomerOrderRequest({required this.orders, required this.profileEmail}){
    setBody({"orderDetails": orders, "profileEmail": profileEmail});
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
          scope.setContexts('customer_order_request_error', {
            'module': 'customer_order_request',
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