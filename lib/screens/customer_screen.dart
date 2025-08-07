import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/customer_screen_controller.dart';

class CustomerScreen extends StatefulWidget {
  static String id = "Customer Screen";

  final CustomerScreenController controller;

  // final LoginScreenController controller;

  const CustomerScreen({super.key, required this.controller});

  //declare model here

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Text("Customer Screen"),
    );
  }
}
