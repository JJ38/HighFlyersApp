import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:high_flyers_app/models/firebase_model.dart';

enum Status { offline, online, skipped, completed, enroute }

class DriverModel {
  String? driverName;
  Enum? driverStatus;
  String? nextStop;
  String? runName;
  int? stopRemaining;
  late Map<String, dynamic> driverDoc;
  late List driverRunDocs = [];


  DriverModel();

  Future<bool> initialiseDriver() async {

    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }

    final successful = await fetchDriverDoc();

    if (!successful) {
      return false;
    }

    return true;
  }

  Future<bool> fetchDriverRuns() async {

    final assignedRuns = driverDoc['assignedRuns'];

    List<DocumentReference<Map<String, dynamic>>> documentReferences = [];

    for (var i = 0; i < assignedRuns.length; i++) {

      DocumentReference<Map<String, dynamic>> driverDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "development").collection('Runs').doc(assignedRuns[i]['runID']);
      documentReferences.add(driverDocRef);

    }

    try{

      driverRunDocs = await FirebaseModel.fetchMultipleDocuments(documentReferences);

    }catch(e){

      print("Error fetching run documents");
      return false;

    }

    return true;
  }

  Future<bool> fetchDriverDoc() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference<Map<String, dynamic>> driverDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "development").collection('Drivers').doc(uid);

    try {

      final response = await driverDocRef.get();

      if (response.data() == null) {
        return false;
      }

      driverDoc = response.data()!;

    } catch (e) {

      return false;

    }

    return true;
  }

  // Stream<QuerySnapshot> getDriverRunsQuerySnapshot() {

  //   final Stream<QuerySnapshot> stream = FirebaseFirestore.instanceFor(
  //           app: Firebase.app(), databaseId: "development")
  //       .collection('Runs')
  //       .where("assignedDriver",
  //           isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .snapshots();

  //   return stream;
  // }
}
