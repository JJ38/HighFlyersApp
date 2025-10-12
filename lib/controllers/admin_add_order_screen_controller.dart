import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/controllers/order_controller_abstract.dart';
import 'package:high_flyers_app/models/Requests/add_order_request.dart';
import 'package:high_flyers_app/models/admin_add_order_screen_model.dart';
import 'package:high_flyers_app/models/order_model_abstract.dart';

class AdminAddOrderScreenController extends OrderController<AdminAddOrderScreenModel> {

  AdminAddOrderScreenController({required super.updateState});

  @override
  AdminAddOrderScreenModel createModel(){
    return AdminAddOrderScreenModel();
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

    final request = model.getAddOrderRequest();
    final submittedOrdersSuccessfully = await model.submitOrder(request);

    model.isSubmitting = false;

    if(!submittedOrdersSuccessfully){

      showToastWidget(ToastNotification(message: "Error adding order", isError: true));
      updateState();

      return;

    }

    showToastWidget(ToastNotification(message: "Successfully added order", isError: false));

    Navigator.pop(context);

  }

}