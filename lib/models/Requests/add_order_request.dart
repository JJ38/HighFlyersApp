import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';

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

    }catch(e){
      print(e);
    }

    return endpoint ?? "";

  }

}