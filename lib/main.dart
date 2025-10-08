import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'screens/login_screen.dart';
import 'screens/driver/driver_screen.dart';
import 'screens/customer/customer_screen.dart';
import 'screens/admin/admin_screen.dart';

void main() async {
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp, // Normal Portrait
  // ]);

  // Require Hybrid Composition mode on Android.
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    // Force Hybrid Composition mode.
    mapsImplementation.useAndroidViewSurface = true;
  }

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };


  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };


  String envFile = ".env.development";

  if (kReleaseMode) {
    envFile = ".env.production";
  }

  await dotenv.load(fileName: envFile);

  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   
    return StyledToast(
      locale: const Locale('en', 'UK'), // Set your app's locale
      duration: const Duration(seconds: 3),
      animDuration: const Duration(milliseconds: 10),
      toastPositions: StyledToastPosition.top,
      toastAnimation: StyledToastAnimation.slideFromRight,
      reverseAnimation: StyledToastAnimation.fade,
      child: MaterialApp(
        title: 'High Flyers App',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white, secondary: Color(0xFF2881FF),
            error: Colors.red[700]!,
            errorContainer: Colors.red[300]!
          ),
          useMaterial3: true,
          textTheme: TextTheme(
            titleLarge: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                overflow: TextOverflow.ellipsis),
            titleMedium: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              overflow: TextOverflow.ellipsis),
            titleSmall: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis),
            labelLarge: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2881FF),
                overflow: TextOverflow.ellipsis),
            labelMedium: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 77, 77, 77),
                overflow: TextOverflow.ellipsis),
            labelSmall: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 126, 126, 126),
                overflow: TextOverflow.ellipsis),
          ),
        ),
        initialRoute: LoginScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          DriverScreen.id: (context) => DriverScreen(),
          CustomerScreen.id: (context) => CustomerScreen(),
          AdminScreen.id: (context) => AdminScreen(),
        },
      )
    );
  }
}
