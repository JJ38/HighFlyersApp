import 'package:high_flyers_app/models/stop_screen_model.dart';

class StopScreenController {

  StopScreenModel model = StopScreenModel();
  List<bool> selectedToggleView = <bool>[true, false];
  int currentSelectedToggleIndex = 0;
  void Function() updateState;
  void Function() updateMapRunMarkers;

  StopScreenController({required this.updateState, required this.updateMapRunMarkers});

  void toggleButtons(int index){
    
    currentSelectedToggleIndex = index;
    selectedToggleView = List.filled(selectedToggleView.length, false);
    selectedToggleView[index] = true;

    if(index == 1){
      updateMapRunMarkers();
    }

    // if(index == 0){
    //   updateMapMarker();
    // }

    updateState();
    
  }

}