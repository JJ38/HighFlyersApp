import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore, DocumentSnapshot;
import 'package:firebase_core/firebase_core.dart';

class RunModel {

  RunModel();

  Future<bool> fetchStopsForRun(Map<String, dynamic> runData) async {

    final stops = runData['stops'];

    List<Future<DocumentSnapshot<Map<String, dynamic>>>> orderFutures = []; 

    for(var i = 0; i < stops.length; i++){
      orderFutures.add(fetchOrder(stops[i]['orderID']));
    }

    // orderFutures.add(fetchOrder('bad id'));

    late dynamic orders;

    try{
      
      orders = await Future.wait(orderFutures, eagerError: true);

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

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