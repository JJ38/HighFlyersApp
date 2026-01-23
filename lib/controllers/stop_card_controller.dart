import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/stop_form_dialog.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/stop_card_model.dart';

class StopCardController {

  late StopCardModel model;
  void Function() updateState;

  StopCardController({required this.updateState, required stop, runData, progressedRunID}){
    model = StopCardModel(stop: stop, runData: runData, progressedRunID: progressedRunID);
  }

  void onTap(){

    model.expandCard = !model.expandCard ;
    updateState();

  }

  Future<void> callCustomer(ActionSliderController controller, BuildContext context) async {

    controller.loading();

    final bool calledCustomerSuccessfully = await model.callCustomer();

    updateState();
    controller.reset();

    if(!calledCustomerSuccessfully){
      showToastWidget(ToastNotification(message: "Error calling customer", isError: true));
    }

  }

  Future<void> openStopFormDialog(BuildContext context) async {

    if(context.mounted){

      await showDialog(
        context: context, 
        builder: (context){
          return StopFormDialog(stop: model.stop, runData: model.runData, progressedRunID: model.progressedRunID);
        }
      );

      updateState();

    }

  }

}