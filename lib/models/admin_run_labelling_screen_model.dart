import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/firebase_model.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AdminRunLabellingScreenModel {

  final String runDocID;
  Map<String, dynamic>? runData;
  List<dynamic> orderDocuments = [];
  bool successfullyInitialisedPage = false;

  AdminRunLabellingScreenModel({required this.runDocID});
  
  Future<bool> initialisePage() async {

    successfullyInitialisedPage = false;

    final succcessfullyFetchedRunDocument = await fetchRunDocument();

    if(!succcessfullyFetchedRunDocument){
      print("!succcessfullyFetchedRunDocument");
      return false;
    }

    final succcessfullyFetchedOrderDocuments = await fetchOrderDocuments();

    if(!succcessfullyFetchedOrderDocuments){
      print("!succcessfullyFetchedOrderDocuments");
      return false;
    }

    final succcessfullyMergedStopsAndOrders = mergeStopsAndOrders();

    if(!succcessfullyMergedStopsAndOrders){
      print("!succcessfullyMergedStopsAndOrders");
      return false;
    }

    successfullyInitialisedPage = true;
    orderStopsByStopNumber();

    return true;

  }

  bool mergeStopsAndOrders(){
    
    final stops = runData!['stops'];

    for(int i = 0; i < stops.length; i++){

      final orderID = stops[i]['orderID'];
      bool foundStop = false;

      for(int j = 0; j < orderDocuments.length; j++){

        if(orderID == orderDocuments[j].id){

          stops[i]['orderData'] = orderDocuments[j].data();
          foundStop = true;
          break;

        }

      }

      if(!foundStop){
        return false;
      }

    }



    return true;

  }


  Future<bool> fetchRunDocument() async {

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

    return true;

  }

  
  Future<bool> fetchOrderDocuments() async {

    print("fetchOrderDocuments");

    final databaseName = dotenv.env['DATABASE_NAME'];

    if(databaseName == null){
      return false;
    }

    try {

      final stops = runData!['stops'];

      print(stops);

      List<DocumentReference<Map<String, dynamic>>> orderDocReferences = [];

      for(int i = 0; i < stops.length; i++){

        print("loop");

        if(stops[i]['orderID'] != null){

          DocumentReference<Map<String, dynamic>> orderDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Orders').doc(stops[i]['orderID']);
          orderDocReferences.add(orderDocRef);

        }else{
          throw Exception("orderID not given");
        }

      }

      print("fetchingOrders");

      //will throw exception if any documents fail to be fetched
      orderDocuments = await FirebaseModel.fetchMultipleDocuments(orderDocReferences);

    } catch (error, stack) {

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('fetch_order_docs_error', {
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


  void orderStopsByID(){

    (runData?['stops'] as List).sort((a, b) => (a['orderData']?['ID'] as int).compareTo(b['orderData']?['ID'] as int));

  }

  void orderStopsByStopNumber(){

    (runData?['stops'] as List).sort((a, b) => (a['stopNumber'] as int).compareTo(b['stopNumber'] as int));

  }

}