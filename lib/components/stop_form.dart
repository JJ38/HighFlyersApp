import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/stop_form_controller.dart';
import 'package:high_flyers_app/controllers/stop_screen_controller.dart';

class StopForm extends StatefulWidget {

  final void Function() updateStopScreenState;
  final void Function() hideStopForm;
  final Future<bool> Function() completeStop;

  const StopForm({required this.updateStopScreenState, required this.hideStopForm, required this.completeStop, super.key});

  @override
  State<StopForm> createState() => _StopFormState();
}

class _StopFormState extends State<StopForm> {

  late StopFormController stopFormController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stopFormController = StopFormController(updateStopScreenState: widget.updateStopScreenState, hideStopForm: widget.hideStopForm);
    stopFormController.model.completeStop = widget.completeStop;
  }

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.white,
          shadowColor: Color(0x00000000),                                
          borderRadius: BorderRadius.all(Radius.circular(8)),                                     
          child: MaterialButton(
            padding: EdgeInsets.all(0),
            onPressed: () {widget.hideStopForm();},
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
          value: stopFormController.model.animalType,
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
          onChanged: (value) {stopFormController.onAnimalTypeSelect(value.toString());},
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
          onChanged: (input) {stopFormController.onQuantityInput(input);},
        ),
        SizedBox(height: 20),
        
        DropdownButtonFormField(
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
          onChanged: (value){stopFormController.onCollectedPaymentSelect(value);},
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
          onChanged: (input){stopFormController.onNotesInput(input);},
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
            child: Text("Slide to complete stop", style: TextStyle(color: Colors.black),),
            action: (controller) async { await stopFormController.completeStop(controller);}
          )
        )
      ]
      
    );
  }
}