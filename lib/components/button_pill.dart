import 'package:flutter/material.dart';


class ButtonPill extends StatelessWidget {

  final String text;
  final Function()? action;
  final Color? buttonColor;

  const ButtonPill({this.text = "Click Me", this.buttonColor, this.action, super.key});

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;

    double pillWidth = screenWidth * 0.8;
    double pillHeight = pillWidth * (1 / 6);

    double radius = 32;

    return Material(
      color: buttonColor,
      shadowColor: buttonColor,
      borderRadius: BorderRadius.all(
        Radius.circular(radius),
      ),
      elevation: 5.0,
      child: MaterialButton(
        onPressed: action,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        minWidth: pillWidth,
        height: pillHeight,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}