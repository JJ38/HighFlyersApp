import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';

class EditOrderRequest extends JSONRequest{

  final Map<String, dynamic> order;
  final String uuid;

  EditOrderRequest({required this.order, required this.uuid}){
    setBody({"orderDetails": order, "uuid": uuid});
  }


  @override
  String getEndpoint(){

    String? endpoint = "";

    try{

      endpoint = dotenv.env['EDIT_ORDER_ENDPOINT'];

    }catch(e){
      print(e);
    }

    return endpoint ?? "";

  }

}