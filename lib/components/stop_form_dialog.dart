import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/stop_form.dart';
import 'package:high_flyers_app/controllers/stop_form_dialog_controller.dart';

class StopFormDialog extends StatefulWidget {

  final Map<String, dynamic> stop;
  final Map<String, dynamic>? runData;
  final String? progressedRunID;

  const StopFormDialog({super.key, required this.stop, this.runData, this.progressedRunID});

  @override
  State<StopFormDialog> createState() => _StopFormDialogState();
}

class _StopFormDialogState extends State<StopFormDialog> {

  late final StopFormDialogController stopFormDialogController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stopFormDialogController = StopFormDialogController(updateState: updateState, stop: widget.stop, runData: widget.runData, progressedRunID: widget.progressedRunID);
    print(widget.stop['formDetails']);
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

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: SizedBox(
        width: screenWidth,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: Colors.white,
                        shadowColor: Color(0x00000000),                                
                        borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                        child: MaterialButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {stopFormDialogController.closeDialog(context);},
                          minWidth: screenWidth * 0.2,
                          height: screenWidth * 0.1,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back, size: 35,),
                              Text("Close stop form", style: Theme.of(context).textTheme.labelSmall,)
                            ]
                          ),
                        ),
                      ),
                      // SizedBox(height: 20),
                      Text("Stop details", style: Theme.of(context).textTheme.titleSmall),
                      SizedBox(height: 20),
                      DropdownButtonFormField(
                        value: stopFormDialogController.model.animalType,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                        decoration: InputDecoration(
                          label: Text("Animal Type"),
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
                        onChanged: (value) {stopFormDialogController.onAnimalTypeSelect(value);},
                        items: [
                          DropdownMenuItem(
                            value: 'Pigeons - Young Birds',
                            child: Text('Pigeons - Young Birds'),
                          ),
                          DropdownMenuItem(
                            value: 'Pigeons - Old Birds',
                            child: Text('Pigeons - Old Birds'),
                          ),
                          DropdownMenuItem(
                            value: 'Aviary & Cage Birds',
                            child: Text('Aviary & Cage Birds'),
                          ),
                          DropdownMenuItem(
                            value: 'Birds Of Prey',
                            child: Text('Birds Of Prey'),
                          ),
                          DropdownMenuItem(
                            value: 'Reptiles',
                            child: Text('Reptiles'),
                          ),
                          DropdownMenuItem(
                            value: 'Small Mammals',
                            child: Text('Small Mammals'),
                          ),
                          DropdownMenuItem(
                            value: 'Small Rodents',
                            child: Text('Small Rodents'),
                          ),
                          DropdownMenuItem(
                            value: 'Poultry & Gamebirds',
                            child: Text('Poultry & Gamebirds'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: TextEditingController(text: stopFormDialogController.model.quantity?.toString()),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                        decoration: InputDecoration(
                          label: Text("Quantity"),
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
                        keyboardType: TextInputType.number,
                        onChanged: (input) {stopFormDialogController.onQuantityInput(input);},
                      ),
                      SizedBox(height: 20),
                      
                      DropdownButtonFormField(
                        value: stopFormDialogController.model.collectedPayment,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                        decoration: InputDecoration(
                          label: Text("Collected Payment"),
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
                        onChanged: (value){stopFormDialogController.onCollectedPaymentSelect(value);},
                        items: [
                          DropdownMenuItem(
                            value: true,
                            child: Text('Yes'),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text('No'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: TextEditingController(text: stopFormDialogController.model.notes),
                        maxLines: null,
                        decoration: InputDecoration(
                          label: Text("Notes"),
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
                        onChanged: (input){stopFormDialogController.onNotesInput(input);},
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ActionSlider.standard(
                          icon: Icon(Icons.done),
                          toggleColor: Colors.green,
                          backgroundColor: const Color.fromARGB(255, 246, 246, 246),
                          boxShadow: [BoxShadow(color: const Color.fromARGB(255, 206, 206, 206), blurRadius: 0, spreadRadius: 1)],
                          borderWidth: 4,
                          child: 
                            stopFormDialogController.model.stop['formDetails'] == null ?  

                                Text("Slide to complete stop", style: TextStyle(color: Colors.black),)
                              
                              :

                                Text("Slide to update stop", style: TextStyle(color: Colors.black),),

                          action: (controller) async {stopFormDialogController.completeStop(controller, context);}
                        )
                      )
                    ]
                    
                  )
                ],
              )
            )
          )
        )
      )
    );
  }
}