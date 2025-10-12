import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/controllers/order_controller_abstract.dart';
import 'package:high_flyers_app/models/admin_edit_order_screen_model.dart';
import 'package:high_flyers_app/models/order_model_abstract.dart';

class AdminEditOrderScreenController extends OrderController {

  Map<String, dynamic> order;
  String uuid;

  AdminEditOrderScreenController({required super.updateState, required this.order, required this.uuid});

  @override
  OrderModel createModel(){
    return AdminEditOrderScreenModel(order: order, uuid: uuid);
  }

  void onBackArrowTap(context){

    Navigator.pop(context);

  }

  
  @override
  void submitOrder(context) async {

    final isValidOrder = model.validateOrder();

    if(!isValidOrder){
      showToastWidget(ToastNotification(message: model.errorMessage, isError: true));
      return;
    }

    model.isSubmitting = true;
    updateState();

    final submittedOrdersSuccessfully = await model.submitOrder();

    model.isSubmitting = false;

    if(!submittedOrdersSuccessfully){

      showToastWidget(ToastNotification(message: "Error editing order", isError: true));
      updateState();

      return;

    }

    showToastWidget(ToastNotification(message: "Successfully updated order", isError: false));

    Navigator.pop(context);

  }

}