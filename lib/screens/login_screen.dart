import 'package:flutter/material.dart';

import 'package:high_flyers_app/controllers/login_screen_controller.dart';

import 'package:high_flyers_app/components/button_pill.dart';
import 'package:high_flyers_app/components/input_pill.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'Login Screen';

  final LoginScreenController controller;

  //declare model here

  const LoginScreen({super.key, required this.controller});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //<a href="https://www.flaticon.com/free-icons/peace" title="peace icons">Peace icons created by Freepik - Flaticon</a>

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/pigeon.png",
                  scale: screenWidth * 0.015,
                ),
                SizedBox(
                  width: screenWidth * 0.05,
                ),
                Text(
                  "High Flyers",
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
            SizedBox(height: 50),
            Column(
              spacing: 20,
              children: [
                InputPill(
                  text: "Username",
                  onChange: widget.controller.usernameInputController,
                ),
                InputPill(
                    text: "Password",
                    obscureText: true,
                    onChange: widget.controller.passwordInputController),
                ButtonPill(
                    text: "Login",
                    buttonColor: Theme.of(context).colorScheme.secondary,
                    action: () {
                      setState(() {
                        widget.controller.login(context);
                      });
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
