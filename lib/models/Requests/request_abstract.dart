import 'dart:convert';
import 'package:flutter/widgets.dart';

abstract class JSONRequest{

  Map<String, String> headers = {'Content-Type': 'application/json',};
  String? body;


  String getEndpoint();
  
  void setBearerHeader(String bearerToken){
    headers['Authorization'] = "Bearer $bearerToken";
  }

  void setBody(Map<String, dynamic> requestBody){
    body = jsonEncode(requestBody);
  }


}