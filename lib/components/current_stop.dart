import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/deferred_payment_hint.dart';
import 'package:high_flyers_app/components/stop_form.dart';
import 'package:high_flyers_app/controllers/current_stop_controller.dart';

class CurrentStop extends StatefulWidget {

  final Map<String, dynamic> runData;
  final String? progressedRunID;
  // final bool isRunCompleted;
  final void Function(Map<String, dynamic>) updateMapMarker;
  final void Function(Map<String, dynamic>) updateCurrentStop;
  final Map<String, dynamic> Function() getStop;


  const CurrentStop({super.key, required this.getStop, required this.runData, required this.progressedRunID, required this.updateMapMarker, required this.updateCurrentStop});

  @override
  State<CurrentStop> createState() => _CurrentStopState();
}

class _CurrentStopState extends State<CurrentStop> {

  late CurrentStopController currentStopController;

  @override
  void initState() {

    super.initState();

    debugPrint("initstate current stop");
    debugPrint(widget.runData['runStatus']);

    currentStopController = CurrentStopController(updateState: updateState, updateMapMarker: widget.updateMapMarker);

    currentStopController.model.runData = widget.runData;
    currentStopController.model.progressedRunID = widget.progressedRunID!;
    currentStopController.model.stop = widget.getStop();
    currentStopController.model.updateCurrentStop = widget.updateCurrentStop;
    // currentStopController.model.isRunCompleted = widget.isRunCompleted;


    widget.updateMapMarker(currentStopController.model.stop);

    

  }

  void updateState(){
    if(mounted){
      setState(() {
        
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    print(currentStopController.model.stop);

    double screenWidth = MediaQuery.of(context).size.width;

    return currentStopController.model.runData['runStatus'] == "Completed" ? 

        Center(
          child: Text("Run completed")
        )

      :
    
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: 
            [
              Text("#${currentStopController.model.stop['orderData']['ID'].toString()}", style: Theme.of(context).textTheme.titleSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Stop Number: ", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                        Text(currentStopController.model.stop['stopNumber'].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Stop type: ", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                        Text("${currentStopController.model.stop['stopType'][0].toUpperCase()}${currentStopController.model.stop['stopType'].substring(1)}", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),)
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
                      Text("${currentStopController.model.stop['stopType'][0].toUpperCase()}${currentStopController.model.stop['stopType'].substring(1)} Customer", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                      Text(currentStopController.model.stop['stopData']['name'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),)
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
                        Text("${currentStopController.model.stop['stopType'][0].toUpperCase()}${currentStopController.model.stop['stopType'].substring(1)} Address", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),                      
                        Text(currentStopController.model.stop['stopData']['address1'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18), maxLines: 100,),                         
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${currentStopController.model.stop['stopData']['address2']}, "
                                "${currentStopController.model.stop['stopData']['address3']}",
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),
                                maxLines: 100,
                              ),
                            ),
                          ]
                        ),
                        Text(currentStopController.model.stop['stopData']['postcode'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),
                      ]              
                    )
                  ),
                ]              
              ),
              SizedBox(height: 10),

              //if stop is collection need to show delivery address so drivers can write on the boxes

              if(currentStopController.model.stop['stopType'] == "collection") 

                ...[
                  Divider(height: 1,),
                  SizedBox(height: 10,),
                  Row(
                    children:[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Icon(Icons.person),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Delivery Customer", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                          Text(currentStopController.model.stop['stopData']['name'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),)
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
                            Text(currentStopController.model.stop['orderData']['deliveryAddress1'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18), maxLines: 100,),                         
                            Row(
                              children: [
                                Expanded(
                                  child:Text(
                                    "${currentStopController.model.stop['orderData']['deliveryAddress2']}, "
                                    "${currentStopController.model.stop['orderData']['deliveryAddress3']}", 
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18), maxLines: 100,
                                  ),
                                )
                              ]
                            ),
                            Text(currentStopController.model.stop['orderData']['deliveryPostcode'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),
                          ]              
                        )
                      ),
                    ]              
                  ),
                  
                  SizedBox(height: 10),


                ],


              Center(
                child: Material(
                  color: Theme.of(context).colorScheme.secondary,
                  shadowColor: Color(0x00000000),                                
                  borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                  child: MaterialButton(
                    onPressed: () { currentStopController.navigate(currentStopController.model.stop, context);},
                    minWidth: screenWidth * 0.9,
                    height: screenWidth * 0.1,
                    child: Text("Navigate", style: TextStyle(color: Colors.white)),
                  ),
                ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text("Animal type:",  style: Theme.of(context).textTheme.labelSmall), 
                        ),
                        Expanded(
                          child: Text(currentStopController.model.stop['stopData']['animalType'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                        )
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Text("Quantity:",  style: Theme.of(context).textTheme.labelSmall),
                        ), 
                        Expanded(
                          child: Text(currentStopController.model.stop['stopData']['quantity'].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                        )                    
                      ],
                    ),

                    Row(
                      children:[
                        Expanded(
                          child: Text("Phone Number:",  style: Theme.of(context).textTheme.labelSmall), 
                        ),
                        Expanded(
                          child: Text(currentStopController.model.stop['stopData']['phoneNumber'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                        ),
                      ]
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Text("Collecting payment:",  style: Theme.of(context).textTheme.labelSmall), 
                        ),
                        Expanded(
                          child: currentStopController.model.stop['deferredPayment'] == true ?

                            //if deferred payment type of true it means it was paid on collection when it was stated to be paid on delivery
                            currentStopController.model.stop['deferredPaymentDoc']['deferredPaymentType'] == true ? 

                                GestureDetector(
                                  onTap: (){showDialog(context: context, builder: (context){return DeferredPaymentHint(hintType: "Early");});},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("No", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                                        Icon(Icons.warning_amber_rounded, color: Colors.amber,),  
                                      ]
                                    )
                                  )
                                )

                              :

                                GestureDetector(
                                  onTap: (){showDialog(context: context, builder: (context){return DeferredPaymentHint(hintType: "Late");});},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.red
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Yes", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                                        Icon(Icons.warning_amber_rounded, color: Colors.amber,),  
                                      ]
                                    )
                                  )
                                )
                              
                            :
                          
                              Text(currentStopController.model.stop['stopData']['payment'] ? "Yes" : "No", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                        ),
                      ],
                    ),

                    if(currentStopController.model.stop['stopData']['payment'])

                      Row(
                        children: [
                          Expanded(
                            child: Text("Amount to collect:",  style: Theme.of(context).textTheme.labelSmall), 
                          ),
                          Expanded(
                            child: Text(currentStopController.model.stop['orderData']['price'] == null ? "N/A" : "£${currentStopController.model.stop['orderData']['price']}",  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)), 
                          ),
                        ],
                      ),

                    SizedBox(height: 10), 
                        
                    Text("Customer Message:",  style: Theme.of(context).textTheme.labelSmall),                   
                    Text(currentStopController.model.stop['orderData']['message'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible), softWrap: true),
                    
                        
                  ],
                ),
              ),


              SizedBox(height: 10),

              Divider(height: 1,),

              //staff labels 

              if(currentStopController.model.stop['label'] != null)

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children:[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(Icons.handshake),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Method of contact", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                            Text(currentStopController.model.stop['label']['methodOfContact'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),)
                          ],
                        ),
                      ]
                    ),
                    SizedBox(height: 10),
                    Row(
                      children:[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(Icons.phone),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Call before arrival", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                              Text(currentStopController.model.stop['label']['arrivalNotice'] == "yes" ? (currentStopController.model.stop['label']['noticePeriod'] ?? "N/A") + " mins" : currentStopController.model.stop['label']['arrivalNotice'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),
                            ]              
                          )
                        ),
                      ]              
                    ),
                    SizedBox(height: 10),
                    Row(
                      children:[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Icon(Icons.message),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Staff Message", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                              Text(currentStopController.model.stop['label']['message'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),
                            ]              
                          )
                        ),
                      ]              
                    ),
                    SizedBox(height: 10),
                    Divider(height: 1,),
                  ]
                ),

              SizedBox(height: 20),
                
              Center(
                child: ActionSlider.standard(
                  icon: Icon(Icons.phone),
                  toggleColor: const Color.fromARGB(128, 229, 0, 46),
                  backgroundColor: const Color.fromARGB(255, 246, 246, 246),
                  boxShadow: [BoxShadow(color: const Color.fromARGB(255, 206, 206, 206), blurRadius: 0, spreadRadius: 1)],
                  borderWidth: 4,
                  child: Text("Slide to call customer", style: TextStyle(color: Colors.black),),
                  action: (controller) async { await currentStopController.callCustomer(controller, context);}
                )
              ),


              ...currentStopController.model.showStopForm ?

                [
                  StopForm(updateStopScreenState: updateState, updateMapMarker: currentStopController.updateMapMarkerNextStop, hideStopForm: currentStopController.hideStopFrom, completeStop: currentStopController.model.completeStop, getShouldCallAdmin: currentStopController.model.getShouldCallAdmin, callAdmin: currentStopController.model.callAdmin,),
                ]

              :
                [
                  
                  SizedBox(height: 20),
                  Center(
                    child: Material(
                      color: Colors.green,
                      shadowColor: Color(0x00000000),                                
                      borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                      child: MaterialButton(
                        onPressed: () { currentStopController.showStopForm();},
                        minWidth: screenWidth * 0.9,
                        height: screenWidth * 0.1,
                        child: Text("Arrived", style: TextStyle(color: Colors.white)),
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
                      action: (controller) async { await currentStopController.skipStop(controller, context);}
                    )
                  )
                ]
            ]
        );
  }
}