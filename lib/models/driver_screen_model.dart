import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';


@pragma('vm:entry-point')
class DriverScreenModel {

  static const String _isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();
  BuildContext? driverScreenContext;

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  @pragma('vm:entry-point')
  static void callback(LocationDto locationDto) async {

    final SendPort? send = IsolateNameServer.lookupPortByName(_isolateName);

    try{

      send?.send(jsonEncode(locationDto));

    }catch(error){
      print(error);
    }

  }

  @pragma('vm:entry-point')
  static void initCallback(dynamic _) {
      print('Plugin initialization');
  }

  @pragma('vm:entry-point')
  static void notificationCallback() {
      print('User clicked on the notification');
  }

  @pragma('vm:entry-point')
  static void disposeCallback() {
    print('dispose location callback');
    IsolateNameServer.removePortNameMapping(_isolateName);
    BackgroundLocator.unRegisterLocationUpdate();
  }

  Future<void> updateDriverLocation(Map<String, dynamic> driverLocationData) async {

    try{

      final databaseName = dotenv.env['DATABASE_NAME'];

      if(databaseName == null){
        return;
      }

      final uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference<Map<String, dynamic>> driverDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Drivers').doc(uid);

      driverDocRef.update(
        {
          "location": driverLocationData
        }
      );

    }catch(error){
      print(error);
    }

  }

  Future<bool> showBackgroundExplanationDialog() async {

    if(driverScreenContext == null){
      print("context was null");
      return false;
    }

    return await showDialog<bool>(
      context: driverScreenContext!,
      builder: (context) {
        return AlertDialog(
          title: Text("Background Location Needed"),
          content: Text(
            "To track your location even when the app is closed, "
            "we need background location access."
          ),
          actions: [
            TextButton(
              child: Text("No thanks"),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text("Continue"),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    ) ?? false;
  }



  Future<bool> initialiseLocationTracking() async{

    // if(Platform.isIOS){

    // PermissionStatus batteryOptimisationStatus = await Permission.ignoreBatteryOptimizations.status;
    // print("Battery optimization ignored: $batteryOptimisationStatus");

    // if(batteryOptimisationStatus.isDenied){
    //   print("batteryOptimisationStatus.isDenied asking for permission");
    //   batteryOptimisationStatus = await Permission.ignoreBatteryOptimizations.request();
    // }

    // if(!batteryOptimisationStatus.isGranted){
    //   print("battery in optimised mode so cant access background location");
    //   return false;
    // }


    PermissionStatus foregroundStatus = await Permission.locationWhenInUse.status;

    print(foregroundStatus);

    if (foregroundStatus.isDenied){
      Sentry.logger.fmt.info("Requesting foreground location permissions for %s", [FirebaseAuth.instance.currentUser?.email]);
      foregroundStatus = await Permission.locationWhenInUse.request();
    }

    if (foregroundStatus.isPermanentlyDenied){
      Sentry.logger.fmt.info("Foreground location permissions for %s are permanently denied", [FirebaseAuth.instance.currentUser?.email]);
      await openAppSettings();
      return false;
    }

    if(!foregroundStatus.isGranted){
      Sentry.logger.fmt.info("Foreground location permissions are not granted for %s", [FirebaseAuth.instance.currentUser?.email]);
      return false;
    }

    // final bool userAgreed = await showBackgroundExplanationDialog();


    // 2. Request background (always)
    PermissionStatus alwaysStatus = await Permission.locationAlways.status;

    if (alwaysStatus.isDenied) {
      Sentry.logger.fmt.info("Requesting background location permissions for %s", [FirebaseAuth.instance.currentUser?.email]);
      alwaysStatus = await Permission.locationAlways.request();
    }

    if (alwaysStatus.isPermanentlyDenied) {
      Sentry.logger.fmt.info("Background location permissions for %s are permanently denied", [FirebaseAuth.instance.currentUser?.email]);
      await openAppSettings();
      return false;
    }

    if (!alwaysStatus.isGranted) {
      Sentry.logger.fmt.info("Background location permissions are not granted for %s", [FirebaseAuth.instance.currentUser?.email]);
      return false;
    }

    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);

    port.listen((dynamic driverLocationData) async {

      if(driverLocationData == null){
        return;
      }

      try{

        final Map<String, dynamic> driverLocationDataMap = jsonDecode(driverLocationData);
        updateDriverLocation(driverLocationDataMap);

      }catch(error, stack){

        await Sentry.captureException(
          error,
          stackTrace: stack,
          withScope: (scope) {
            scope.setContexts('driver_location_permissions', {
              'module': 'port_listener',
              'details': error.toString(),
            });
          },
        );

      }
      
    });

    try{

      BackgroundLocator.registerLocationUpdate(
        callback,
        initCallback: initCallback,
        // initDataCallback: data,
        disposeCallback: disposeCallback,
        autoStop: false,
        iosSettings: IOSSettings(
          accuracy: LocationAccuracy.NAVIGATION, 
          distanceFilter: 300,
          showsBackgroundLocationIndicator: true
        ),
        androidSettings: AndroidSettings(
          accuracy: LocationAccuracy.NAVIGATION,
          interval: 30,
          distanceFilter: 300,
          androidNotificationSettings: AndroidNotificationSettings(
            notificationChannelName: 'Location tracking',
            notificationTitle: 'Start Location Tracking',
            notificationMsg: 'Track location in background',
            notificationBigMsg:
                'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
            notificationIcon: '',
            notificationIconColor: Color(0xffffffff),
            notificationTapCallback: notificationCallback
          )
        )
      );


    }catch(error, stack){

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('driver_location_permissions', {
            'module': 'location_register',
            'details': error.toString(),
          });
        },
      );

      return false;
    }

    return true;

  }

}