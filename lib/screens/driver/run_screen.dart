import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/assigned_stops.dart';
import 'package:high_flyers_app/components/button_pill.dart';
import 'package:high_flyers_app/components/completed_stops.dart';
import 'package:high_flyers_app/components/pending_stops.dart';
import 'package:high_flyers_app/components/stop.dart';
import 'package:high_flyers_app/components/stop_card.dart';
import 'package:high_flyers_app/controllers/run_screen_controller.dart';
import 'package:high_flyers_app/screens/driver/stop_screen.dart';

class RunScreen extends StatefulWidget {
  static String id = "Run Screen";

  final DocumentSnapshot<Object?> runDocument;
  final bool runStatus;
  final String shipmentName;

  const RunScreen({super.key, required this.runDocument, required this.runStatus, required this.shipmentName});

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {

  late RunScreenController runScreenController;
  late Map<String, dynamic> run;
  late String runID;
  late String shipmentName;
  late DocumentSnapshot<Object?> runDocument;
  late List<Widget> runInfoView;
  late CameraPosition _initialCameraPositon;
  bool error = false;
  bool loaded = false;
  bool runStarted = false;

  @override
  void initState() {
    super.initState();
    runScreenController = RunScreenController(updateState: updateState);
  
    run = widget.runDocument.data()! as Map<String, dynamic>;
    runID = widget.runDocument.id;
    runDocument = widget.runDocument;
    shipmentName = widget.shipmentName;
    runScreenController.model.shipmentName = widget.shipmentName;


    print(run);

    if (run.isEmpty) {
      return;
    }

    runStarted = widget.runStatus;

    // runInfoView = [AssignedStops(run: run), PendingStops(), CompletedStops()];
    runScreenController.model.setRun(run);

    if(runStarted){
      runScreenController.model.progressedRunID = runID;
    }else{
      runScreenController.model.setRunID(runID);
    }

    if(!runStarted){
      _initialiseStartRunPage();
      return;
    }

    _initialiseCurrentStopPage();

  }

  void _initialiseCurrentStopPage() async{

    //find out what stop user is currently on

    int currentStopNumber = run['currentStopNumber'];

    //load stop (in model as current stop maybe)
    final currentStopData = runScreenController.model.getStopByStopNumber(currentStopNumber);

    if(currentStopData == false){
      setState(() {
        error = true;
        loaded = true;
      });
      return;
    }

    //show marker on map for current stop 
    await runScreenController.model.getMarkerForStop(currentStopData);

    final initialCameraCoordinates = currentStopData['coordinates'];

    _initialCameraPositon = CameraPosition(
      target: LatLng(initialCameraCoordinates['lat'], initialCameraCoordinates['lng']),
      zoom: 8,
    );

    setState(() {
      run['stops'];
      loaded = true;
    });
  
  }

  void _initialiseStartRunPage() async {
    final successful = await runScreenController.model.getStopsForRun();

    if (!successful) {
      setState(() {
        error = true;
        loaded = true;
      });
      return;
    }

    //get markers for map
    final successfullyCreatedMarkers = await runScreenController.model.getMarkersForRun();

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

  void updateState(){
    setState(() {
      
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
                                          !runStarted ? 
                                          Text(run["runName"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge)
                                          :
                                            SizedBox()
                                        ],
                                      ),
                                    ),
                                  ),
                                ...runStarted ? 
                                  [
                                    StopScreen(
                                      stop: runScreenController.model.getStopByStopNumber(runScreenController.model.run!['currentStopNumber']), 
                                      runData: runScreenController.model.run!, 
                                      progressedRunID: runScreenController.model.progressedRunID,
                                      updateMapMarker: runScreenController.updateMapMarker,
                                      updateRunMapMarkers: runScreenController.updateRunMapMarkers,
                                      scrollController: scrollController,

                                    ),
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
                                        onPressed: () async { 
                                          if(await runScreenController.startRun(context)){ 
                                            setState(() {
                                              runStarted = true;
                                            });
                                          } 
                                        },
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
