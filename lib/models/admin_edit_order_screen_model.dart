
import 'package:high_flyers_app/models/Requests/delete_order_request.dart';
import 'package:high_flyers_app/models/Requests/edit_order_request.dart';
import 'package:high_flyers_app/models/order_model_abstract.dart';


class AdminEditOrderScreenModel extends OrderModel {

  Map<String, dynamic> order;
  String uuid;
  bool isDeleting = false;

  EditOrderRequest getEditOrderRequest(){
    return EditOrderRequest(order: getOrder(), uuid: uuid);
  }

  DeleteOrderRequest getDeleteOrderRequest(){
    return DeleteOrderRequest(uuid: uuid);
  }

  bool getIsDeleting(){
    return isDeleting;
  }

  AdminEditOrderScreenModel({required this.order, required this.uuid}){

    animalType = order['animalType'];
    quantity = order['quantity'].toString();
    code = order['code'];
    boxes = order['boxes'].toString();
    email = order['email'];
    account = order['account'];
    deliveryWeek = order['deliveryWeek'].toString();
    collectionName = order['collectionName'];
    collectionAddressLine1 = order['collectionAddress1'];
    collectionAddressLine2 = order['collectionAddress2'];
    collectionAddressLine3 = order['collectionAddress3'];
    collectionPostcode = order['collectionPostcode'];
    collectionPhoneNumber = order['collectionPhoneNumber'];
    deliveryName = order['deliveryName'];
    deliveryAddressLine1 = order['deliveryAddress1'];
    deliveryAddressLine2 = order['deliveryAddress2'];
    deliveryAddressLine3 = order['deliveryAddress3'];
    deliveryPostcode = order['deliveryPostcode'];
    deliveryPhoneNumber = order['deliveryPhoneNumber'];
    payment = order['payment'];
    price = order['price'].toString();
    message = order['message'];

  }

}