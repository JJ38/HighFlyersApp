import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/driver_screen_model.dart';

class DriverScreenController {

  DriverScreenModel model = DriverScreenModel();  

  void initialisedLocationTracking() async{

    final initialisedLocationTrackingSuccessfully = await model.initialiseLocationTracking();

    if(!initialisedLocationTrackingSuccessfully){
      showToastWidget(ToastNotification(message: "Error starting location tracking", isError: true));
    }
  }

}