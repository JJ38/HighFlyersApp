import 'dart:convert';
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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';


@pragma('vm:entry-point')
class DriverScreenModel {

  static const String _isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  @pragma('vm:entry-point')
  static void callback(LocationDto locationDto) async {
    print("callback");
    final SendPort? send = IsolateNameServer.lookupPortByName(_isolateName);

    try{

      send?.send(jsonEncode(locationDto));

    }catch(error, stack){
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

    }catch(error, stack){
      print(error);
    }

  }


  Future<bool> initialiseLocationTracking() async{
    

    PermissionStatus status = await Permission.location.status;

    if (status.isDenied) {
      //ask for permission if on android
      status = await Permission.location.request();
    }

    print("premission status selected: ${status.toString()}");

    if (status.isPermanentlyDenied) {
      await openAppSettings(); // let user fix it manually
      return false;
    }

    if (!status.isGranted) {
      return false;
    }


    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    port.listen((dynamic driverLocationData) {

      print(driverLocationData);
      if(driverLocationData == null){
        return;
      }

      try{

        final Map<String, dynamic> driverLocationDataMap = jsonDecode(driverLocationData);
        updateDriverLocation(driverLocationDataMap);

      }catch(error, stack){
        print(error);
      }
      

    });

    try{
      print("attempting location tracking");


      BackgroundLocator.registerLocationUpdate(
        callback,
        initCallback: initCallback,
        // initDataCallback: data,
        disposeCallback: disposeCallback,
        autoStop: false,
        iosSettings: IOSSettings(
          accuracy: LocationAccuracy.NAVIGATION, 
          distanceFilter: 30,
          showsBackgroundLocationIndicator: true
        ),
        androidSettings: AndroidSettings(
          accuracy: LocationAccuracy.NAVIGATION,
          interval: 60,
          distanceFilter: 0,
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
      print(error);
      print(stack);

      return false;
    }

    return true;

  }

}