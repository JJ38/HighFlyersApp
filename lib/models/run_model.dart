import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, DocumentSnapshot;
import 'package:firebase_core/firebase_core.dart';

class RunModel {

  Map<String, dynamic>? run; 
  dynamic orders;


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

    print(run!['stops']);
    
    return true;
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

}



