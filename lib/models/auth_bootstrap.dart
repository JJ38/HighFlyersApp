import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/screens/admin/admin_screen.dart';
import 'package:high_flyers_app/screens/customer/customer_screen.dart';
import 'package:high_flyers_app/screens/driver/driver_screen.dart';
import 'package:high_flyers_app/screens/login_screen.dart';
import 'package:high_flyers_app/screens/splash_screen.dart';


class AuthBootstrap extends StatelessWidget {

  const AuthBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen(); // loading UI
        }

        final user = snapshot.data;

        if (user == null) {
          return LoginScreen();
        }

        return FutureBuilder(
          future: user.getIdTokenResult(true),
          builder: (context, tokenSnapshot) {
            if (!tokenSnapshot.hasData) {
              return const SplashScreen();
            }

            final role = tokenSnapshot.data!.claims?['role'];

            switch (role) {
              case 'driver':
                return DriverScreen();
              case 'customer':
                return CustomerScreen();
              case 'admin':
                return AdminScreen();
              default:
                return LoginScreen(); // or error screen
            }
          },
        );
      },
    );
  }
}
