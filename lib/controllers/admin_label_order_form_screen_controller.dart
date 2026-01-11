import 'package:high_flyers_app/models/admin_label_order_form_screen_model.dart';

class AdminLabelOrderFormScreenController {

  late final AdminLabelOrderFormScreenModel model;  
  void Function() updateState;

  
  AdminLabelOrderFormScreenController({required stop, required this.updateState}){
    model = AdminLabelOrderFormScreenModel(stop: stop);
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
}