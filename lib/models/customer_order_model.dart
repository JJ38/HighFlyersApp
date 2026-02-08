import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/customer_order_request.dart';
import 'package:high_flyers_app/models/order_model_abstract.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CustomerOrderModel extends OrderModel{

  final Uuid uuid = Uuid();
  List<dynamic> basket = [];
  bool showCollectionDetails = false;
  bool showBasket = false;

  
  CustomerOrderRequest getCustomerOrderRequest(){
    return CustomerOrderRequest(orders: basket, profileEmail: super.email ?? "");
  }

  dynamic getAnimalType(){
    return animalType;
  }

  dynamic getPayment(){
    return payment;
  }
  

  Future<bool> fetchProfile() async {

    isLoaded = false;
    isSuccessfullyLoaded = false;

    try{

      User? currentUser = FirebaseAuth.instance.currentUser;

      if(currentUser == null){
        return false;
      }

      final userID = currentUser.uid;

      final databaseName = dotenv.env['DATABASE_NAME'];

      if(databaseName == null){
        return false;
      }

      DocumentReference<Map<String, dynamic>> customerProfileDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Customers').doc(userID);
      DocumentSnapshot<Map<String, dynamic>> response = await customerProfileDocRef.get();

      if (response.data() == null) {
        return false;
      }

      customerProfileData = response.data()!;

      collectionName = customerProfileData['collectionName'];
      email = customerProfileData['email'];
      profileEmail = customerProfileData['email'];
      collectionAddressLine1 = customerProfileData['collectionAddress1'];
      collectionAddressLine2 = customerProfileData['collectionAddress2'];
      collectionAddressLine3 = customerProfileData['collectionAddress3'];
      collectionPostcode = customerProfileData['collectionPostcode'];
      collectionPhoneNumber = customerProfileData['collectionPhoneNumber'];

    }catch(error, stack){

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('customer_profile_error', {
            'module': 'customer_form',
            'details': error.toString(),
          });
        },
      );

      print(error);

      return false;
    }

    return true;

  }

  Future<bool> addOrderToBasket() async {

    Map<String, dynamic> order = super.getOrder();

    order.addAll({
      "clientSideUUID": uuid.v4(),    
    });

    //add order to list

    List<Map<String, dynamic>> basketCopy = List<Map<String, dynamic>>.from(
      json.decode(json.encode(basket))
    );

    basketCopy.add(order);

    //save json as basket
    final successfullySavedBasket = await saveBasket(basketCopy);

    if(!successfullySavedBasket){
      return false;
    }

    //update client if successfully updated local storage
    basket.add(order);

    return true;

  }

  Future<bool> removeOrderFromBasket(String uuid) async {

    bool removed = false;
    int? indexOfOrderToRemove;

    //remove from localstorage

    List<Map<String, dynamic>> basketCopy = List<Map<String, dynamic>>.from(
      json.decode(json.encode(basket))
    );

    for(var i = 0; i < basket.length; i++){

      if(basketCopy[i]['clientSideUUID'] == uuid){
        basketCopy.removeAt(i);
        indexOfOrderToRemove = i;
        removed = true;
        break;
      }

    }

    if(!removed){
      return false;
    } 

    //save json as basket
    final successfullySavedBasket = await saveBasket(basketCopy);

    if(!successfullySavedBasket){
      return false;
    }

    //remove on client
    basket.removeAt(indexOfOrderToRemove!);

    return true;

  }

  Future<bool> loadBasket() async {

    try{

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      //use for manual reset 
      // await prefs.setString('basket', '{"basket": []}');

      // Read values, providing a default if the key does not exist
      String? basketJSON = prefs.getString('basket');

      //if basket is null
      basketJSON ??= '{"basket": []}';

      basket = json.decode(basketJSON)['basket'];

    }catch(error, stack){

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('load_basket_error', {
            'module': 'basket',
            'details': error.toString(),
          });
        },
      );

      print(error);
      return false;
    }

    return true;

  }

  Future<bool> saveBasket(List<Map<String, dynamic>> basketCopy) async {

    try{

      String basketJSON = json.encode(basketCopy);

      basketJSON = '{"basket": $basketJSON}';

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Set the values with a key and a value
      await prefs.setString('basket', basketJSON);

    }catch(error, stack){

       await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('save_basket_error', {
            'module': 'basket',
            'details': error.toString(),
          });
        },
      );

      print(error);
      return false;
    }

    return true;

  }

  void clearForm(){

    animalType = null;
    quantity = null;
    code = null;
    boxes = null;
    deliveryAddressLine1 = null;
    deliveryAddressLine2 = null;
    deliveryAddressLine3 = null;
    deliveryName = null;
    deliveryPostcode = null;
    deliveryPhoneNumber = null;
    payment = null;
    message = null;

  }

}