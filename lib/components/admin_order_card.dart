import 'package:flutter/material.dart';

class AdminOrderCard extends StatelessWidget {

  final Map<String, dynamic> order;

  const AdminOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Column(
        children: [
          Text(order['ID'].toString())
        ],
      ),
    );
  }
}