import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/models/driver_model.dart';
import 'package:high_flyers_app/screens/driver/run_screen.dart';

class DriverHomeScreenController {
  final DriverModel model = DriverModel();

  final Function() initialiseDriver;
  final Function() updateState;

  DriverHomeScreenController({required this.initialiseDriver, required this.updateState});

  void onRunTileTap(DocumentSnapshot<Object?> runDocument, bool runStatus, context) async {

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RunScreen(runDocument: runDocument, runStatus: runStatus),
            settings: RouteSettings(name: '/Run Screen')));

    // reinitialisePage

    model.isLoading = true;
    model.driverLoadedSuccessfully = false;

    updateState();
    initialiseDriver();

  }
}
