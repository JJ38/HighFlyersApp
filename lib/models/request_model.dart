import 'package:firebase_auth/firebase_auth.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

class RequestModel {

  http.Response? response;

  Future<bool> submitAuthenticatedRequest(JSONRequest request) async {

    final user = FirebaseAuth.instance.currentUser;
    String? token = await user?.getIdToken();

    if(token == null){
      return false;
    }

    request.setBearerHeader(token);  

    final successfullySentRequest = await submitRequest(request);

    print(successfullySentRequest);

    if(!successfullySentRequest || response == null){
      return false;
    }

    if (response!.statusCode == 200) {

      print('Response: ${response!.body}');

    } else {

      print('Error: ${response!.statusCode} - ${response!.body}');
      return false;

    }

    return true;
    
  }

  
  Future<bool> submitRequest(JSONRequest request) async{

    try{

      final url = Uri.parse(request.getEndpoint());

      response = await http.post(
        url,
        headers: request.headers,
        body: request.body,
      );
    
      return true;

    }catch(error, stack){

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('request_error', {
            'module': 'request',
            'details': error.toString(),
            'endpoint': request.getEndpoint()
          });
        },
      );
      
      print(error);
      
      return false;
    }

  }

}