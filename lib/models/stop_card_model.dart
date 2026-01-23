import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StopCardModel {

  Map<String, dynamic> stop;
  Map<String, dynamic>? runData;
  String? progressedRunID;
  bool expandCard = false;
  late bool shouldHighlightStop; 

  StopCardModel({required this.stop, required this.runData, required this.progressedRunID}){
    shouldHighlightStop = stop['label']?['arrivalNotice'] == "yes" || stop['label']?['message'] != "" && stop['label']?['message'] != null;
    print(runData);
    print(progressedRunID);

  }
  

  Future<bool> callCustomer() async {

    try{

      final String? customerPhoneNumber = stop['stopData']?['phoneNumber'];

      if(customerPhoneNumber == null){
        return false;
      }
      
      final Uri uriPhoneNumber = Uri(scheme: 'tel', path: customerPhoneNumber);

      if (await canLaunchUrl(uriPhoneNumber)) {

        await launchUrl(uriPhoneNumber);

      } else {

        throw Exception("Error calling customer phonenumber");

      }

      return true;

    }catch(error, stack){

      print(error);

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('stop_card', {
            'module': 'stop_card',
            'details': error.toString(),
          });
        },
      );

      return false;

    }


  }

}