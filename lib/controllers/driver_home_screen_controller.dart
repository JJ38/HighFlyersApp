import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:high_flyers_app/models/driver_model.dart';
import 'package:high_flyers_app/screens/driver/run_screen.dart';

class DriverHomeScreenController {
  final DriverModel model = DriverModel();

  DriverHomeScreenController() {
    final driverInitialised = model.initialiseDriver();
    if (!driverInitialised) {
      //show error loading notification
    }
  }

  void onRunTileTap(DocumentSnapshot<Object?> runDocument, context){
    print("run doc id: " + runDocument.id);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => RunScreen(runDocument: runDocument),
      settings: RouteSettings(name: '/Run Screen')
    ));
  }
}
