import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {

  final IconData icon;
  final Widget child;
  final double spacing;

  const IconLabel({super.key, required this.icon, required this.child, this.spacing = 10});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 25,
          weight: 1,
          color:Colors.black,
        ),
        SizedBox(width: spacing),
        child
      ]
    );
  }
}