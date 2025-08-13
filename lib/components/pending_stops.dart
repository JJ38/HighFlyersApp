import 'package:flutter/material.dart';

class PendingStops extends StatefulWidget {
  const PendingStops({super.key});

  @override
  State<PendingStops> createState() => _PendingStopsState();
}

class _PendingStopsState extends State<PendingStops> {
  @override
  Widget build(BuildContext context) {
    return Text("pending stops");
  }
}