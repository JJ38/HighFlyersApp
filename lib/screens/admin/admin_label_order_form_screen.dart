import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/admin_label_order_form_screen_controller.dart';

class AdminLabelOrderFormScreen extends StatefulWidget {

  static final String id = "Admin label order form screen";
  final Map<String, dynamic>? stop;

  const AdminLabelOrderFormScreen({super.key, required this.stop});

  @override
  State<AdminLabelOrderFormScreen> createState() => _AdminLabelOrderFormScreenState();
}

class _AdminLabelOrderFormScreenState extends State<AdminLabelOrderFormScreen> {

  late final AdminLabelOrderFormScreenController adminLabelOrderFormScreenController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminLabelOrderFormScreenController = AdminLabelOrderFormScreenController();
  }

  void updateState(){
    if(mounted){
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SafeArea(
          child: Text(""),
        )
    );
  }
}