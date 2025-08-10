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
  DocumentReference<Map<String, dynamic>>? driverDoc;

  DriverModel();

  bool initialiseDriver() {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }

    fetchDriverDoc();

    return true;
  }

  bool fetchDriverDoc() {
    final currentUser = FirebaseAuth.instance.currentUser;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    driverDoc = FirebaseFirestore.instanceFor(
            app: Firebase.app(), databaseId: "development")
        .collection('Drivers')
        .doc(uid);

    if (currentUser != null) {
      return false;
    }

    return false;
  }

  Stream<QuerySnapshot> getDriverRunsQuerySnapshot() {
    print(FirebaseAuth.instance.currentUser!.uid);

    final Stream<QuerySnapshot> stream = FirebaseFirestore.instanceFor(
            app: Firebase.app(), databaseId: "development")
        .collection('Runs')
        .where("assignedDriver",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return stream;
  }
}
