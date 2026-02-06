import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/call_admin_dialog_box.dart';
import 'package:high_flyers_app/components/confirmation_dialog_box.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/stop_form_model.dart';

class StopFormController {

  late StopFormModel model;
  final void Function() updateState;
  final void Function() updateStopScreenState;
  final void Function() hideStopForm;
  final void Function() updateMapMarker;
  final void Function() shouldAutoShowForm;
  final String Function() getErrorMessage;



  StopFormController({
    required this.updateState,
    required this.updateStopScreenState, 
    required this.updateMapMarker, 
    required this.hideStopForm, 
    required completeStop,
    required getStop,
    required this.shouldAutoShowForm,
    required this.getErrorMessage
  }){

    model = StopFormModel(getStop: getStop, completeStop: completeStop, getErrorMessage: getErrorMessage);

  }

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

  Future<void> completeStop(controller, BuildContext context) async {

    if(context.mounted){
      controller.loading();
    }

    final isFormValid = model.isFormValid();

    if(!isFormValid){
      showToastWidget(ToastNotification(message: "Form is not valid", isError: true));
      if(context.mounted){
        controller.reset();
      }
      return;
    }

    final createsDeferredPayment = model.doesCreateDeferredPayment();

    if(createsDeferredPayment){

      if(context.mounted){

        await showDialog(
          context: context, 
          builder: (context){
            return ConfirmationDialogBox(confirmationMessage: "Are you sure the payment is correct? This will create a deferred payment and effect payment instructions for other drivers", responseCallback: model.setConfirmationAnswer);
          }
        );

      }

      if(model.confirmedPaymentInput == false){

        if(context.mounted){
          controller.reset();
        }
        return;
        
      }

     
    }


    if(model.completeStop == null){
      showToastWidget(ToastNotification(message: "Error completing stop", isError: true));
      if(context.mounted){
        controller.reset();
      }
      return;
    }

    if(model.formDetails == null){
      showToastWidget(ToastNotification(message: "Error completing stop", isError: true));
      if(context.mounted){
        controller.reset();
      }
      return;
    }

    final completedStopSuccessfully = await model.completeStop!(model.formDetails);

    if(!completedStopSuccessfully){

      showToastWidget(ToastNotification(message: model.getErrorMessage(), isError: true));
      if(context.mounted){
        controller.reset();
      }
      return;
    }

    await Future.delayed(Duration(seconds: 1));
    if(context.mounted){
      controller.reset();
    }

    showToastWidget(ToastNotification(message: "Successfully completed stop", isError: false));

    updateMapMarker();
    hideStopForm();
    updateStopScreenState();
    model.updateStopFormData();
    shouldAutoShowForm();
    updateState();

  }

}