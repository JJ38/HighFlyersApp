
import 'package:high_flyers_app/models/Requests/request_abstract.dart';

class DeleteOrderRequest extends JSONRequest{

  final String uuid;

  DeleteOrderRequest({required this.uuid}){
    setBody({"uuid": uuid});
  }

  @override
  String get endpoint => "https://api-qjydin7gka-uc.a.run.app/deleteorder";

}