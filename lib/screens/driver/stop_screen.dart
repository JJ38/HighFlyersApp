import 'package:action_slider/action_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/assigned_stops.dart';
import 'package:high_flyers_app/components/current_stop.dart';
import 'package:high_flyers_app/components/icon_label.dart';
import 'package:high_flyers_app/components/stop_form.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/controllers/current_stop_controller.dart';
import 'package:high_flyers_app/controllers/stop_screen_controller.dart';

class StopScreen extends StatefulWidget {

  static const String id = "Stop Screen";

  final Map<String, dynamic> stop;
  final Map<String, dynamic> runData;
  final String? progressedRunID;
  final void Function(Map<String, dynamic>) updateMapMarker;
  final void Function() updateRunMapMarkers;

  const StopScreen({super.key, required this.stop, required this.runData, required this.progressedRunID, required this.updateMapMarker, required this.updateRunMapMarkers});

  @override
  State<StopScreen> createState() => _StopScreenState();
}

class _StopScreenState extends State<StopScreen> {

  late final StopScreenController stopScreenController;
  late List<Widget> stopView;
  bool error = true;

  
  @override
  void initState() {

    super.initState();

    print("init state stop screen");
    
    stopScreenController = StopScreenController(updateState: updateState, updateMapRunMarkers: widget.updateRunMapMarkers);

    if(widget.progressedRunID == null){
      showToastWidget(ToastNotification(message: "Error loading stop", isError: true));
      return;
    }

    error = false;

    stopScreenController.model.currentStop = widget.stop;
    
    print("stopScreenController.model.currentStop['stopNumber']");
    print(stopScreenController.model.currentStop['stopNumber']);

    stopView = [
      CurrentStop(
        getStop: stopScreenController.model.getCurrentStop, 
        runData: widget.runData, 
        progressedRunID: widget.progressedRunID, 
        updateMapMarker: widget.updateMapMarker, 
        updateCurrentStop: stopScreenController.model.updateCurrentStop
      ),
      AssignedStops(run: widget.runData,)
    ];

  }

  void updateState(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

  double screenWidth =  MediaQuery.of(context).size.width;

    return error ?

      Text("Error loading stop")
    
    :
    
      Expanded(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15),
          children:  
            [ 
              Center(
                child: ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    stopScreenController.toggleButtons(index);
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.blue[900],
                  selectedColor: Colors.white,
                  fillColor: Color(0xFF2881FF),
                  color: const Color.fromARGB(255, 0, 0, 0),
                  constraints: BoxConstraints(
                      minHeight: 40.0,
                      minWidth: (screenWidth * 0.8) / stopScreenController.selectedToggleView.length),
                  isSelected: stopScreenController.selectedToggleView,
                  children: [
                    Text('Current'),
                    Text('Overview'),
                    // Text('Completed'),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              stopView[stopScreenController.currentSelectedToggleIndex],
            ]
          )
        );
  }
}
