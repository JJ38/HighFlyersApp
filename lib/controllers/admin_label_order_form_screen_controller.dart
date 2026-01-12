import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/components/update_order_dialog.dart';
import 'package:high_flyers_app/models/admin_label_order_form_screen_model.dart';

class AdminLabelOrderFormScreenController {

  late final AdminLabelOrderFormScreenModel model;
  void Function() updateState;

  
  AdminLabelOrderFormScreenController({required runDocID, required stop, required runData, required this.updateState}){
    model = AdminLabelOrderFormScreenModel(runDocID: runDocID, stop: stop, runData: runData);
  }

  void setFormData(){

    model.setFormData();

  }

  void methodOfContactOnPressed(int index, childWidgetUpdateState){

    model.methodOfContactOnPressed(index);
    childWidgetUpdateState();

  }

  void callBeforeArrivalOnPressed(int index, childWidgetUpdateState){

    model.callBeforeArrivalOnPressed(index);
    updateState();

  }
  void onMessageChange(String input){

    model.onMessageChange(input);

  }

  void noticePeriodOnChange(String input){

    model.noticePeriodOnChange(input);

  }

  void onUpdateOrderTap(context) async {

    //check that the forms been fill in as if the order is updated without filling in the form the staff member wont be able to add a label later if they want to.

    final isFormValid = model.validateLabelForm();

    if(!isFormValid){
      showToastWidget(ToastNotification(message: "Please fill in the label form before updating order details", isError: true));
      return;
    }

    await showDialog(
      context: context, 
      builder: (context){
        return UpdateOrderDialog(stop: model.stop, runID: model.runDocID, runData: model.runData, markAsUnassignedCallback: model.markAsUnassignedCallback, hasPreviouslyBeenMarkedAsUnassigned: model.hasPreviouslyBeenMarkedAsUnassigned);
      }
    );

    updateState();

  }

  void onSaveTap() async{
    
    final successfullySavedLabel = await model.saveLabel();

    final isFormValid = model.validateLabelForm();

    if(!isFormValid){
      showToastWidget(ToastNotification(message: model.errorMessage, isError: true));
      return;
    }

    if(!successfullySavedLabel){
      showToastWidget(ToastNotification(message: "Error saving label to order", isError: true));
      return;
    }

    showToastWidget(ToastNotification(message: "Successfully added label to order", isError: false));

  }
}