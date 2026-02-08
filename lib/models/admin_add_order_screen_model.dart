import 'package:high_flyers_app/models/Requests/add_order_request.dart';
import 'package:high_flyers_app/models/order_model_abstract.dart';



class AdminAddOrderScreenModel extends OrderModel{

  AddOrderRequest getAddOrderRequest(){
    return AddOrderRequest(order: getOrder());
  }

}