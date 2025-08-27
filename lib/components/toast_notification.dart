import 'package:flutter/material.dart';

class ToastNotification extends StatelessWidget {
  
  final String message;
  final bool isError;

  const ToastNotification({super.key, required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.8,
      decoration: BoxDecoration(
        color: isError ? Theme.of(context).colorScheme.errorContainer : Colors.green[300],
        border: BoxBorder.all(
          color: isError ? Theme.of(context).colorScheme.error : Colors.green[700]!,
          width: 1.0, 
        ),
        borderRadius: BorderRadiusGeometry.all(Radius.circular(3))
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          spacing: 10.0,
          children: [
            isError ? 
              Icon(
                Icons.error_outline_rounded,
                size: 30.0,
                color: Colors.white,
              )
            :
              Icon(
                Icons.done_rounded,
                size: 30.0,
                color: Colors.white,
              ),
            Text(message, style: TextStyle(fontSize: 16.0, color: Colors.white)),
          ]
        )
      )
    );
  }
}