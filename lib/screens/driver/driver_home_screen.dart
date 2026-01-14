import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/driver_home_screen_controller.dart';

class DriverHomeScreen extends StatefulWidget {
  
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {

  late DriverHomeScreenController driverHomeScreenController;

  @override
  void initState() {

    super.initState();
    driverHomeScreenController = DriverHomeScreenController(updateState: updateState);
    driverHomeScreenController.initialiseDriver();

  }

  void updateState(){
    if(mounted){
      setState(() {
        
      });
    }
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
                  SizedBox(height: screenWidth * 0.05,),
                  Text("Your Runs", style: Theme.of(context).textTheme.titleLarge),

                  driverHomeScreenController.model.driverLoadedSuccessfully ? 

                    driverHomeScreenController.model.driverRunDocs.isEmpty ? 

                      Center(
                        child: Text("You have no assigned runs")
                      )
                    :
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: driverHomeScreenController.model.driverRunDocs.length,
                        itemBuilder: (BuildContext context, int i) {
                 
                          final numberOfAssignedRuns = driverHomeScreenController.model.driverDoc['assignedRuns'].length;

                          dynamic runIndex = i;

                          if(i > (numberOfAssignedRuns - 1)){
                            runIndex = i - numberOfAssignedRuns;
                          }

                          final runType = i > numberOfAssignedRuns - 1 ? "progressedRuns" : "assignedRuns";


                          if (!driverHomeScreenController.model.driverRunDocs[i].exists){
                            return Text("Unknown run");
                          }

                          return GestureDetector(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: 
                                Column(                        
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(driverHomeScreenController.model.driverDoc[runType][runIndex]['shipmentName'] ?? "", style: Theme.of(context).textTheme.titleMedium,),
                                    Text(driverHomeScreenController.model.driverRunDocs[i]['runName'] ?? "", style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 20),),

                                    runType == "assignedRuns" ? 

                                        Text("New", style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 20, color: Colors.blue),)
                                      
                                      :

                                        driverHomeScreenController.model.driverRunDocs[i]['runStatus']  == "Completed" ? 

                                            Text("Completed", style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 20, color: Colors.green),)

                                          :

                                            Text("In Progress", style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 20, color: Colors.amber),)
                                            

                                  ]
                                ),
                            ),                      
                            onTap: () { driverHomeScreenController.onRunTileTap(driverHomeScreenController.model.driverRunDocs[i], driverHomeScreenController.model.runStatuses[i], driverHomeScreenController.model.driverDoc[runType][runIndex]['shipmentName'] ?? "", context);},
                          );
                        },
                      )
                  :
                    driverHomeScreenController.model.isLoading ? 

                      Center(
                        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary,),
                      )
                    
                    :

                      Center(child: Text(driverHomeScreenController.model.driverLoadedSuccessfully.toString())),
                ],
              ),
            ),
          ),
        );
            
  }
}
