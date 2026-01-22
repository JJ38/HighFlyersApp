import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/admin_label_runs_screen_model.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/screens/admin/admin_manage_orders_screen.dart';
import 'package:high_flyers_app/screens/admin/admin_run_labelling_screen.dart';

class AdminLabelRunsScreenController {

  final AdminLabelRunsScreenModel model = AdminLabelRunsScreenModel();
  final void Function() updateState;

  AdminLabelRunsScreenController({required this.updateState});


  void initialiseStaffMember() async{

    final initialisedStaffMemberSuccessfully = await model.initialiseStaffMember();

    model.isLoaded = true;

    if(!initialisedStaffMemberSuccessfully){
      updateState();
      showToastWidget(ToastNotification(message: "Error Loading runs", isError: true));
      return;
    }

    model.initialisedStaffMember = true;

    updateState();

  }

  void runCardOnTap(BuildContext context, runDocID) async{

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminRunLabellingScreen(runDocID: runDocID),
        settings: RouteSettings(name: '/${AdminRunLabellingScreen.id}')
      )
    );

  }


}


