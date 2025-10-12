import 'package:high_flyers_app/models/Requests/request_abstract.dart';

class EditOrderRequest extends JSONRequest{

  final Map<String, dynamic> order;
  final String uuid;

  EditOrderRequest({required this.order, required this.uuid}){
    setBody({"orderDetails": order, "uuid": uuid});
  }

  @override
  String get endpoint => "https://api-qjydin7gka-uc.a.run.app/editorder";

}