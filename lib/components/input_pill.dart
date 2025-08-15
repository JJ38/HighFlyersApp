import 'package:flutter/material.dart';

class InputPill extends StatelessWidget {

  final String? text;
  final String textfieldValue = '';
  final IconData? iconData;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String) onChange;

  const InputPill({this.text, this.iconData, this.keyboardType = TextInputType.text, this.obscureText = false, required this.onChange, super.key});

  String getInputValue() {
    return textfieldValue;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double pillWidth = screenWidth * 0.8;
    final double pillHeight = pillWidth * (1 / 6);

    return Stack(
      children: [
        Container(
          width: pillWidth,
          height: pillHeight,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                  color: Color(0x44000000))
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
        ),
        Positioned.fill(
          child: Row(
            children: [
              SizedBox(
                width: pillWidth * 0.035,
              ),
              iconData != null ? Text(
                //Icon in the form of text to allow shadow.
                String.fromCharCode(iconData!.codePoint),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontFamily: iconData!.fontFamily,
                  fontSize: pillHeight * 0.5,
                  shadows: [
                    BoxShadow(
                      blurRadius: 4,
                      offset: Offset(0, 0),
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  ],
                ),
              ) : SizedBox(width: 0, height: 0,),
              SizedBox(
                width: pillWidth * 0.02,
              ),
              SizedBox(
                width: pillWidth * 0.8,
                child: TextField(
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  onChanged: (input) => { onChange(input)},
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: text,
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(
                      fontSize: pillHeight * 0.33,
                      color: Color(0xFF898989),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}