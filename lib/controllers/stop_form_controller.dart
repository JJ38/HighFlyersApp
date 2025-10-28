import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/call_admin_dialog_box.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/stop_form_model.dart';

class StopFormController {

  StopFormModel model = StopFormModel();
  final void Function() updateStopScreenState;
  final void Function() hideStopForm;
  final void Function() updateMapMarker;
  final bool Function() getShouldCallAdmin;
  final void Function() callAdmin;


  StopFormController({required this.updateStopScreenState, required this.updateMapMarker, required this.hideStopForm, required this.getShouldCallAdmin, required this.callAdmin});

  void onAnimalTypeSelect(String? animalType){

    model.animalType = animalType;

  }

  void onQuantityInput(String? quantity){

    if(quantity == null || quantity == ""){
      return;
    }

    try{

      model.quantity = int.parse(quantity); 

    }catch(e){

      print(e);

    }

  }

  void onCollectedPaymentSelect(bool? collectedPayment){

    model.collectedPayment = collectedPayment;

  }

  void onNotesInput(String? notes){
    
    model.notes = notes;

  }

  Future<void> completeStop(controller, context) async {

    controller.loading();

    final isFormValid = model.isFormValid();

    if(!isFormValid){
      showToastWidget(ToastNotification(message: "Form is not valid", isError: true));
      controller.reset();
      return;
    }

    if(model.completeStop == null){
      showToastWidget(ToastNotification(message: "Error completing stop", isError: true));
      controller.reset();
      return;
    }

    if(model.formDetails == null){
      showToastWidget(ToastNotification(message: "Error completing stop", isError: true));
      controller.reset();
      return;
    }

    final completedStopSuccessfully = await model.completeStop!(model.formDetails);

    if(!completedStopSuccessfully){

      
      if(getShouldCallAdmin()){

        showToastWidget(ToastNotification(message: "You must call kev before compeleting this stop", isError: true));

        showDialog(
          context: context, 
          builder: (context){
            return CallAdminDialogBox(callAdmin: callAdmin);
          }
        );

        controller.reset();
        return;

      }

      showToastWidget(ToastNotification(message: "Error completing stop", isError: true));
      controller.reset();
      return;
    }

    await Future.delayed(Duration(seconds: 1));

    showToastWidget(ToastNotification(message: "Successfully completed stop", isError: false));

    updateMapMarker();
    hideStopForm();
    updateStopScreenState();

  }

}