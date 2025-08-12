import 'dart:async';
import 'dart:core';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/stop_card.dart';
import 'package:high_flyers_app/controllers/run_screen_controller.dart';

class RunScreen extends StatefulWidget {

  static String id = "Run Screen";

  final RunScreenController controller = RunScreenController();

  final dynamic runDocument;

  RunScreen({super.key, required this.runDocument});

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {

  late Map<String, dynamic> run;
  bool error = false;
  bool loaded = false;

  @override
  void initState(){

    super.initState();
    run = widget.runDocument.data()! as Map<String, dynamic>;

    if(run.isEmpty){
      return;
    }

    widget.controller.model.setRun(run);
    getStopsForRun();

  }

  void getStopsForRun() async {

    final successful = await widget.controller.model.getStopsForRun();

    if(!successful){
      setState(() {
        error = true;
        loaded = true;
      });
      return;
    }

    setState(() {
      run['stops'];
      loaded = true;
    });
  }


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {
    print("running build");
    Key _scaffoldKey = UniqueKey();


    final Completer<GoogleMapController> controller =
        Completer<GoogleMapController>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void _rebuildScreen() {
      setState(() {
        // By creating a new UniqueKey, we are telling Flutter that the
        // Scaffold widget is no longer the same widget.
        _scaffoldKey = UniqueKey();
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      body: loaded ? error ? Center(child: Text("Error Loading Run")) :
        Stack(
          children: [
            SizedBox(
              height: screenHeight * 0.9,
              width: screenWidth,
              child: GoogleMap(
                mapType: MapType.terrain,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController mapController) {
                  controller.complete(mapController);
                },
              ),
            ),
            SafeArea(
              child: DraggableScrollableSheet(
                builder: (controller, scrollController) {
                  return 
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(50.0), // Uniform radius
                      ),
                      // color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:[
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
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(50.0), // Uniform radius
                                    ),
                                    child: SizedBox(
                                      height: 3,
                                      width: 100,
                                    ),
                                  ),
                                  Text(run["runName"], style: Theme.of(context).textTheme.titleLarge),
                                ],
                              ),
                            )                           
                          ),
                          ToggleButtons(
                            direction: Axis.horizontal,
                            onPressed:(int index) {  
                              widget.controller.toggleRunViewButtonsController(index); 
                              setState(() {
                                widget.controller.selectedToggleView;
                              }); 
                            },
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            selectedBorderColor: Colors.blue[900],
                            selectedColor: Colors.white,
                            fillColor: Color(0xFF2881FF),
                            color: const Color.fromARGB(255, 0, 0, 0),
                            constraints: BoxConstraints(minHeight: 40.0, minWidth: (screenWidth * 0.8) / widget.controller.selectedToggleView.length) ,
                            isSelected: widget.controller.selectedToggleView,
                            children: [
                              Text('Assigned'),
                              Text('Pending'),
                              Text('Completed'),
                            ],
                          ),
                          Expanded(
                            flex: 1,
                            child: SingleChildScrollView(                             
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              controller: scrollController,
                              child: Column(
                                spacing: 20,
                                children: widget.controller.getStopCards(screenWidth),
                              )                                
                            )                         
                          )
                        ]
                      )
                  );
                }
              )
            )
          ]
        ) : Center(child: Text("Loading"))
      );
  }
}

// ToggleButtons(
//                 direction: vertical ? Axis.vertical : Axis.horizontal,
//                 onPressed: (int index) {
//                   setState(() {
//                     // The button that is tapped is set to true, and the others to false.
//                     for (int i = 0; i < _selectedFruits.length; i++) {
//                       _selectedFruits[i] = i == index;
//                     }
//                   });
//                 },
//                 borderRadius: const BorderRadius.all(Radius.circular(8)),
//                 selectedBorderColor: Colors.red[700],
//                 selectedColor: Colors.white,
//                 fillColor: Colors.red[200],
//                 color: Colors.red[400],
//                 constraints: const BoxConstraints(minHeight: 40.0, minWidth: 80.0),
//                 isSelected: _selectedFruits,
//                 children: fruits,
//               ),