import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/admin_order_card.dart';
import 'package:high_flyers_app/components/order_card.dart';
import 'package:high_flyers_app/controllers/admin_run_labelling_screen_controller.dart';

class AdminRunLabellingScreen extends StatefulWidget {

  static String id = "Admin Run Labelling Screen";
  final String runDocID;

  const AdminRunLabellingScreen({super.key, required this.runDocID});

  @override
  State<AdminRunLabellingScreen> createState() => _AdminRunLabellingScreenState();
}

class _AdminRunLabellingScreenState extends State<AdminRunLabellingScreen> {

  late AdminRunLabellingScreenController adminRunLabellingScreenController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.runDocID);
    adminRunLabellingScreenController = AdminRunLabellingScreenController(updateState: updateState, runDocID: widget.runDocID);
  }

  void updateState(){

    if(mounted){
      setState(() {
        
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;

    return 
      Scaffold(
        body:
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: adminRunLabellingScreenController.model.successfullyInitialisedPage ? 
              
                [
          
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 220, 220, 220), width: 1))
                    ),
                    width: screenWidth,
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(screenWidth * 0.05),
                      child: Text(adminRunLabellingScreenController.model.runData?['runName'], style: Theme.of(context).textTheme.titleLarge)
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

                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                          itemCount: adminRunLabellingScreenController.model.runData?['stops'].length,
                          itemBuilder: (BuildContext context, int i) {
                            
                            final stop = adminRunLabellingScreenController.model.runData?['stops'][i];

                            return GestureDetector(
                              onTap: (){ adminRunLabellingScreenController.onOrderTap(context, stop);},
                              child: Padding(           
                                padding: EdgeInsetsGeometry.only(top: 10),
                                child: AdminOrderCard(
                                  order: stop['orderData'] ?? <String, dynamic>{},
                                  labelData: stop['label'],
                                )
                              ),
                            );
                          },
                        ),

                      ]
                    )
                  )
                                    
                ]

              :

                [
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ]

            ),
          )
        
      );
  }
}