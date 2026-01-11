import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:high_flyers_app/components/button_pill.dart';
import 'package:high_flyers_app/components/radio_buttons.dart';
import 'package:high_flyers_app/components/squared_input.dart';
import 'package:high_flyers_app/components/stop_info_card.dart';
import 'package:high_flyers_app/controllers/admin_label_order_form_screen_controller.dart';

class AdminLabelOrderFormScreen extends StatefulWidget {

  static final String id = "Admin label order form screen";
  final Map<String, dynamic>? stop;

  const AdminLabelOrderFormScreen({super.key, required this.stop});

  @override
  State<AdminLabelOrderFormScreen> createState() => _AdminLabelOrderFormScreenState();
}

class _AdminLabelOrderFormScreenState extends State<AdminLabelOrderFormScreen> {

  late final AdminLabelOrderFormScreenController adminLabelOrderFormScreenController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminLabelOrderFormScreenController = AdminLabelOrderFormScreenController(stop: widget.stop, updateState: updateState);
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
        body:SafeArea(
          child: Expanded(
            child: Padding(
              padding: EdgeInsetsGeometry.fromLTRB(screenWidth * 0.05, screenWidth * 0.05, screenWidth * 0.05, 0),
              child: 
                ListView(
                  shrinkWrap: true,
                  children: [
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
                        Text(stop['stopTime'], style: Theme.of(context).textTheme.titleSmall),
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
                          onPressed: () { },
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
                        Text("Method Of Contact:", style: Theme.of(context).textTheme.labelMedium,),                        
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
                              
                  ],                
                ),
            ),
          ),
        )
    );
  }
}