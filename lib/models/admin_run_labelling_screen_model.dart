import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AdminRunLabellingScreenModel {

  final String runDocID;
  Map<String, dynamic>? runData;
  bool successfullyFetchedRunDocument = false;

  AdminRunLabellingScreenModel({required this.runDocID});


  // initialiseLabellingScreen() async{
  //   fetchRunDocument();

  // }


  Future<bool> fetchRunDocument() async {

    successfullyFetchedRunDocument = false;

    final databaseName = dotenv.env['DATABASE_NAME'];

    if(databaseName == null){
      return false;
    }

    DocumentReference<Map<String, dynamic>> runDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Runs').doc(runDocID);

    try {

      final response = await runDocRef.get();

      if (response.data() == null) {
        return false;
      }

      runData = response.data()!;

    } catch (error, stack) {

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('fetch_run_doc_error', {
            'module': 'label_runs',
            'details': error.toString(),
          });
        },
      );

      print(error);

      return false;

    }

    successfullyFetchedRunDocument = true;
    return true;

  }

  void orderStopsByID(){

    (runData?['stops'] as List).sort((a, b) => (a['orderData']?['ID'] as int).compareTo(b['orderData']?['ID'] as int));

  }

}