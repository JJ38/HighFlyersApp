import 'dart:async';
import 'dart:core';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/assigned_stops.dart';
import 'package:high_flyers_app/components/completed_stops.dart';
import 'package:high_flyers_app/components/pending_stops.dart';
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
  bool error = false;
  bool loaded = false;

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
    print("run screen build");
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
                        initialCameraPosition: _kGooglePlex,
                        compassEnabled: false,
                        onMapCreated: (GoogleMapController mapController) {
                          gmcontroller.complete(mapController);
                        },
                      ),
                    ),
                    SafeArea(child: DraggableScrollableSheet(
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
                                BorderRadius.circular(50.0), // Uniform radius
                          ),
                          // color: Colors.white,
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
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
                                )),
                            ToggleButtons(
                              direction: Axis.horizontal,
                              onPressed: (int index) {
                                runScreenController
                                    .toggleRunViewButtonsController(index);
                                setState(() {
                                  runScreenController.selectedToggleView;
                                });
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
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
                            runInfoView[
                                runScreenController.currentSelectedIndex]
                          ]));
                    }))
                  ])
            : Center(child: Text("Loading")));
  }
}
