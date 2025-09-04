class StopScreenModel {

  Map<String, dynamic> currentStop = {};

  Map<String, dynamic> getCurrentStop(){
    return currentStop;
  }

  void updateCurrentStop(Map<String, dynamic> stop){
    
    currentStop = stop;

  }

}