import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {

  final IconData icon;
  final Widget child;
  final double spacing;
  final double padding;

  const IconLabel({super.key, required this.icon, required this.child, this.spacing = 30, this.padding = 10});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            weight: 1,
            color: const Color.fromARGB(255, 98, 98, 98),
          ),
          SizedBox(width: spacing),
          child
        ]
      )
    );
  }
}