import 'package:flutter/material.dart';


class MarkerLabel extends StatelessWidget {

  final String label;

  const MarkerLabel({super.key, this.label = ""});

  final size = 35.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.5, // Make the height slightly taller to accommodate the pin shape
      child: Column(
        children: [
          // This is the main body of the marker (the tear-drop shape).
          // We use a Container with a border radius to create the rounded effect.
          Transform.rotate(
            angle: 45 * 3.14159 / 180,
            child: Container(
              width: size * 0.8,
              height: size * 0.8,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size * 0.4),
                  topRight: Radius.circular(size * 0.4),
                  bottomLeft: Radius.circular(size * 0.4),
                  // bottomRight: Radius.circular(size * 0.4), // Flatten the bottom for the pin effect
                ),
              ),
              child: Center(
                child:Transform.rotate(
                  angle: -45 * 3.14159 / 180, 
                  child: Text(label)
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

