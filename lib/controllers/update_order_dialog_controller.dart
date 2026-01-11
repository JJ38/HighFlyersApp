import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/controllers/order_controller_abstract.dart';
import 'package:high_flyers_app/models/update_order_dialog_model.dart';

class UpdateOrderDialogController extends OrderController<UpdateOrderDialogModel>{

  Map<String, dynamic> order;
  Map<String, dynamic> runData;
  String orderID;
  String runID;


  UpdateOrderDialogController({required super.updateState, required this.order, required this.orderID, required this.runID, required this.runData});

  
  @override
  UpdateOrderDialogModel createModel(){
    return UpdateOrderDialogModel(order: order, orderID: orderID, runID: runID, runData: runData);
  }
  
  @override
  void submitOrder(context) async {

    print("submitOrder");
    
    if(model.payment == "Collection"){
      model.payment = "Pickup";
    }

    final isValidOrder = model.validateOrder();

    if(!isValidOrder){
      showToastWidget(ToastNotification(message: model.errorMessage, isError: true));
      return;
    }

    model.isSubmitting = true;
    // updateState(); 

    final successfullyUpdateOrderAndRuns = await model.updateOrderAndRuns();

    model.isSubmitting = false;
    // updateState();

    if(!successfullyUpdateOrderAndRuns){
      showToastWidget(ToastNotification(message: "Error updating order and runs", isError: true));
      return;
    }

  }

}