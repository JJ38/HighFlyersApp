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

  Future<bool> startRun(context) async{

    //write to document to say run has started

    final bool runStarted = await model.startRun();

    if(!runStarted){
  
      showToastWidget(
        ToastNotification(message: 'Error starting run', isError: true),
        context: context
      );

      return false;

    }

    //update stop screen to show details of first stop. This can show another button saying start stop 

    return true;

  }

  void updateMapMarker(Map<String, dynamic> stopData) async {
    print("updateMapMarker");
    final successfullyUpdatedMarker = await model.getMarkerForStop(stopData);

    if(!successfullyUpdatedMarker){
      showToastWidget(ToastNotification(message: "Error updating map marker", isError: true));
      return;
    }

    updateState();
  }

  void updateRunMapMarkers() async {
    
    print("updateMapRunMarker");
    final successfullyUpdatedRunMarkers = await model.getMarkersForRun();

    if(!successfullyUpdatedRunMarkers){
      showToastWidget(ToastNotification(message: "Error updating map marker", isError: true));
      return;
    }

    updateState();
  }

}