import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/admin_run_labelling_screen_model.dart';
import 'package:high_flyers_app/screens/admin/admin_label_order_form_screen.dart';

class AdminRunLabellingScreenController {

  late final AdminRunLabellingScreenModel model;
  final void Function() updateState;

  AdminRunLabellingScreenController({required this.updateState, required runDocID}){
    model = AdminRunLabellingScreenModel(runDocID: runDocID);
    initialisePage();
  }

  Future<void> initialisePage() async {

    final bool succesfullyInitialisedPage = await model.initialisePage();

    if(!succesfullyInitialisedPage){
      showToastWidget(ToastNotification(message: "Error fetching run", isError: true));
      return;
    }
  
    updateState();

  }

  void onOrderTap(BuildContext context, Map<String, dynamic> stop) async {

    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AdminLabelOrderFormScreen(runDocID: model.runDocID, stop: stop, runData: model.runData,),
          settings: RouteSettings(name: '/${AdminLabelOrderFormScreen.id}'
        )
      )
    );

    model.successfullyInitialisedPage = false;

    updateState();

    await model.initialisePage();

    updateState();

  }

}