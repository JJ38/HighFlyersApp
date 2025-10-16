import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class JSONRequest{

  Map<String, String> headers = {'Content-Type': 'application/json',};
  String? body;


  String getEndpoint();
  
  void setBearerHeader(String bearerToken){
    headers['Authorization'] = "Bearer $bearerToken";
  }

  void setBody(Map<String, dynamic> requestBody){

    String environment = "";

    try{

      environment = dotenv.env['ENVIRONMENT'] ?? "";
      
    }catch(e){
      print(e);
    }

    requestBody.addAll({'environment': environment});
    body = jsonEncode(requestBody);
  }


}