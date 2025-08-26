import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/driver_home_screen_controller.dart';

class DriverHomeScreen extends StatefulWidget {
  
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {

  late DriverHomeScreenController driverHomeScreenController;

  bool driverLoadedSuccessfully = false;

  @override
  void initState() {

    super.initState();
    driverHomeScreenController = DriverHomeScreenController();
    initialiseDriver();

  }

  void initialiseDriver() async {

    final initialisedDriver = await driverHomeScreenController.model.initialiseDriver();

    if (initialisedDriver) {

      final driverRunsFetched = await driverHomeScreenController.model.fetchDriverRuns();

      if (driverRunsFetched) {

        driverLoadedSuccessfully = true;

      }
    }

    setState(() {
      driverLoadedSuccessfully;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: screenWidth * 0.05),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Runs", style: Theme.of(context).textTheme.titleLarge),

                      driverLoadedSuccessfully ? 

                        driverHomeScreenController.model.driverRunDocs.isEmpty ? 

                          Center(
                            child: Text("You have no assigned runs")
                          )
                        :
                          ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: driverHomeScreenController.model.driverDoc['assignedRuns'].length,
                            itemBuilder: (BuildContext context, int i) {
                              return ListTile(
                                title: Text(driverHomeScreenController.model.driverDoc['assignedRuns'][i]['shipmentName']),
                                subtitle: Text(driverHomeScreenController.model.driverRunDocs[i]['runName']),
                                onTap: () { driverHomeScreenController.onRunTileTap(driverHomeScreenController.model.driverRunDocs[i], context);},
                              );
                            },
                          )
                      : 
                        Center(
                          child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary,),
                        )
                    ],
                  ),
                ),
              ),
            );
            
  }
}
