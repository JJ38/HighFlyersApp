import 'package:flutter/material.dart';

class StopCard extends StatelessWidget {

  final dynamic stop;
  final double width;

  const StopCard({super.key, required this.stop, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Color.fromARGB(64, 0, 0, 0), blurRadius: 10, spreadRadius: -4)
        ]
      ),
      child: Text("enadoaw")
    );
  }
}