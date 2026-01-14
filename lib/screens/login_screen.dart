import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/login_screen_controller.dart';
import 'package:high_flyers_app/components/button_pill.dart';
import 'package:high_flyers_app/components/input_pill.dart';
import 'package:sentry_flutter/sentry_flutter.dart';


class LoginScreen extends StatefulWidget {
  static String id = 'Login Screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //<a href="https://www.flaticon.com/free-icons/peace" title="peace icons">Peace icons created by Freepik - Flaticon</a>

  late LoginScreenController loginScreenController;
  String? test;

  @override
  void initState(){
    super.initState();
    loginScreenController = LoginScreenController(updateState: updateState);

  }

  void updateState(){
    if(mounted){
      setState(() {
        
      });
    }
  }

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
                  onChange: loginScreenController.usernameInputController,
                ),
                InputPill(
                    text: "Password",
                    obscureText: true,
                    onChange: loginScreenController.passwordInputController),

                loginScreenController.model.isLoading ?

                  Center(
                    child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary,)
                  )

                :
                 
                  ButtonPill(
                    text: "Login",
                    buttonColor: Theme.of(context).colorScheme.secondary,
                    action: () {loginScreenController.login(context);},
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
