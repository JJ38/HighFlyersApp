
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';

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
      print("using dotenv");

    }catch(e){
      print(e);
    }

    return endpoint ?? "";

  }

}