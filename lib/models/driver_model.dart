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
  DocumentSnapshot<Map<String, dynamic>>? driverDoc;

  DriverModel();

  Future<bool> initialiseDriver() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }

    final successful = await fetchDriverDoc();

    if(!successful){
      return false;
    } 

    return true;
  }

  Future<bool> fetchDriverDoc() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference<Map<String, dynamic>> driverDocRef = FirebaseFirestore.instanceFor(
            app: Firebase.app(), databaseId: "development")
        .collection('Drivers')
        .doc(uid);

    try{
      driverDoc = await driverDocRef.get();
    }catch(e){
      return false;
    }

    return true;
  }

  Stream<QuerySnapshot> getDriverRunsQuerySnapshot() {

    final Stream<QuerySnapshot> stream = FirebaseFirestore.instanceFor(
            app: Firebase.app(), databaseId: "development")
        .collection('Runs')
        .where("assignedDriver",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return stream;
  }
}
