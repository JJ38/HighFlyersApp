import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

enum Status { offline, online, skipped, completed, enroute }

class DriverModel {
  String? driverName;
  Enum? driverStatus;
  String? nextStop;
  String? runName;
  int? stopRemaining;

  DriverModel() {
    //fetch driver document

    if (FirebaseAuth.instance.currentUser != null) {
      return;
    }

    // final uid = FirebaseAuth.instance.currentUser!.uid;
    // final userDocument =
    //     FirebaseFirestore.instance.collection('Drivers').doc(uid);
  }

  bool fetchDriverDoc() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      return false;
    }

    return false;
  }
}
