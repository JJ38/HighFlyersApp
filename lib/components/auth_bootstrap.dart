import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/screens/admin/admin_screen.dart';
import 'package:high_flyers_app/screens/customer/customer_screen.dart';
import 'package:high_flyers_app/screens/driver/driver_screen.dart';
import 'package:high_flyers_app/screens/login_screen.dart';
import 'package:high_flyers_app/screens/splash_screen.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

//This will run on cold starts.

class AuthBootstrap extends StatefulWidget {
  const AuthBootstrap({super.key});

  @override
  State<AuthBootstrap> createState() => _AuthBootstrapState();
}

class _AuthBootstrapState extends State<AuthBootstrap> {

  User? currentUser;
  String? userRole;
  bool loading = true;
  StreamSubscription<User?>? authListener;

  @override
  void initState() {
    super.initState();

    authListener = FirebaseAuth.instance.authStateChanges().listen((user) async {

      if (!mounted) return;

      if (user == null) {
        setState(() {
          currentUser = null;
          userRole = null;
          loading = false;
        });
        return;
      }

      if(mounted){
        setState(() {
          loading = true;
        });
      }

      try {

        final token = await user.getIdTokenResult(); // no force refresh
        final role = token.claims?['role'] as String?;

        if(mounted){ 
          setState(() {
            currentUser = user;
            userRole = role;
            loading = false;
          });
        }

      } catch (error, stack) {
        
        await Sentry.captureException(
          error,
          stackTrace: stack,
          withScope: (scope) {
            scope.setContexts('auth_bootstrap_error', {
              'module': 'get_id_token_result_error',
              'details': error.toString(),
            });
          },
        );

        if(mounted){
          setState(() {
            currentUser = null;
            userRole = null;
            loading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    authListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const SplashScreen(key: ValueKey('loading'));
    }

    if (currentUser == null) {
      return const LoginScreen(key: ValueKey('login'));
    }

    switch (userRole) {
      case 'driver':
        return const DriverScreen(key: ValueKey('driver'));
      case 'customer':
        return const CustomerScreen(key: ValueKey('customer'));
      case 'admin':
        return const AdminScreen(key: ValueKey('admin'));
      case 'staff':
        return const AdminScreen(key: ValueKey('admin'));
      default:
        return const LoginScreen(key: ValueKey('login-default'));
    }

  }


}

