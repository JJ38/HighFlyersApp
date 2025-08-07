import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'controllers/login_screen_controller.dart';

void main() async {
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp, // Normal Portrait
  // ]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // final LoginScreenController loginScreenController = LoginScreenController();

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'High Flyers App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, secondary: Color(0xFF2881FF)),
          useMaterial3: true,
          textTheme: TextTheme(
              titleLarge:
                  const TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) =>
            LoginScreen(controller: LoginScreenController())
      },
    );
  }
}
