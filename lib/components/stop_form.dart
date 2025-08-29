import 'package:flutter/material.dart';

class StopForm extends StatefulWidget {

  final void Function() updateState;
  final void Function() hideStopForm;

  const StopForm(this.updateState, this.hideStopForm, {super.key});

  @override
  State<StopForm> createState() => _StopFormState();
}

class _StopFormState extends State<StopForm> {
  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.white,
            shadowColor: Color(0x00000000),                                
            borderRadius: BorderRadius.all(Radius.circular(8)),                                     
            child: MaterialButton(
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
        ),
        TextField(
          onChanged: (input) => { },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "notes",
            alignLabelWithHint: true,
            hintStyle: TextStyle(
              color: Color(0xFF898989),
            ),
          ),
        ),
      ]
      
    );
  }
}