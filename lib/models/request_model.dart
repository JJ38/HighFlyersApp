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
      Sentry.logger.fmt.error("Attempted authenticated request - User token is null %s", [user.toString()]);
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

    String endpoint = request.getEndpoint();

    Sentry.logger.fmt.info("Attempting %s request %s %s", [endpoint, request.headers, request.body]);

    try{

      final url = Uri.parse(endpoint);

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
            'endpoint': request.getEndpoint(),
            'request': request
          });
        },
      );
      
      print(error);
      
      return false;
    }

  }

}