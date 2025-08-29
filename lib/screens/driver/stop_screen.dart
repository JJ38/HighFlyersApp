import 'package:action_slider/action_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/icon_label.dart';
import 'package:high_flyers_app/components/stop_form.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/controllers/stop_screen_controller.dart';

class StopScreen extends StatefulWidget {

  static const String id = "Stop Screen";

  final Map<String, dynamic> stop;
  final DocumentSnapshot<Object?> runDocument;

  const StopScreen({super.key, required this.stop, required this.runDocument});

  @override
  State<StopScreen> createState() => _StopScreenState();
}

class _StopScreenState extends State<StopScreen> {

  late final StopScreenController stopScreenController;

  @override
  void initState() {

    super.initState();
    stopScreenController = StopScreenController(updateState: updateState);
    stopScreenController.model.runDocument = widget.runDocument;
    stopScreenController.model.stop = widget.stop;

  }

  void updateState(){

    setState(() {});

  }

  @override
  Widget build(BuildContext context) {

  double screenWidth =  MediaQuery.of(context).size.width;

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(15),
        children:  
          [      
            Text("#${stopScreenController.model.stop['orderData']['ID'].toString()}", style: Theme.of(context).textTheme.titleSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Stop Number: ", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                      Text(stopScreenController.model.stop['stopNumber'].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),)
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Stop type: ", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                      Text(stopScreenController.model.stop['stopType'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),)
                    ],
                  ),
                )
              ]
            ),
            Divider(height: 1,),
            SizedBox(height: 10),
            Row(
              children:[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(Icons.person),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                    Text(stopScreenController.model.stop['stopData']['name'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),)
                  ],
                ),
              ]
            ),
            SizedBox(height: 10),
            Row(
              children:[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(Icons.location_on),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Delivery Address", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          Text(stopScreenController.model.stop['stopData']['address1'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),  
                        ],
                      ),

                      Row(
                        children: [
                          Text("${stopScreenController.model.stop['stopData']['address2']}, ", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),
                          Text(stopScreenController.model.stop['stopData']['address3'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),
                        ]
                      ),
                      Text(stopScreenController.model.stop['stopData']['postcode'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),
                    ]              
                  )
                ),
              ]
            ),
            SizedBox(height: 10),
            Divider(height: 1,),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.circular(20),
                color: const Color.fromARGB(255, 246, 246, 246)
              ),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 6,
                children: <Widget>[
                  Text("Animal type:",  style: Theme.of(context).textTheme.labelSmall), 
                  Text(stopScreenController.model.stop['stopData']['animalType'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),

                  Text("Quantity:",  style: Theme.of(context).textTheme.labelSmall), 
                  Text(stopScreenController.model.stop['stopData']['quantity'].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),

                  Text("Phone Number:",  style: Theme.of(context).textTheme.labelSmall), 
                  Text(stopScreenController.model.stop['stopData']['phoneNumber'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),

                  Text("Collecting payment:",  style: Theme.of(context).textTheme.labelSmall), 
                  Text(stopScreenController.model.stop['stopData']['payment'] ? "Yes" : "No", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),

                  Text("Message:",  style: Theme.of(context).textTheme.labelSmall), 
                  Text(stopScreenController.model.stop['orderData']['message'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                
                
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(height: 1,),
            SizedBox(height: 10),

            ...stopScreenController.model.showStopForm ? 

              [
                StopForm(updateState, stopScreenController.hideStopFrom)
              ]

            :
              [
                Center(
                  child: Material(
                    color: Theme.of(context).colorScheme.secondary,
                    shadowColor: Color(0x00000000),                                
                    borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                    child: MaterialButton(
                      onPressed: () { stopScreenController.navigate(stopScreenController.model.stop);},
                      minWidth: screenWidth * 0.9,
                      height: screenWidth * 0.1,
                      child: Text("Navigate", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),      
                SizedBox(height: 10),
                Center(
                  child: Material(
                    color: Colors.black,
                    shadowColor: Color(0x00000000),                                
                    borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                    child: MaterialButton(
                      onPressed: () { stopScreenController.showStopForm();},
                      minWidth: screenWidth * 0.9,
                      height: screenWidth * 0.1,
                      child: Text("Stop Form", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),      
                SizedBox(height: 20),
                Center(
                  child: ActionSlider.standard(
                    icon: Icon(Icons.skip_next),
                    toggleColor: const Color.fromARGB(255, 255, 209, 44),
                    backgroundColor: const Color.fromARGB(255, 246, 246, 246),
                    boxShadow: [BoxShadow(color: const Color.fromARGB(255, 206, 206, 206), blurRadius: 0, spreadRadius: 1)],
                    borderWidth: 4,
                    child: Text("Slide to skip stop", style: TextStyle(color: Colors.black),),
                    action: (controller) async { await stopScreenController.skipStop(controller);}
                  )
                )
              ]
          ]
        )
      );
  }
}

