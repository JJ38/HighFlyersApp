import 'dart:convert';
import 'package:flutter/widgets.dart';

abstract class JSONRequest{

  String get endpoint;
  Map<String, String> headers = {'Content-Type': 'application/json',};
  String? body;
  
  void setBearerHeader(String bearerToken){
    headers['Authorization'] = "Bearer $bearerToken";
  }

  void setBody(Map<String, dynamic> requestBody){
    body = jsonEncode(requestBody);
  }

}