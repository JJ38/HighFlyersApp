import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/run_model.dart';


class RunScreenController {

  final RunModel model = RunModel();
  final List<bool> selectedToggleView = <bool>[true, false, false];
  int currentSelectedIndex = 0;
  final void Function() updateState;

  RunScreenController({required this.updateState});

  void toggleRunViewButtonsController(selectedIndex){

    // The button that is tapped is set to true, and the others to false.
    for (int i = 0; i < selectedToggleView.length; i++) {

      if(i == selectedIndex){

        selectedToggleView[i] = true;
        currentSelectedIndex = i;
        
      }else{
        selectedToggleView[i] = false;
      } 

    }
    
  }

  void startRun(context) async {

    //write to document to say run has started

    model.isStartingRun = true;
    updateState();

    final bool runStarted = await model.startRun();

    model.isStartingRun = false;


    if(!runStarted){
      showToastWidget(ToastNotification(message: 'Error starting run', isError: true), context: context);
      updateState();
      return;
    }

    model.runStarted = true;
    updateState();


  }

  void updateMapMarker(Map<String, dynamic> stopData) async {

    final successfullyUpdatedMarker = await model.getMarkerForStop(stopData);

    if(!successfullyUpdatedMarker){
      showToastWidget(ToastNotification(message: "Error updating map marker", isError: true));
      return;
    }

    updateState();
  }

  void updateRunMapMarkers() async {
    
    final successfullyUpdatedRunMarkers = await model.getMarkersForRun();

    if(!successfullyUpdatedRunMarkers){
      showToastWidget(ToastNotification(message: "Error updating map marker", isError: true));
      return;
    }

    updateState();

  }

}