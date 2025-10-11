import 'dart:convert';

import 'package:high_flyers_app/models/order_model_abstract.dart';

class AdminEditOrderScreenModel extends OrderModel {
  get http => null;


  // Map<String, dynamic>? order;

  @override
  Future<bool> submitRequest(String token) async {
    
    try{

      // final editOrderEndpoint = dotenv.env['EDIT_ORDER_ENDPOINT'];
      final editOrderEndpoint = "https://api-qjydin7gka-uc.a.run.app/storeorder";

      if(editOrderEndpoint == null){
        return false;
      }

      final url = Uri.parse(editOrderEndpoint);

      super.response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "orderDetails": [getOrderJSON()]
        }),
      );
    
    }catch(e){

      return false;

    }

    return true;

  }

}