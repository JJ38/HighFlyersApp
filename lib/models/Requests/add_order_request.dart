import 'package:high_flyers_app/models/Requests/request_abstract.dart';

class AddOrderRequest extends JSONRequest{

  final Map<String, dynamic> order;

  AddOrderRequest({required this.order}){
    setBody({"orderDetails": [order]});
  }

  @override
  String get endpoint => "https://api-qjydin7gka-uc.a.run.app/storeorder";

}