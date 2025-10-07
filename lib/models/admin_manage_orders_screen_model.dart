import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AdminManageOrdersScreenModel{

  Stream<QuerySnapshot>? orderListener;
  List<dynamic> orders = [];
  int? latestOrderID;
  int? oldestOrderID;
  bool showFilterSettings = false;
  bool isLoadingInitialOrders = false;
  bool isLoadingAdditionalOrders = false;


  Future<bool> getInitialOrders() async {

    try{

      final initialOrders = await FirebaseFirestore.instanceFor(
        app: Firebase.app(),
        databaseId: "development",
      )
      .collection('Orders')
      .orderBy('ID', descending: true)
      .limit(10)
      .get();

      latestOrderID = initialOrders.docs.first.get('ID');
      oldestOrderID = initialOrders.docs.last.get('ID');

      orders.insertAll(0, initialOrders.docs);

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

  void initialiseNewOrderListener(updateState){

    updateOrderListener();
    
    orderListener!.listen((snapshot) {

      print("New order");

      for (var docChange in snapshot.docChanges) {

        if (docChange.type == DocumentChangeType.added) {
          final newDoc = docChange.doc;
          orders.insert(0, newDoc);
        }

      }

      // Update your latestID tracker
      if (snapshot.docs.isNotEmpty) {
        final newest = snapshot.docs.last;
        latestOrderID = newest.get('ID');
      }

      updateState();

    }, onError: (error) {print("Listener error: $error");});


  }

  void updateOrderListener() {

    print(latestOrderID);

    orderListener = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: "development",
    ).collection('Orders')
    .where('ID', isGreaterThan: latestOrderID)
    .orderBy('ID', descending: false) // ascending to get oldest-newest
    .snapshots();

  }

  //called when the user has scrolled down - pagination
  Future<bool> getAdditionalOrders() async {

    try{

      final initialOrders = await FirebaseFirestore.instanceFor(
        app: Firebase.app(),
        databaseId: "development",
      )
      .collection('Orders')
      .where('ID', isLessThan: oldestOrderID)
      .orderBy('ID', descending: true)
      .limit(10)
      .get();

      oldestOrderID = initialOrders.docs.last.get('ID');
      print(oldestOrderID);

      orders.addAll(initialOrders.docs);

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

}