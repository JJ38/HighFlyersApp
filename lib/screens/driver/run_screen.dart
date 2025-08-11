import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RunScreen extends StatefulWidget {

  static String id = "Run Screen";

  final dynamic runDocument;
                              

  Map<String, dynamic>? runData;
  
  RunScreen({super.key, required this.runDocument});

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {

  @override
  void initState(){
    super.initState();
  
    widget.runData = widget.runDocument.data()! as Map<String, dynamic>;
  }


  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: screenWidth * 0.05), 
        child: SafeArea(
          child: Column(
            children: [
              Text(widget.runDocument.data()?['runName'], style: Theme.of(context).textTheme.titleLarge)
            ],
          )
        ),
      ),
    );
  }
}
