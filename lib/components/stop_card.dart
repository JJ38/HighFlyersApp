import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/deferred_payment_hint.dart';
import 'package:high_flyers_app/controllers/stop_card_controller.dart';

class StopCard extends StatefulWidget {

  final Map<String, dynamic> stop;
  final Map<String, dynamic>? runData;
  final String? progressedRunID;
  final double width;
  final bool shouldShowOpenFormButton;

  const StopCard({super.key, required this.width, required this.stop, this.shouldShowOpenFormButton = false, this.runData, this.progressedRunID});

  @override
  State<StopCard> createState() => _StopCardState();
}

class _StopCardState extends State<StopCard> {

  late StopCardController stopCardController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stopCardController = StopCardController(updateState: updateState, stop: widget.stop, runData: widget.runData, progressedRunID: widget.progressedRunID);
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

    print(stopCardController.model.stop['stopStatus']);

    return GestureDetector(
      onTap: stopCardController.onTap,
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: EdgeInsets.all(5),
        width: widget.width,
        decoration: BoxDecoration(
          color: switch(stopCardController.model.stop['stopStatus']){
                    'Skipped' => const Color.fromARGB(255, 255, 241, 119),
                    'Complete' => const Color.fromARGB(255, 148, 255, 152),               
                    _ => Colors.white
                  }, 
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: stopCardController.model.shouldHighlightStop ?

                const Color(0xFF2881FF) 

                    : 

                  switch(stopCardController.model.stop['stopStatus']){
                    'Skipped' => Colors.yellow,
                    'Complete' => Color.fromARGB(255, 148, 255, 152),               
                    _ => Color.fromARGB(69, 0, 0, 0)
                  }, 

              blurRadius: 10, 
              spreadRadius: -4
            )
          ]//
        ),
        child: stopCardController.model.expandCard ?

            Column(
              children: [

                SizedBox(height: 20,),

                Row(  
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text("#${stopCardController.model.stop['stopData']['ID']}", style: Theme.of(context).textTheme.labelMedium),
                    // Text(stop['stopType'] == "collection" ? "Collection" : "Delivery", style: Theme.of(context).textTheme.labelMedium)
                    Text(stopCardController.model.stop['stopNumber'].toString(), style: Theme.of(context).textTheme.labelLarge, selectionColor: Color(0xFF2881FF)),
                  ],
                ),

                SizedBox(height: 10,),

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
                            child: Text(stopCardController.model.stop['stopData']['animalType'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                          )
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Text("Quantity:",  style: Theme.of(context).textTheme.labelSmall),
                          ), 
                          Expanded(
                            child: Text(stopCardController.model.stop['stopData']['quantity'].toString(), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                          )                    
                        ],
                      ),

                      Row(
                        children:[
                          Expanded(
                            child: Text("Phone Number:",  style: Theme.of(context).textTheme.labelSmall), 
                          ),
                          Expanded(
                            child: Text(stopCardController.model.stop['stopData']['phoneNumber'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                          ),
                        ]
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Text("Collect payment:",  style: Theme.of(context).textTheme.labelSmall), 
                          ),
                          Expanded(
                            child: stopCardController.model.stop['deferredPayment'] == true ?

                              //if deferred payment type of true it means it was paid on collection when it was stated to be paid on delivery
                              stopCardController.model.stop['deferredPaymentDoc']['deferredPaymentType'] == true ? 

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
                            
                                Text(stopCardController.model.stop['stopData']['payment'] ? "Yes" : "No", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                          ),
                        ],
                      ),

                      if(stopCardController.model.stop['stopData']['payment'])

                        Row(
                          children: [
                            Expanded(
                              child: Text("Amount to collect:",  style: Theme.of(context).textTheme.labelSmall), 
                            ),
                            Expanded(
                              child: Text(stopCardController.model.stop['orderData']['price'] == null ? "N/A" : "£${stopCardController.model.stop['orderData']['price']}",  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)), 
                            ),
                          ],
                        ),

                      SizedBox(height: 10), 
                          
                      Text("Customer Message:",  style: Theme.of(context).textTheme.labelSmall),                   
                      Text(stopCardController.model.stop['orderData']['message'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible), softWrap: true),
                      
                          
                    ],
                  ),
                ),

                SizedBox(height: 10,),


                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: stopCardController.model.stop['stopType'] == "collection" ? Colors.red : const Color.fromARGB(0, 33, 149, 243)
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Collection Address", style: Theme.of(context).textTheme.labelMedium, maxLines: 1),
                      SizedBox(height: 5,),
                      Padding(
                        padding: EdgeInsetsGeometry.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(stopCardController.model.stop['orderData']['collectionAddress1'].trim(), style: Theme.of(context).textTheme.titleSmall, maxLines: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${stopCardController.model.stop['orderData']['collectionAddress2']}, "
                                    "${stopCardController.model.stop['orderData']['collectionAddress3']}",
                                    style: Theme.of(context).textTheme.labelSmall,
                                    maxLines: 100,
                                  ),
                                )                      
                              ]
                            ),
                            
                            Text(stopCardController.model.stop['orderData']['collectionPostcode'].trim(), style: Theme.of(context).textTheme.labelSmall),
                            Text("Phone Number: ${stopCardController.model.stop['orderData']['collectionPhoneNumber'].trim()}", style: Theme.of(context).textTheme.labelSmall),
                          ]
                        ),
                      ),
                    ]
                  ),
                ),
                
                SizedBox(height: 10,),
                Divider(height: 1,),
                SizedBox(height: 10,),
                
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: stopCardController.model.stop['stopType'] == "delivery" ? Colors.blue : const Color.fromARGB(0, 33, 149, 243)
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Delivery Address", style: Theme.of(context).textTheme.labelMedium, maxLines: 1),
                      SizedBox(height: 5,),
                      Padding(
                        padding: EdgeInsetsGeometry.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(stopCardController.model.stop['orderData']['deliveryAddress1'].trim(), style: Theme.of(context).textTheme.titleSmall, maxLines: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${stopCardController.model.stop['orderData']['deliveryAddress2']}, "
                                    "${stopCardController.model.stop['orderData']['deliveryAddress3']}",
                                    style: Theme.of(context).textTheme.labelSmall,
                                    maxLines: 100,
                                  ),
                                )                      
                              ]
                            ),
                            Text(stopCardController.model.stop['orderData']['deliveryPostcode'].trim(), style: Theme.of(context).textTheme.labelSmall),
                            Text("Phone Number: ${stopCardController.model.stop['orderData']['deliveryPhoneNumber'].trim()}", style: Theme.of(context).textTheme.labelSmall),
                          ]
                        ),
                      ),
                    ]
                  ),
                ),

                SizedBox(height: 10,),
                Divider(height: 1,),
  
                if(stopCardController.model.stop['label'] != null)

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
                              Text(stopCardController.model.stop['label']['methodOfContact'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),)
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
                                Text(stopCardController.model.stop['label']['arrivalNotice'] == "yes" ? (stopCardController.model.stop['label']['noticePeriod'] ?? "N/A") + " mins" : stopCardController.model.stop['label']['arrivalNotice'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),
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
                                Text(stopCardController.model.stop['label']['message'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18), maxLines: 100,),
                              ]              
                            )
                          ),
                        ]              
                      ),
                      SizedBox(height: 10),
                      Divider(height: 1,),
                    ]
                  ),

                SizedBox(height: 20,),
                   
                Center(
                  child: ActionSlider.standard(
                    icon: Icon(Icons.phone),
                    toggleColor: const Color.fromARGB(128, 229, 0, 46),
                    backgroundColor: const Color.fromARGB(255, 246, 246, 246),
                    boxShadow: [BoxShadow(color: const Color.fromARGB(255, 206, 206, 206), blurRadius: 0, spreadRadius: 1)],
                    borderWidth: 4,
                    child: Text("Slide to call customer", style: TextStyle(color: Colors.black),),
                    action: (controller) async { await stopCardController.callCustomer(controller, context);}
                  )
                ),
                
                SizedBox(height: 20,),

                if(widget.shouldShowOpenFormButton) 
                  
                  Column(
                    children: [
                      Center(
                        child: Material(
                          color: Theme.of(context).colorScheme.secondary,
                          shadowColor: Color(0x00000000),                                
                          borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                          child: MaterialButton(
                            onPressed: () {stopCardController.openStopFormDialog(context);},
                            minWidth: screenWidth * 0.9,
                            height: screenWidth * 0.1,
                            child: Text("Open Form", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,)
                    ]
                  )
                  
              ],
            )
          
          :

            Column(
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text("#${stopCardController.model.stop['stopData']['ID']}", style: Theme.of(context).textTheme.labelMedium),
                    Text(stopCardController.model.stop['stopType'] == "collection" ? "Collection" : "Delivery", style: Theme.of(context).textTheme.labelMedium)
                  ]
                ),
                Row(
                  spacing: 20,
                  children: [
                    Text(stopCardController.model.stop['stopNumber'].toString(), style: Theme.of(context).textTheme.labelLarge, selectionColor: Color(0xFF2881FF)),
                    //give the width of the row to the column to make sure it doenst overflow and text overflow works
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(stopCardController.model.stop['stopData']['address1'].trim(), style: Theme.of(context).textTheme.titleSmall, maxLines: 1),
                          Row(
                            children: [
                              Text(stopCardController.model.stop['stopData']['address2'].trim() + ", ", style: Theme.of(context).textTheme.labelSmall),
                              Text(stopCardController.model.stop['stopData']['address3'].trim(), style: Theme.of(context).textTheme.labelSmall),
                            ],
                          ),
                          Text(stopCardController.model.stop['stopData']['postcode'].trim(), style: Theme.of(context).textTheme.labelSmall),
                          Text("Phone Number: ${stopCardController.model.stop['stopData']['phoneNumber'].trim()}", style: Theme.of(context).textTheme.labelSmall),
                          ]
                      )
                    )
                  ],
                ),
                if(stopCardController.model.shouldHighlightStop)
                  SizedBox(height: 5,),

                if(stopCardController.model.stop['label']?['arrivalNotice'] == "yes")
                  Row(
                    children: [
                      Text("Notice period: ", style: Theme.of(context).textTheme.labelMedium),
                      Text("${stopCardController.model.stop['label']?['noticePeriod']} mins", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14)),
                    ],               
                  ),

                if(stopCardController.model.stop['label']?['message'] != "" && stopCardController.model.stop['label']?['message'] != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Staff message: ", style: Theme.of(context).textTheme.labelMedium),
                      Expanded(
                        child: Text("${stopCardController.model.stop['label']?['message']}", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, overflow: TextOverflow.visible)),
                      )
                    ],
                  )
                ]
            )
           
      )
    );
  }

}
