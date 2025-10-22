import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
      
    }catch(error, stack){

      Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('JSONRequest_error', {
            'module': 'JSONRequest',
            'details': error.toString(),
            'environment': environment
          });
        },
      );
      
      print(error);
      
    }

    requestBody.addAll({'environment': environment});
    body = jsonEncode(requestBody);
  }

}