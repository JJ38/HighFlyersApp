import 'dart:async';
import 'dart:core';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/assigned_stops.dart';
import 'package:high_flyers_app/components/button_pill.dart';
import 'package:high_flyers_app/components/completed_stops.dart';
import 'package:high_flyers_app/components/pending_stops.dart';
import 'package:high_flyers_app/components/stop.dart';
import 'package:high_flyers_app/components/stop_card.dart';
import 'package:high_flyers_app/controllers/run_screen_controller.dart';

class RunScreen extends StatefulWidget {
  static String id = "Run Screen";

  final dynamic runDocument;

  const RunScreen({super.key, required this.runDocument});

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {

  late RunScreenController runScreenController;
  late Map<String, dynamic> run;
  late List<Widget> runInfoView;
  late CameraPosition _initialCameraPositon;
  bool error = false;
  bool loaded = false;
  bool runStarted = false;

  @override
  void initState() {
    super.initState();
    runScreenController = RunScreenController();

    run = widget.runDocument.data()! as Map<String, dynamic>;

    if (run.isEmpty) {
      return;
    }

    runInfoView = [AssignedStops(run: run), PendingStops(), CompletedStops()];
    runScreenController.model.setRun(run);
    _getStopsForRun();
  }

  void _getStopsForRun() async {
    final successful = await runScreenController.model.getStopsForRun();

    if (!successful) {
      setState(() {
        error = true;
        loaded = true;
      });
      return;
    }

    //get markers for map
    final successfullyCreatedMarkers = await runScreenController.model.getMarkerForRun();

    if(!successfullyCreatedMarkers){
      setState(() {
        error = true;
        loaded = true;
      });
      return;
    }

    final initialCameraCoordinates = runScreenController.model.run!['stops'][0]['coordinates'];
    _initialCameraPositon = CameraPosition(
      target: LatLng(initialCameraCoordinates['lat'], initialCameraCoordinates['lng']),
      zoom: 8,
    );

    setState(() {
      run['stops'];
      loaded = true;
    });
  }


  @override
  Widget build(BuildContext context) {

    final Completer<GoogleMapController> gmcontroller =
        Completer<GoogleMapController>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: loaded
            ? error
                ? Center(child: Text("Error Loading Run"))
                : Stack(children: [
                    SizedBox(
                      height: screenHeight * 0.9,
                      width: screenWidth,
                      child: GoogleMap(
                        mapType: MapType.terrain,
                        initialCameraPosition: _initialCameraPositon,
                        compassEnabled: false,
                        onMapCreated: (GoogleMapController mapController) {
                          gmcontroller.complete(mapController);
                        },
                        markers: runScreenController.model.markers
                      ),
                    ),
                    SafeArea(
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.3,
                        builder: (controller, scrollController) {
                        return Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius:
                                BorderRadius.circular(20.0), // Uniform radius
                          ),
                          child: Column(
                              mainAxisSize: MainAxisSize.min, 
                              children: [
                                Expanded(
                                    flex: 0,
                                    child: SingleChildScrollView(
                                      physics: const ClampingScrollPhysics(),
                                      controller: scrollController,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 210, 209, 209),
                                              borderRadius: BorderRadius.circular(
                                                  50.0), // Uniform radius
                                            ),
                                            child: SizedBox(
                                              height: 3,
                                              width: 100,
                                            ),
                                          ),
                                          Text(run["runName"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge),
                                        ],
                                      ),
                                    ),
                                  ),
                                ...runStarted ? 
                                  [
                                    ToggleButtons(
                                      direction: Axis.horizontal,
                                      onPressed: (int index) {
                                        runScreenController
                                            .toggleRunViewButtonsController(index);
                                        setState(() {
                                          runScreenController.selectedToggleView;
                                        });
                                      },
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      selectedBorderColor: Colors.blue[900],
                                      selectedColor: Colors.white,
                                      fillColor: Color(0xFF2881FF),
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      constraints: BoxConstraints(
                                          minHeight: 40.0,
                                          minWidth: (screenWidth * 0.8) /
                                              runScreenController
                                                  .selectedToggleView.length),
                                      isSelected:
                                          runScreenController.selectedToggleView,
                                      children: [
                                        Text('Assigned'),
                                        Text('Pending'),
                                        Text('Completed'),
                                      ],
                                    ),
                                    runInfoView[runScreenController.currentSelectedIndex],
                                  ]
                                 :          
                                  [           
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Number of stops: ", 
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        Text(runScreenController.model.getNumberOfStops(), 
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),

                                      ]
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Estimated run time: ",
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            fontSize: 18.0,
                                          ),
                                        ), 
                                        Text(
                                          runScreenController.model.getEstimatedRunTime(),
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ), 
                                      ]
                                    ),
                                    Material(
                                      color: Theme.of(context).colorScheme.secondary,
                                      shadowColor: Color(0x00000000),                                
                                      borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                                      child: MaterialButton(
                                        onPressed: (){ runScreenController.startRun(context); },
                                        minWidth: screenWidth * 0.8,
                                        height: screenWidth * 0.1,
                                        child: Text("Start Run", style: TextStyle(color: Colors.white)),
                                      ),
                                    ),                      
                                    Expanded(
                                      flex: 1,
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(8),
                                        itemCount: run['stops'].length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Stop(
                                            stop: run['stops'][index],
                                            width: screenWidth,
                                          );
                                        }
                                      )                       
                                    )                                                              
                                  ]
                                ],
                            ),
                          );
                    },),),
                  ],)
            : Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary)));
  }
}
