import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/radio_buttons.dart';
import 'package:high_flyers_app/components/squared_input.dart';
import 'package:high_flyers_app/components/stop_info_card.dart';
import 'package:high_flyers_app/controllers/admin_label_order_form_screen_controller.dart';

class AdminLabelOrderFormScreen extends StatefulWidget {

  static final String id = "Admin label order form screen";
  final Map<String, dynamic>? runData;
  final Map<String, dynamic> stop;
  final String runDocID;

  const AdminLabelOrderFormScreen({super.key, required this.runDocID, required this.stop, required this.runData});

  @override
  State<AdminLabelOrderFormScreen> createState() => _AdminLabelOrderFormScreenState();
}

class _AdminLabelOrderFormScreenState extends State<AdminLabelOrderFormScreen> {

  late final AdminLabelOrderFormScreenController adminLabelOrderFormScreenController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminLabelOrderFormScreenController = AdminLabelOrderFormScreenController(runDocID: widget.runDocID, stop: widget.stop, runData: widget.runData, updateState: updateState);
    adminLabelOrderFormScreenController.setFormData();
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

    final stop = adminLabelOrderFormScreenController.model.stop;

    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(screenWidth * 0.05, 0, screenWidth * 0.05, 0),
            child: 
              ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: screenWidth * 0.05,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(stop['orderData']['ID'].toString(), style: Theme.of(context).textTheme.titleSmall,),
                      Text(stop['stopType'], style: Theme.of(context).textTheme.titleSmall,),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("${stop['orderData']['quantity'].toString()}x ", style: Theme.of(context).textTheme.titleSmall),
                      Text(stop['orderData']['animalType'], style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("${stop['orderData']['boxes'].toString()}x ", style: Theme.of(context).textTheme.titleSmall),
                      Text("Boxes", style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Estimated Arrival Time:", style: Theme.of(context).textTheme.titleSmall),
                      Text(stop['stopTime']?.toString() ?? "unknown", style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payment:", style: Theme.of(context).textTheme.titleSmall),
                      Text(stop['orderData']['payment'], style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                  SizedBox(height: 20,),
                  
                  StopInfoCard(stop: stop, stopType: 'collection', highlightStop: stop['stopType'] == "collection"),
                  SizedBox(height: 10,),
                  StopInfoCard(stop: stop, stopType: 'delivery', highlightStop: stop['stopType'] == "delivery"),

                  SizedBox(height: 20,),

                  Center(
                    child: Material(
                      color: Theme.of(context).colorScheme.secondary,
                      shadowColor: Color(0x00000000),                                
                      borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                      child: MaterialButton(
                        onPressed: (){adminLabelOrderFormScreenController.onUpdateOrderTap(context);},
                        minWidth: screenWidth * 0.9,
                        height: screenWidth * 0.1,
                        child: Text("Update Order", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),  

                  SizedBox(height: 20,), 

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text("Method of contact:", style: Theme.of(context).textTheme.labelMedium,),                        
                      RadioButtons(
                        radioValues: adminLabelOrderFormScreenController.model.methodsOfContact, 
                        onPressed: adminLabelOrderFormScreenController.methodOfContactOnPressed,
                        isSelected: adminLabelOrderFormScreenController.model.methodOfContactIsSelected
                      )
                    ]
                  ),

                  SizedBox(height: 10,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text("Call before arrival:", style: Theme.of(context).textTheme.labelMedium,),                        
                      RadioButtons(
                        radioValues: adminLabelOrderFormScreenController.model.callBeforeArrival, 
                        onPressed: adminLabelOrderFormScreenController.callBeforeArrivalOnPressed,
                        isSelected: adminLabelOrderFormScreenController.model.callBeforeArrivalIsSelected
                      )
                    ]
                  ),

                  if(adminLabelOrderFormScreenController.model.shouldShowNoticeInput)

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        SizedBox(height: 10,),
                        Text("Notice period (mins):", style: Theme.of(context).textTheme.labelMedium,),                        
                        SquaredInput(onChange: adminLabelOrderFormScreenController.noticePeriodOnChange, keyboardType: TextInputType.number, value: adminLabelOrderFormScreenController.model.noticePeriod,)
                      ]
                    ),

                  SizedBox(height: 10,),

                  Text("Message:", style: Theme.of(context).textTheme.labelMedium,),
                  TextField(
                    controller: TextEditingController(text: adminLabelOrderFormScreenController.model.message),
                    maxLines: null,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2.0, 
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (input){adminLabelOrderFormScreenController.onMessageChange(input);},
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                  ),              

                  SizedBox(height: 10,),

                  Center(
                    child: Material(
                      color: Theme.of(context).colorScheme.secondary,
                      shadowColor: Color(0x00000000),                                
                      borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                      child: MaterialButton(
                        onPressed: adminLabelOrderFormScreenController.onSaveTap,
                        minWidth: screenWidth * 0.9,
                        height: screenWidth * 0.1,
                        child: Text("Save", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),              

                  SizedBox(height: 10,),

                ],                
              ),
          ),
        ),
    );
  }
}