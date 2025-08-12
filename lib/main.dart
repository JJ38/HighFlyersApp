import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/driver/driver_screen.dart';
import 'screens/customer/customer_screen.dart';
import 'screens/admin/admin_screen.dart';

import 'controllers/login_screen_controller.dart';
import 'controllers/customer_screen_controller.dart';
import 'controllers/admin_screen_controller.dart';

void main() async {
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp, // Normal Portrait
  // ]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //Look into refactoring before release. Wasteful to initialise unnecessarily. Just do it in the constructor DriverScreen(controller: DriverScreenController())

  final LoginScreenController loginScreenController = LoginScreenController();
  final CustomerScreenController customerScreenController =
      CustomerScreenController();
  final AdminScreenController adminScreenController = AdminScreenController();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'High Flyers App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white, secondary: Color(0xFF2881FF)),
        useMaterial3: true,
        textTheme: TextTheme(
            titleLarge: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, overflow: TextOverflow.ellipsis),
            titleSmall: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
            labelLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF2881FF), overflow: TextOverflow.ellipsis),
            labelMedium: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 77, 77, 77), overflow: TextOverflow.ellipsis),
            labelSmall: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color.fromARGB(255, 77, 77, 77), overflow: TextOverflow.ellipsis),
        ),
      ),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) =>
            LoginScreen(controller: loginScreenController),
        DriverScreen.id: (context) => DriverScreen(),
        CustomerScreen.id: (context) =>
            CustomerScreen(controller: customerScreenController),
        AdminScreen.id: (context) =>
            AdminScreen(controller: adminScreenController),
      },
    );
  }
}
