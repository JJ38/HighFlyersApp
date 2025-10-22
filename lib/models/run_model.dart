import 'package:cloud_firestore/cloud_firestore.dart' show CollectionReference, DocumentReference, DocumentSnapshot, FirebaseFirestore, FieldValue;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:high_flyers_app/components/marker_label.dart';
import 'package:high_flyers_app/models/firebase_model.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';


class RunModel {

  Map<String, dynamic>? run; 
  String? runID;
  String? progressedRunID;
  String? shipmentName;
  dynamic orders;
  Key scaffoldKey = UniqueKey();
  Set<Marker> markers = {};
  bool isStartingRun = false;
  bool runStarted = false;


  RunModel();

  void setRun(run){
    this.run = run;
  }

  void setRunID(runID){
    this.runID = runID;
  }

  Map<String, dynamic>? getRun(){
    return run;
  }

  Future<bool> getStopsForRun() async{

    final fetchedStopsSuccessfully = await fetchOrdersForRun();

    if(!fetchedStopsSuccessfully){
      print('error fetching stops');
      return false;
    }

    final mergedStopsSuccessfully = mergeStopsAndRun();

    if(!mergedStopsSuccessfully){
      print('error merging stop and order data');
      return false;
    } 
    
    return true;
  }

  Future<bool> getMarkerForStop(Map<String, dynamic> stopData) async{

    markers = {};

    markers.add(
      Marker(
        markerId: MarkerId(stopData['orderID'] + "_" + stopData['stopType']),
        position: LatLng(stopData['coordinates']['lat'],stopData['coordinates']['lng']),
        icon: await customMarker(stopData['stopNumber'].toString()),
      )
    );
    
    print(markers);

    return true;

  }

  Future<bool> getMarkersForRun() async {

    if(run!['stops'].isEmpty){
      return false;
    }

    List<Future<BitmapDescriptor>> customMarkers = [];

    for(var i = 0; i < run!['stops'].length; i++){

      customMarkers.add(customMarker(run!['stops'][i]['stopNumber'].toString()));

    }

    for(var i = 0; i < customMarkers.length; i++){

      markers.add(
        Marker(
          markerId: MarkerId(run!['stops'][i]['orderID'] + "_" + run!['stops'][i]['stopType']),
          position: LatLng(run!['stops'][i]['coordinates']['lat'], run!['stops'][i]['coordinates']['lng']),
          icon: await customMarkers[i],
        )
      );

    }

    return true;

  }

  String getNumberOfStops(){

    return run!['stops'].length.toString();

  }

  String getEstimatedRunTime(){

    final trimmedRunTimeSeconds = run!['runTime'].replaceAll("s", "");

    final timeSeconds = int.parse(trimmedRunTimeSeconds)/60;

    final timeMinutes = (timeSeconds / 60).floor();

    final numberOfHours = timeMinutes.floor();
    final numberOfRemainingMinutes = timeMinutes % 60;

    return "${numberOfHours}h ${numberOfRemainingMinutes}m";
  }

  Future<BitmapDescriptor> customMarker(String label) async {
    return await MarkerLabel(label: label).toBitmapDescriptor(
      logicalSize: Size(50, 50),
      imageSize: Size(150, 150),
    );
  }

  Future<bool> fetchOrdersForRun() async {

    final stops = run!['stops'];

    List<Future<DocumentSnapshot<Map<String, dynamic>>>> orderFutures = []; 

    for(var i = 0; i < stops.length; i++){
      orderFutures.add(fetchOrder(stops[i]['orderID']));
    }

    try{
      
      orders = await Future.wait(orderFutures, eagerError: true);

    }catch(error, stack){

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('fetch_run_orders_error', {
            'module': 'driver_run',
            'details': error.toString(),
          });
        },
      );

      print(error);
      
      return false;
    }

    return true;

  }


  Future<DocumentSnapshot<Map<String, dynamic>>> fetchOrder(id) async {
    
    try{

      final databaseName = dotenv.env['DATABASE_NAME'];

      if(databaseName == null){
        print("databaseName == null");
        throw Error();
      }

      final db = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName);
      final orderDocRef = db.collection('Orders').doc(id);

    
      final orderDoc = await orderDocRef.get();

      if(orderDoc.data() == null){
        throw Error();
      }

      return orderDoc;

    }catch(error, stack){

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('fetch_order_error', {
            'module': 'driver_run',
            'details': error.toString(),
          });
        },
      );


      return Future.error(error);

    } 

  }

  bool mergeStopsAndRun(){

    final stops = run!['stops'];

    for(var i = 0; i < stops.length; i++){

      if(!findStopData(stops[i])){
        return false;
      }

    }

    return true;

  }

  bool findStopData(stop){

    final stopID = stop['orderID'];

    for(var i = 0; i < orders.length; i++){

      if(orders[i].id == stopID){
        
        stop['stopData'] = getStopData(stop['stopType'], orders[i]);

        if(stop['stopData'] == null){

        }

        return true;
      }

    }
    return false;

  }

  Map<String, dynamic> getStopData(stopType, order){

    final stopData = <String, dynamic>{};

    stopData['animalType'] = order['animalType'];
    stopData['quantity'] = order['quantity'];
    stopData['ID'] = order['ID'];

    if(stopType == "collection"){

      stopData['name'] = order['collectionName'];
      stopData['address1'] = order['collectionAddress1'];
      stopData['address2'] = order['collectionAddress2'];
      stopData['address3'] = order['collectionAddress3'];
      stopData['postcode'] = order['collectionPostcode'];
      stopData['phoneNumber'] = order['collectionPhoneNumber'];
      stopData['payment'] = order['payment'] == 'collection' ? true : false; 

    }else if(stopType == 'delivery'){
      
      stopData['name'] = order['deliveryName'];
      stopData['address1'] = order['deliveryAddress1'];
      stopData['address2'] = order['deliveryAddress2'];
      stopData['address3'] = order['deliveryAddress3'];
      stopData['postcode'] = order['deliveryPostcode'];
      stopData['phoneNumber'] = order['deliveryPhoneNumber'];
      stopData['payment'] = order['payment'] == 'delivery' ? true : false; 

    }

    return stopData;

  }

  Future<bool> startRun() async {

    late final User? currentUser;

    try {
      
      final FirebaseAuth auth = FirebaseAuth.instance;
      currentUser = auth.currentUser;
      
      if (currentUser == null) {
        Sentry.logger.info("Failed start run - user null");
        return false;
      }

      final databaseName = dotenv.env['DATABASE_NAME'];

      if(databaseName == null){
        return false;
      }

      DocumentReference driverDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName)
          .collection('Drivers')
          .doc(currentUser.uid);

      final driverDoc = await driverDocRef.get();

      if(!driverDoc.exists){
        Sentry.logger.info("Failed start run - Driver doc doesnt exist");
        FirebaseCrashlytics.instance.log('Driver doc doesnt exist');
        return false;
      }

      if(driverDoc.data() == null){
        Sentry.logger.info("Failed start run - Driver doc data is null");
        return false;
      } 

      final Map<String, dynamic> driverData = driverDoc.data() as Map<String, dynamic>;

      //copies value of run['stops]
      final List<dynamic> newStopsCopy = [...run!['stops']];

      newStopsCopy.sort((a, b) => a['stopNumber'].compareTo(b['stopNumber']));

      //fetch all foreign key data to be stored in new document now run is about to be underway to stop issues with orders not being fetch and bad signal.
      
      List<DocumentReference<Map<String, dynamic>>> documentReferences = [];

      for(var i = 0; i < newStopsCopy.length; i++){

        DocumentReference<Map<String, dynamic>> orderDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Orders').doc(newStopsCopy[i]['orderID']);
        documentReferences.add(orderDocRef);

      }

      List<dynamic> orderDocuments =  await FirebaseModel.fetchMultipleDocuments(documentReferences);

      //merge stop and order data
      for(var i = 0; i < orderDocuments.length; i++){
        
        if(!mergeStopAndOrder(newStopsCopy, orderDocuments[i])){
          FirebaseCrashlytics.instance.log('Failed to stop and order');
          return false;
        }

      }

      Map<String, dynamic> progressedRunDocument = {
        'driverID': driverDocRef.id,
        'runName': run!['runName'],
        'runTime': run!['runTime'],
        'runStatus': 'In Progress',
        'optimisedRun': run!['optimisedRoute'],
        'currentStopNumber': 1,
        'stops': newStopsCopy,
      };

      //add document to progress documents collection and add progressed doc ref to assigned runs in driver doc

      CollectionReference progressedRunCollectionRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('ProgressedRuns');
      
      DocumentReference progressedRunDocRef = progressedRunCollectionRef.doc();

      final newAssignedRuns = [...driverData['assignedRuns']];

      for(var i = 0; i < newAssignedRuns.length; i++){

        if(newAssignedRuns[i]['runID'] == runID){
          newAssignedRuns.removeAt(i);
          break;
        }

      }


      //if progressed runs is empty or undefined
      List<dynamic>? newProgressedRuns = [...driverData['progressedRuns'] ?? []];

      newProgressedRuns.add({
        "progressedRunID": progressedRunDocRef.id,
        "runName": run!['runName'],
        "shipmentName": shipmentName
      });


      await FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).runTransaction((transaction) async {

        final driverDoc = await transaction.get(driverDocRef);

        if (!driverDoc.exists) {
          FirebaseCrashlytics.instance.log('Driver doc doesnt exist - transaction');
          return false;
        }

        transaction.set(progressedRunDocRef, progressedRunDocument);

        transaction.update(driverDocRef, {
          'assignedRuns': newAssignedRuns,
          'progressedRuns': newProgressedRuns,
          'driverStatus': "Online",
          'updated_at': FieldValue.serverTimestamp(), // Optional: use a server timestamp
        });

      });

      progressedRunID = progressedRunDocRef.id;
      run!['currentStopNumber'] = 1;

    } catch (error, stack) {

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('start_run_error', {
            'module': 'driver_run',
            'details': error.toString(),
          });
        },
      );

      print("Error updating document: $error");
      return false;

    }

    Sentry.logger.fmt.info("%s Started run %s", [currentUser.email?.replaceAll("@placeholder.com", ""), run?['runName']]);

    return true;

  }

  bool mergeStopAndOrder(stops, order){

    for(var i = 0; i < stops.length; i++){

      if(stops[i]['orderID'] == order.id){

        stops[i]['orderData'] = order.data();
        stops[i]['stopStatus'] = "Pending";
        return true;

      }

    }

    return false;

  }

  dynamic getStopByStopNumber(int stopNumber){

    for(int i = 0; i < run!['stops'].length; i++){

      if(stopNumber == run!['stops'][i]['stopNumber']){
        return run!['stops'][i];
      }

    }

    return false;

  }


}





