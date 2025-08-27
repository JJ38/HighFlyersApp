import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, DocumentSnapshot, DocumentReference;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:high_flyers_app/components/marker_label.dart';
import 'package:widget_to_marker/widget_to_marker.dart';


class RunModel {

  Map<String, dynamic>? run; 
  dynamic orders;
  Key scaffoldKey = UniqueKey();
  Set<Marker> markers = {};


  RunModel();

  void setRun(run){
    this.run = run;
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

  Future<bool> getMarkerForRun() async {

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

    // orderFutures.add(fetchOrder('bad id'));

    try{
      
      orders = await Future.wait(orderFutures, eagerError: true);

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchOrder(id) async {

    final db = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "development");
    final orderDocRef = db.collection('Orders').doc(id);

    try{
      final orderDoc = await orderDocRef.get();

      if(orderDoc.data() == null){
        throw Error();
      }

      return orderDoc;

    }catch(e){
      print(e.toString());
      print("error fetching order");

      return Future.error(e);

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

      stopData['address1'] = order['collectionAddress1'];
      stopData['address2'] = order['collectionAddress2'];
      stopData['address3'] = order['collectionAddress3'];
      stopData['postcode'] = order['collectionPostcode'];
      stopData['phoneNumber'] = order['collectionPhoneNumber'];
      stopData['payment'] = order['payment'] == 'collection' ? true : false; 

    }else if(stopType == 'delivery'){
      
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

    try {
      
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? currentUser = auth.currentUser;
      
      if (currentUser == null) {
        return false;
      }

      DocumentReference driverDocument = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "development")
          .collection('Drivers')
          .doc(currentUser.uid);

      final driverDoc = await driverDocument.get();

      return false;

      if(!driverDoc.exists){
        return false;
      }

      if(driverDoc.data() == null){
        return false;
      } 

      final Map<String, dynamic> driverData = driverDoc.data() as Map<String, dynamic>;

      //copies value of run['stops]
      final List<dynamic> newRunCopy = [...run!['stops']];

      //fetch all foreign key data to be stored in new document now run is about to be underway to stop issues with orders not being fetch and bad signal.
      

      for(var i = 0; i < newRunCopy.length; i++){

        print(newRunCopy[i]);

      }

      // await userDocument.update({
      //   'driverStatus': "Online",
      //   'updated_at': FieldValue.serverTimestamp(), // Optional: use a server timestamp
      // });
      
     
    } catch (e) {
      print("Error updating document: $e");
      return false;
    }

    return true;

  }

}





