import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/controllers/order_controller_abstract.dart';
import 'package:high_flyers_app/models/update_order_dialog_model.dart';

class UpdateOrderDialogController extends OrderController<UpdateOrderDialogModel>{
  
  final void Function() markAsUnassignedCallback;
  final bool hasPreviouslyBeenMarkedAsUnassigned;
  Map<String, dynamic> stop;
  Map<String, dynamic> runData;
  String orderID;
  String runID;


  UpdateOrderDialogController({
    required super.updateState, 
    required this.stop, 
    required this.orderID, 
    required this.runID, 
    required this.runData, 
    required this.markAsUnassignedCallback, 
    required this.hasPreviouslyBeenMarkedAsUnassigned}
  );

  
  @override
  UpdateOrderDialogModel createModel(){
    return UpdateOrderDialogModel(stop: stop, orderID: orderID, runID: runID, runData: runData, markAsUnassignedCallback: markAsUnassignedCallback, hasPreviouslyBeenMarkedAsUnassigned: hasPreviouslyBeenMarkedAsUnassigned);
  }
  
  @override
  void submitOrder(context) async {

    
    if(model.payment == "Collection"){
      model.payment = "Pickup";
    }

    final Map<String, dynamic> formOrder = model.getOrder();
    final initialOrder = stop['orderData'];

    final hasCriticalStopInfoChanged = model.doRunsNeedUpdating(formOrder, initialOrder);

    if(hasCriticalStopInfoChanged){
      showToastWidget(ToastNotification(message: "Please complete the label form before changing critical stop info", isError: true));
      return;
    }


    final isValidOrder = model.validateOrder();

    if(!isValidOrder){
      showToastWidget(ToastNotification(message: model.errorMessage.toString(), isError: true));
      return;
    }

    model.isSubmitting = true;
    updateState(); 

    final successfullyUpdateOrderAndRuns = await model.updateOrderAndRuns();

    model.isSubmitting = false;
    updateState();

    if(!successfullyUpdateOrderAndRuns){
      showToastWidget(ToastNotification(message: "Error updating order and runs - ${model.updateOrderErrorMessage}", isError: true));
      return;
    }

    showToastWidget(ToastNotification(message: "Successfully updated order and runs", isError: false));
    Navigator.of(context).pop();
    
  }

}