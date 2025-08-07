import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/driver_screen_controller.dart';

class DriverScreen extends StatefulWidget {
  static String id = 'Driver Screen';

  final DriverScreenController controller;

  const DriverScreen({super.key, required this.controller});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Text("Drivers Screen"));
  }
}
