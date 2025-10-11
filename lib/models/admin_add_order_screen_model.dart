import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:high_flyers_app/models/order_model_abstract.dart';
import 'package:high_flyers_app/models/validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AdminAddOrderScreenModel extends OrderModel{

  final storeOrderEndpoint = "https://api-qjydin7gka-uc.a.run.app/storeorder"; 

  @override
  Future<bool> submitRequest(String token) async {
    
    try{

      // final storeOrderEndpoint = dotenv.env['STORE_ORDER_ENDPOINT'];
      final storeOrderEndpoint = "https://api-qjydin7gka-uc.a.run.app/storeorder";

      print(storeOrderEndpoint);

      if(storeOrderEndpoint == null){
        return false;
      }

      final url = Uri.parse(storeOrderEndpoint);

      super.response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "profileEmail": email,
          "orderDetails": [getOrderJSON()]
        }),
      );
    
    }catch(e){

      return false;

    }

    return true;

  }

}