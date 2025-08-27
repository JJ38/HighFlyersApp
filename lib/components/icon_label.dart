import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {

  final IconData icon;
  final Widget child;
  final double spacing;

  const IconLabel({super.key, required this.icon, required this.child, this.spacing = 25});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 30,
        ),
        SizedBox(width: spacing,),
        child
      ]
    );
  }
}