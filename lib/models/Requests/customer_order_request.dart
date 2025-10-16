import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';


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

    }catch(e){
      print(e);
    }

    return endpoint ?? "";

  }

}