import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:high_flyers_app/models/firebase_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Status { offline, online, skipped, completed, enroute }

class DriverModel {

  bool isLoading = true;
  bool driverLoadedSuccessfully = false;
  late Map<String, dynamic> driverDoc;
  List<Map<String, dynamic>> driverRuns = [];
  List<bool> runStatuses = [];
  late List driverRunDocs = [];


  DriverModel();

  Future<bool> initialiseDriver() async {

    print("fetching driver doc");


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
    final progressedRuns = driverDoc['progressedRuns'];

    final databaseName = dotenv.env['DATABASE_NAME'];

    if(databaseName == null){
      return false;
    }


    List<DocumentReference<Map<String, dynamic>>> documentReferences = [];
    runStatuses = [];

    for (var i = 0; i < assignedRuns.length; i++) {

      DocumentReference<Map<String, dynamic>> driverDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Runs').doc(assignedRuns[i]['runID']);
      documentReferences.add(driverDocRef);
      runStatuses.add(false);

    }

    if(progressedRuns != null){

      for (var i = 0; i < progressedRuns.length; i++) {

        DocumentReference<Map<String, dynamic>> progressedRunDoc = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('ProgressedRuns').doc(progressedRuns[i]['progressedRunID']);
        documentReferences.add(progressedRunDoc);
        runStatuses.add(true);

      }

    }

    print(documentReferences);

    try{

      driverRunDocs = await FirebaseModel.fetchMultipleDocuments(documentReferences);
      print(driverRunDocs);

      print("fetched driver run documents");

    }catch(e){

      print("Error fetching run documents");
      return false;

    }

    return true;
  }

  Future<bool> fetchDriverDoc() async {

    final databaseName = dotenv.env['DATABASE_NAME'];

    if(databaseName == null){
      return false;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference<Map<String, dynamic>> driverDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Drivers').doc(uid);

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

}
