import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/run_info_card.dart';
import 'package:high_flyers_app/controllers/admin_label_runs_screen_controller.dart';
import 'package:high_flyers_app/screens/admin/admin_manage_orders_screen.dart';

class AdminLabelRunsScreen extends StatefulWidget {
  const AdminLabelRunsScreen({super.key});

  @override
  State<AdminLabelRunsScreen> createState() => _AdminLabelRunsScreenState();
}

class _AdminLabelRunsScreenState extends State<AdminLabelRunsScreen> {

  late final AdminLabelRunsScreenController adminLabelRunsScreenController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminLabelRunsScreenController = AdminLabelRunsScreenController(updateState: updateState);
    adminLabelRunsScreenController.initialiseStaffMember();

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
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
       
                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 220, 220, 220), width: 1))
                  ),
                  width: screenWidth,
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(screenWidth * 0.05),
                    child: Text("Your Runs", style: Theme.of(context).textTheme.titleLarge)
                  ),
                ),
              

                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 246, 246, 246),
                          border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 220, 220, 220), width: 1))
                        ),
                      ),

                      if(adminLabelRunsScreenController.model.isLoaded && adminLabelRunsScreenController.model.initialisedStaffMember)

                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                          itemCount: adminLabelRunsScreenController.model.assignedRuns.length,
                          itemBuilder: (BuildContext context, int i) {
                            
                            final assignedRun = adminLabelRunsScreenController.model.assignedRuns[i];

                            return GestureDetector(
                              onTap: () {
                                adminLabelRunsScreenController.runCardOnTap(context, adminLabelRunsScreenController.model.staffRunDocs[i].id);
                              },
                              child: Padding(           
                                padding: EdgeInsetsGeometry.only(top: 10),
                                child: RunInfoCard(
                                  shipmentName: assignedRun['shipmentName'], 
                                  runName: assignedRun['runName'], 
                                  runWeek: assignedRun['runWeek'], 
                                  numberOfStops: assignedRun['stops']?.length
                                )
                              ),
                            );
                          },
                        ),

                      if(adminLabelRunsScreenController.model.isLoaded && !adminLabelRunsScreenController.model.initialisedStaffMember)

                        Expanded(
                          child: Center(
                            child: Text("Error loading runs")
                          ,)
                        ),

                      if(!adminLabelRunsScreenController.model.isLoaded)

                        Expanded(
                          child: Center(
                            child: CircularProgressIndicator()
                          ,)
                        )
                    ]
                  )
                )
                                  
              ]
            ),
          )
        
      );
  }
}