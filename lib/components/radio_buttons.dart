import 'package:flutter/material.dart';

class RadioButtons extends StatefulWidget {

  final List<dynamic> radioValues;
  void Function(int, void Function()) onPressed;
  final List<bool> isSelected;

  RadioButtons({super.key, required this.radioValues, required this.onPressed, required this.isSelected});

  @override
  State<RadioButtons> createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void updateState(){
    if(mounted){
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return 
      LayoutBuilder(
        builder: (context, constraints) {

          final itemCount = widget.radioValues.length;
          final double borderWidth = 1;
          final double maxWidth = constraints.maxWidth - ((itemCount + 1) *  borderWidth);

          return SizedBox(
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(8),
              selectedColor: const Color.fromARGB(255, 255, 255, 255),
              fillColor: Theme.of(context).colorScheme.secondary,
              color: const Color.fromARGB(255, 0, 0, 0),
              borderColor: Colors.grey,
              selectedBorderColor: Theme.of(context).colorScheme.secondary,
              borderWidth: borderWidth, 
              onPressed: (index){
                widget.onPressed(index, updateState);
              },
              isSelected: widget.isSelected,
              constraints: BoxConstraints(
                maxWidth: maxWidth / itemCount,
                minHeight: 48,
              ),
              children: widget.radioValues.map((method) => Center(child: Text(method))).toList(),
            ),
          );
        },
      );
  }
}