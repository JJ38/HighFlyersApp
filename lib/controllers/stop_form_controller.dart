import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/stop_form_model.dart';

class StopFormController {

  StopFormModel model = StopFormModel();
  final void Function() updateStopScreenState;
  final void Function() hideStopForm;


  StopFormController({required this.updateStopScreenState, required this.hideStopForm});

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

    }

  }

  void onCollectedPaymentSelect(bool? collectedPayment){

    model.collectedPayment = collectedPayment;

  }

  void onNotesInput(String? notes){
    
    model.notes = notes;

  }

  Future<void> completeStop(controller) async {

    print("complete stop stop_from_controller");

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
      showToastWidget(ToastNotification(message: "Error completing stop", isError: true));
      controller.reset();
    }

    await Future.delayed(Duration(seconds: 1));

    showToastWidget(ToastNotification(message: "Successfully completed stop", isError: false));

    hideStopForm();
    updateStopScreenState();

  }

}