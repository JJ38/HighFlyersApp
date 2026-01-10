import 'package:flutter/material.dart';
import 'package:high_flyers_app/models/admin_run_labelling_screen_model.dart';
import 'package:high_flyers_app/screens/admin/admin_label_order_form_screen.dart';

class AdminRunLabellingScreenController {

  late final AdminRunLabellingScreenModel model;
  final void Function() updateState;

  AdminRunLabellingScreenController({required this.updateState, required runDocument}){
    model = AdminRunLabellingScreenModel(runDocument: runDocument);
  }

  void onOrderTap(BuildContext context, Map<String, dynamic> stop) async {

    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AdminLabelOrderFormScreen(stop: stop),
          settings: RouteSettings(name: '/${AdminLabelOrderFormScreen.id}')
        )
      );

  }

}