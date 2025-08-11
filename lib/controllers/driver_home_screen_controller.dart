import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/models/driver_model.dart';
import 'package:high_flyers_app/screens/driver/run_screen.dart';

class DriverHomeScreenController {
  final DriverModel model = DriverModel();

  DriverHomeScreenController();

  void onRunTileTap(DocumentSnapshot<Object?> runDocument, context){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => RunScreen(runDocument: runDocument),
      settings: RouteSettings(name: '/Run Screen')
    ));
  }
}
