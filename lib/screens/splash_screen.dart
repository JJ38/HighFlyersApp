import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),  
        child: Center(
          child: Image.asset(
                "assets/images/pigeon.png",
                width: screenWidth * 0.25,
                fit: BoxFit.contain,
              ),
        ),
      )
    );
  }
}