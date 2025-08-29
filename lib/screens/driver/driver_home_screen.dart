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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    driverHomeScreenController = DriverHomeScreenController(initialiseDriver);

    initialiseDriver();

  }

  void initialiseDriver() async {

    final initialisedDriver = await driverHomeScreenController.model.initialiseDriver();
    print("initialisedDriver: $initialisedDriver");
    if (initialisedDriver) {

      final driverRunsFetched = await driverHomeScreenController.model.fetchDriverRuns();

      if (driverRunsFetched) {

        driverLoadedSuccessfully = true;

      }
    }

    isLoading = false;

    setState(() {
      driverLoadedSuccessfully;
      isLoading;
    });

  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return 
      Scaffold(
        body:
          Padding(
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
                          return GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: 
                                Column(                        
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(driverHomeScreenController.model.driverDoc['assignedRuns'][i]['shipmentName'], style: Theme.of(context).textTheme.titleMedium,),
                                    Text(driverHomeScreenController.model.driverRunDocs[i]['runName'], style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 20),),
                                  ]
                                ),
                            ),                      
                            onTap: () { driverHomeScreenController.onRunTileTap(driverHomeScreenController.model.driverRunDocs[i], driverHomeScreenController.model.runStatuses[i], context);},
                          );
                        },
                      )
                  :
                    isLoading ? 

                      Center(
                        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary,),
                      )
                    
                    :

                      Center(child: Text(driverLoadedSuccessfully.toString())),
                ],
              ),
            ),
          ),
        );
            
  }
}
