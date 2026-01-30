import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/call_admin_dialog_box.dart';
import 'package:high_flyers_app/components/confirmation_dialog_box.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/stop_form_dialog_model.dart';

class StopFormDialogController {

  late StopFormDialogModel model;
  Map<String, dynamic> stop;
  Map<String, dynamic>? runData;
  String? progressedRunID;
  void Function() updateState;
  
  StopFormDialogController({required this.updateState, required this.stop, this.runData, this.progressedRunID}){
    model = StopFormDialogModel(stop: stop, runData: runData, progressedRunID: progressedRunID);
  }

  void closeDialog(BuildContext context){

    if(context.mounted){
      Navigator.of(context).pop();
    }

  }

  void onAnimalTypeSelect(String? animalType){

    model.animalType = animalType;
    print(model.animalType);
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

  Future<void> completeStop(ActionSliderController controller, context) async {

    controller.loading();

    final isFormValid = model.isFormValid();

    if(!isFormValid){
      showToastWidget(ToastNotification(message: model.errorMessage, isError: true));
      controller.reset();
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


    print("completeStopCOntroller");

    final completedStopSuccessfully = await model.completeStop();

    if(!completedStopSuccessfully){
      
      // if(model.shouldCallAdmin){

      //   showToastWidget(ToastNotification(message: "You must call kev before compeleting this stop", isError: true));

      //   showDialog(
      //     context: context, 
      //     builder: (context){
      //       return CallAdminDialogBox(callAdmin: model.callAdmin);
      //     }
      //   );

      //   controller.reset();
      //   return;

      // }

      showToastWidget(ToastNotification(message: "Error completing stop", isError: true));
      controller.reset();
      return;

    }

    await Future.delayed(Duration(seconds: 1));
    
    controller.reset();

    showToastWidget(ToastNotification(message: "Successfully completed stop", isError: false));
    Navigator.of(context).pop();

  }

}