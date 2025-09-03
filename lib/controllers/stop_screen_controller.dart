class StopScreenController {

  void Function() updateState;
  List<bool> selectedToggleView = <bool>[true, false];
  int currentSelectedToggleIndex = 0;

  StopScreenController({required this.updateState});

  void toggleButtons(int index){
    
    currentSelectedToggleIndex = index;
    selectedToggleView = List.filled(selectedToggleView.length, false);
    selectedToggleView[index] = true;
    updateState();
    
  }

}