import 'dart:convert';

import 'package:high_flyers_app/models/order_model_abstract.dart';
import 'package:http/http.dart' as http;


class AdminEditOrderScreenModel extends OrderModel {

  Map<String, dynamic> order;
  String uuid;

  AdminEditOrderScreenModel({required this.order, required this.uuid}){

    animalType = order['animalType'];
    quantity = order['quantity'].toString();
    code = order['code'];
    boxes = order['boxes'].toString();
    email = order['email'];
    account = order['account'];
    deliveryWeek = order['deliveryWeek'].toString();
    collectionName = order['collectionName'];
    collectionAddressLine1 = order['collectionAddress1'];
    collectionAddressLine2 = order['collectionAddress2'];
    collectionAddressLine3 = order['collectionAddress3'];
    collectionPostcode = order['collectionPostcode'];
    collectionPhoneNumber = order['collectionPhoneNumber'];
    deliveryName = order['deliveryName'];
    deliveryAddressLine1 = order['deliveryAddress1'];
    deliveryAddressLine2 = order['deliveryAddress2'];
    deliveryAddressLine3 = order['deliveryAddress3'];
    deliveryPostcode = order['deliveryPostcode'];
    deliveryPhoneNumber = order['deliveryPhoneNumber'];
    payment = order['payment'];
    price = order['price'].toString();
    message = order['message'];

  }

  @override
  Future<bool> submitRequest(String token) async {
    
    try{

      // final editOrderEndpoint = dotenv.env['EDIT_ORDER_ENDPOINT'];
      final editOrderEndpoint = "https://api-qjydin7gka-uc.a.run.app/editorder";

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
          "orderDetails": getOrderJSON(),
          "uuid": uuid
        }),
      );
    
    }catch(e){

      return false;

    }

    return true;

  }

}