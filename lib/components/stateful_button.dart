import 'package:flutter/material.dart';

class StatefulButton extends StatefulWidget {

  final dynamic controller;

  const StatefulButton({super.key, required this.controller});

  @override
  State<StatefulButton> createState() => _StatefulButtonState();
}

class _StatefulButtonState extends State<StatefulButton> {

  late dynamic controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = widget.controller;
    controller.setStatefulButtonUpdateState(updateState);
  }

  void updateState(){

    setState(() {
      
    });

  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;

    return controller.model.showUpdateButton ? 

      Center(
        child: Material(
          color: Theme.of(context).colorScheme.secondary,
          shadowColor: Color(0x00000000),                                
          borderRadius: BorderRadius.all(Radius.circular(8)),                                     
          child: MaterialButton(
            onPressed: (){},
            minWidth: screenWidth * 0.9,
            height: screenWidth * 0.1,
            child: Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ),
      )

    :

      SizedBox(height: 0,);   
  }
}