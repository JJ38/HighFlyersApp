import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/firebase_model.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AdminLabelRunsScreenModel {
  
  List<Map<String, dynamic>> assignedRuns = [];
  late Map<String, dynamic> staffDoc;
  late List staffRunDocs = [];
  bool isLoaded = false;
  bool initialisedStaffMember = false;

  Future<bool> initialiseStaffMember() async{

    final fetchedStaffDocumentSuccessfully = await fetchStaffDocument();

    if(!fetchedStaffDocumentSuccessfully){
      return false;
    }

    final fetchedAssignedRunsSuccessfully = await fetchAssignedRuns();

    if(!fetchedAssignedRunsSuccessfully){
      return false;
    }

    assignedRuns = [];

    print("staffRunDocs: $staffRunDocs");

    for(int i = 0; i < staffRunDocs.length; i++){

      Map<String, dynamic> assignedRun = {};
      
      if(staffRunDocs[i].exists){

        assignedRun = staffRunDocs[i].data() ?? <String, dynamic>{};

      }else{
        print("$i doesnt exist");
        assignedRun = <String, dynamic>{};
      }

      assignedRuns.add(assignedRun);
      print(staffRunDocs[i]);

    }

    print(assignedRuns);

    return true;

  }

  Future<bool> fetchStaffDocument() async {

    final databaseName = dotenv.env['DATABASE_NAME'];

    if(databaseName == null){
      return false;
    }

    if(FirebaseAuth.instance.currentUser == null){
      return false;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference<Map<String, dynamic>> staffDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Staff').doc(uid);

    try {

      final response = await staffDocRef.get();

      if (response.data() == null) {
        return false;
      }

      staffDoc = response.data()!;

      print("staffDoc: $staffDoc");

    } catch (error, stack) {

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('fetch_staff_doc_error', {
            'module': 'label_runs',
            'details': error.toString(),
          });
        },
      );

      print(error);

      return false;

    }

    return true;
  }

  Future<bool> fetchAssignedRuns() async{

    final assignedRuns = staffDoc['assignedRuns'];

    print("assignedRuns: $assignedRuns");

    final databaseName = dotenv.env['DATABASE_NAME'];

    if(databaseName == null){
      return false;
    }


    List<DocumentReference<Map<String, dynamic>>> documentReferences = [];

    for (var i = 0; i < assignedRuns.length; i++) {

      DocumentReference<Map<String, dynamic>> staffDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Runs').doc(assignedRuns[i]['runID']);
      documentReferences.add(staffDocRef);

    }

    print("documentReferences: $documentReferences");


    try{

      staffRunDocs = await FirebaseModel.fetchMultipleDocuments(documentReferences);

    }catch(error, stack){

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('fetch_staff_runs_error', {
            'module': 'label_runs',
            'details': error.toString(),
          });
        },
      );

      print(error);
      return false;

    }

    return true;

  }


}