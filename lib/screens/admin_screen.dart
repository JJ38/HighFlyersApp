import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/admin_screen_controller.dart';

class AdminScreen extends StatefulWidget {
  static String id = "Admin Screen";

  final AdminScreenController controller;

  const AdminScreen({super.key, required this.controller});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Text("Admin Screen"),
    );
  }
}
