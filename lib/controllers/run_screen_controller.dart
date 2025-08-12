import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/stop_card.dart';
import 'package:high_flyers_app/models/run_model.dart';

class RunScreenController {

  final RunModel model = RunModel();
  final List<bool> selectedToggleView = <bool>[true, false, false];

  RunScreenController(){print("init controller");}

  void toggleRunViewButtonsController(selectedIndex){

    // The button that is tapped is set to true, and the others to false.
    for (int i = 0; i < selectedToggleView.length; i++) {
      selectedToggleView[i] = i == selectedIndex;
    }
    
  }

  List<StopCard> getStopCards(screenWidth){

      List<StopCard> stopCards = [];
      if(model.run == null){
        return stopCards;
      }

      model.run!['stops'].forEach((stop) {
        stopCards.add(StopCard(stop: stop, width: screenWidth));
      });

      return stopCards;

    }

}