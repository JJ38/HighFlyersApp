import 'dart:async';
import 'dart:core';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  dynamic runData;
  dynamic stopData = false;
  List<StopCard> stopCards = [];

  @override
  void initState(){
    super.initState();
    runData = widget.runDocument.data()! as Map<String, dynamic>;
    fetchStopsForRun();

  }

  void fetchStopsForRun() async {

    stopData = await widget.controller.model.fetchStopsForRun(runData);

    setState(() {
      stopData;
    });
  }


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {

    final Completer<GoogleMapController> controller =
        Completer<GoogleMapController>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
  

    return Scaffold(
      body: stopData? Stack(
        children: [
          SizedBox(
            height: screenHeight* 0.9,
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50.0), // Uniform radius
                    ),
                    // color: Colors.white,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                          Text(runData["runName"], style: Theme.of(context).textTheme.titleLarge),
                          Column(
                          spacing: 10,
                            children: [
                              StopCard(stop: "daohdawd", width: screenWidth),
                              Text("stop name"),
                              Text("stop name"),
                              Text("stop name"),
                              Text("stop name"),
                            ],
                          ),
                          
                        ]
                      )
                        
                      
                    )
                  
                );
              }
            )
          )
        ]
      ) : Center(child: Text("Error loading run"))
    );
  }
}
