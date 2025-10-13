import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class AdminManageOrdersScreenModel{

  Stream<QuerySnapshot>? orderListener;
  StreamSubscription<QuerySnapshot<Object?>>? orderSubscription;
  Query<Map<String, dynamic>>? baseQuery;
  List<dynamic> orders = [];
  Map<String, dynamic> filterFields = {
    "ID": {"fieldValue": "ID", "keyboardType": TextInputType.text},
    "Account": {"fieldValue": "account", "keyboardType": TextInputType.text},
    "Added By": {"fieldValue": "addedBy", "keyboardType": TextInputType.text},
    "Animal Type": {"fieldValue": "animalType", "keyboardType": TextInputType.text},
    "Boxes": {"fieldValue": "boxes", "keyboardType": TextInputType.number},
    "Code": {"fieldValue": "code", "keyboardType": TextInputType.text},
    "Collection Address 1": {"fieldValue": "collectionAddress1", "keyboardType": TextInputType.text},
    "Collection Address 2": {"fieldValue": "collectionAddress2", "keyboardType": TextInputType.text},
    "Collection Address 3": {"fieldValue": "collectionAddress3", "keyboardType": TextInputType.text},
    "Collection Name": {"fieldValue": "collectionName", "keyboardType": TextInputType.text},
    "Collection Phone Number": {"fieldValue": "collectionPhoneNumber", "keyboardType": TextInputType.number},
    "Collection Postcode": {"fieldValue": "collectionPostcode", "keyboardType": TextInputType.text},
    "Delivery Address 1": {"fieldValue": "deliveryAddress1", "keyboardType": TextInputType.text},
    "Delivery Address 2": {"fieldValue": "deliveryAddress2", "keyboardType": TextInputType.text},
    "Delivery Address 3": {"fieldValue": "deliveryAddress3", "keyboardType": TextInputType.text},
    "Delivery Name": {"fieldValue": "deliveryName", "keyboardType": TextInputType.text},
    "Delivery Phone Number": {"fieldValue": "deliveryPhoneNumber", "keyboardType": TextInputType.number},
    "Delivery Postcode": {"fieldValue": "deliveryPostcode", "keyboardType": TextInputType.text},
    "Delivery Week": {"fieldValue": "deliveryWeek", "keyboardType": TextInputType.number},
    "Email": {"fieldValue": "email", "keyboardType": TextInputType.emailAddress},
    "Payment": {"fieldValue": "payment", "keyboardType": TextInputType.text},
    "Price": {"fieldValue": "price", "keyboardType": TextInputType.number},
    "Quantity": {"fieldValue": "quantity", "keyboardType": TextInputType.number},
    "Timestamp": {"fieldValue": "timestamp", "keyboardType": TextInputType.text},
    "Username": {"fieldValue": "username", "keyboardType": TextInputType.text},

  };
  String? selectedFilterField;
  String? searchValue;
  int? latestOrderID;
  int? oldestOrderID;
  bool isShowingFilteredOrders = false;
  bool isLoadingOrders = false;
  bool isLoadingAdditionalOrders = false;
  bool showFilters = false;
  bool hasLoadedAllOrders = false;


  Future<bool> getInitialOrders() async {

    hasLoadedAllOrders = false;
    isShowingFilteredOrders = false;

    baseQuery = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: "development",
    )
    .collection('Orders')
    .orderBy('ID', descending: true)
    .limit(10);

    try{

      final initialOrders = await baseQuery!.get();

      latestOrderID = initialOrders.docs.first.get('ID');
      oldestOrderID = initialOrders.docs.last.get('ID');

      orders.insertAll(0, initialOrders.docs);

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

  Future<bool> getFilteredOrders() async {

    hasLoadedAllOrders = false;
    isShowingFilteredOrders = true;

    ;
    
    baseQuery = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: "development",
    )
    .collection('Orders')
    .orderBy('ID', descending: true)
    .where(selectedFilterField!, isEqualTo: getTypeCorrectSearchValue())
    .limit(10);

    try{

      final filteredOrders = await baseQuery!.get();

      oldestOrderID = filteredOrders.docs.last.get('ID');

      orders.insertAll(0, filteredOrders.docs);

      return true;

    }catch(e){

      print(e);
      return false; 

    }

  }

  dynamic getTypeCorrectSearchValue(){

    //based on selectedFilterField (database field name)
    List<String> integerSearchFields = ["ID", "deliveryWeek", "quantity", "boxes", "price"];

    if(integerSearchFields.contains(selectedFilterField)){
      return int.parse(searchValue!);
    }

    return searchValue!;

  }

  void initialiseNewOrderListener(updateState){

    cancelOrderSubscription();
    updateOrderListener();
    
    orderSubscription = orderListener!.listen((snapshot) {

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

  void cancelOrderSubscription(){

    if(orderSubscription != null){
      orderSubscription!.cancel();
      orderSubscription = null;
      print("Subscription Cancelled");
    }

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

    if(baseQuery == null){
      return false;
    }

    print("getAdditionalOrders");
    print(baseQuery);
    print("oldestOrderID: " + oldestOrderID.toString());


    final queryToAttempt = baseQuery!.where('ID', isLessThan: oldestOrderID);

    try{

      final additionalOrders = await queryToAttempt.get();

      if(additionalOrders.docs.isEmpty){
        print("Loaded all orders for query");
        hasLoadedAllOrders = true;
        return false;
      }

      oldestOrderID = additionalOrders.docs.last.get('ID');

      orders.addAll(additionalOrders.docs);

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

}