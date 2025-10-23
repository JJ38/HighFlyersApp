import 'package:flutter_test/flutter_test.dart';
import 'package:high_flyers_app/models/current_stop_model.dart';
import 'package:high_flyers_app/models/customer_profile_screen_model.dart';
import 'package:high_flyers_app/screens/customer/customer_profile_screen.dart';


void main() {

  final CurrentStopModel currentStopModel = CurrentStopModel();

  final Map<String, dynamic> stop = {

    "orderID": "esntobsegsefTESTIDesiofniosenfiose",
    "orderData": "Test order data",

  };

  final Map<String, dynamic> formDetails = {};


  group('deferred payment test', () {

    test('Should return null - no deferred payment needed', () {
      
      stop.addAll({
        "stopType": "collection"
      });

      formDetails.addAll({
        "collectedPayment": true
      });

      expect(currentStopModel.shouldDeferPayment("Complete", stop, formDetails, true), null);
    });

    test('Should return null - no deferred payment needed', () {
      
      stop.addAll({
  
        "stopType": "delivery"
      });

      formDetails.addAll({
        "collectedPayment": true
      });

      expect(currentStopModel.shouldDeferPayment("Complete", stop, formDetails, true), null);
    });

    test('Should return null - no deferred payment needed', () {
      
      stop.addAll({
        "stopType": "collection"
      });

      formDetails.addAll({
        "collectedPayment": true
      });

      expect(currentStopModel.shouldDeferPayment("Skipped", stop, formDetails, true), null);
    });

    test('Should return null - no deferred payment needed', () {
      
      stop.addAll({
        "stopType": "collection"
      });

      formDetails.addAll({
        "collectedPayment": false
      });

      expect(currentStopModel.shouldDeferPayment("Skipped", stop, formDetails, true), null);
    });





    test('Should return deferred payment of true (early) - deferred payment needed', () {
      
      stop.addAll({
        "stopType": "collection"
      });

      formDetails.addAll({
        "collectedPayment": true
      });

      final Map<String, dynamic>? deferredPaymentDoc = currentStopModel.shouldDeferPayment("Complete", stop, formDetails, false); //last is expected payment

      expect(deferredPaymentDoc?['deferredPaymentType'], true);
    });


    test('Should return deferred payment of false (late) - deferred payment needed', () {
      
      stop.addAll({
        "stopType": "collection"
      });

      formDetails.addAll({
        "collectedPayment": false
      });

      final Map<String, dynamic>? deferredPaymentDoc = currentStopModel.shouldDeferPayment("Complete", stop, formDetails, true);

      expect(deferredPaymentDoc?['deferredPaymentType'], false);
    });

  });
}