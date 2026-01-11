import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
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

  void onUpdateOrderTap(){

  }

  void onSaveTap() async{
    
    final successfullySavedLabel = await model.saveLabel();

    if(!successfullySavedLabel){
      showToastWidget(ToastNotification(message: "Error saving label to order", isError: true));
      return;
    }

    showToastWidget(ToastNotification(message: "Successfully added label to order", isError: false));

  }
}