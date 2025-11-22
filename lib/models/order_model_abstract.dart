import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/request_model.dart';
import 'package:high_flyers_app/models/validator.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class OrderModel extends RequestModel{
  
  final Validator validator = Validator();
  late Map<String, dynamic> birdSpeciesData;
  late Map<String, dynamic> postcodes;
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> customerAccounts;
  Map<String, dynamic> customerProfileData = {};
  Set<String> birdSpeciesSet = {};
  String? animalType;
  String? quantity;
  String? code = "";
  String? boxes;
  String? email;
  String? account;
  String? deliveryWeek;
  String? profileEmail;
  String? collectionName;
  String? collectionAddressLine1;
  String? collectionAddressLine2 = "";
  String? collectionAddressLine3 = "";
  String? collectionPostcode;
  String? collectionPhoneNumber;
  String? deliveryName;
  String? deliveryAddressLine1;
  String? deliveryAddressLine2 = "";
  String? deliveryAddressLine3 = "";
  String? deliveryPostcode;
  String? deliveryPhoneNumber;
  String? payment;
  String? price;
  String? message = "";
  String errorMessage = "";
  bool isLoaded = false;
  bool isSuccessfullyLoaded = false;
  bool isSubmitting = false;

  
  Future<bool> fetchBirdSpecies() async {

    try{

      final databaseName = dotenv.env['DATABASE_NAME'];

      if(databaseName == null){
        return false;
      }

      DocumentReference<Map<String, dynamic>> birdSpeciesDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Settings').doc('birdSpecies');
      DocumentSnapshot<Map<String, dynamic>> response = await birdSpeciesDocRef.get();

      if (response.data() == null) {
        return false;
      }

      birdSpeciesData = response.data()!;

    }catch(error, stack){
      
      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('get_bird_species_error', {
            'module': 'order_form_error',
            'details': error.toString(),
          });
        },
      );
      
      print(error);
      return false;
    }

    return true;

  }

  void parseBirdSpecies(){

    createBirdSpeciesSet();

  }

  void createBirdSpeciesSet(){

    final species = birdSpeciesData['species'];

    for(var i = 0; i < species.length; i++){

      birdSpeciesSet.add(species[i]['name']);

    }

  }


  Future<bool> fetchCustomerAccounts() async {

    try{

      final databaseName = dotenv.env['DATABASE_NAME'];

      if(databaseName == null){
        return false;
      }

      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Users').where('role', isEqualTo: 'customer').get();

      if (response.docs.isEmpty) {
        return false;
      }

      customerAccounts = response.docs;

    }catch(error, stack){
      
      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('get_customer_accounts_error', {
            'module': 'order_form_error',
            'details': error.toString(),
          });
        },
      );
      
      print(error);
      return false;
    }

    return true;

  }

  Future<void> fetchFormData() async {

    print("fetchOrderData");

    isLoaded = false;
    isSuccessfullyLoaded = false;

    List<Future<bool>> futures = [];

    futures.add(fetchBirdSpecies());
    futures.add(fetchCustomerAccounts());
    
    final futuresResult = await Future.wait(futures);

    isLoaded = true;

    if(futuresResult.contains(false)){
      print("form failed to load");
      return;
    }
    
    isSuccessfullyLoaded = true;

  }


  bool validateOrder(){

    //order details

    if(!validator.isValidValueInList(animalType, birdSpeciesSet.toList())){
      errorMessage = "${validator.validationErrorMessage} - Animal Type";
      return false;
    }

    if(!validator.isValidPositiveNumber(quantity)){
      errorMessage = "${validator.validationErrorMessage} - Quantity";
      return false;
    }

    if(!validator.isValidPositiveNumber(boxes)){
      errorMessage = "${validator.validationErrorMessage} - Boxes";
      return false;
    }


    //collection

    if(!validator.isValidString(collectionName)){
      errorMessage = "${validator.validationErrorMessage} - Collection Name";
      return false;
    }

    if(!validator.isValidString(collectionAddressLine1)){
      errorMessage = "${validator.validationErrorMessage} - Collection Address 1";
      return false;
    }

    if(!validator.isValidPostcode(collectionPostcode)){
      errorMessage = "${validator.validationErrorMessage} - Collection Postcode";
      return false;
    }

    if(!validator.isValidPhoneNumber(collectionPhoneNumber)){
      errorMessage = "${validator.validationErrorMessage} - Collection Phonenumber";
      return false;
    }


    //delivery

    if(!validator.isValidString(deliveryName)){
      errorMessage = "${validator.validationErrorMessage} - Delivery Name";
      return false;
    }

    if(!validator.isValidString(deliveryAddressLine1)){
      errorMessage = "${validator.validationErrorMessage} - Delivery Address 1";
      return false;
    }

    if(!validator.isValidPostcode(deliveryPostcode)){
      errorMessage = "${validator.validationErrorMessage} - Delivery Postcode";
      return false;
    }

    if(!validator.isValidPhoneNumber(deliveryPhoneNumber)){
      errorMessage = "${validator.validationErrorMessage} - Delivery Phonenumber";
      return false;
    }

    //payment

    if(!validator.isValidValueInList(payment, ["Collection", "Delivery", "Account"])){
      errorMessage = "${validator.validationErrorMessage} - Payment";
      return false;
    }
    
    return true;

  }


  Map<String, dynamic> getOrder(){

    account ??= "";
    print(account);

    Map<String, dynamic> order = {

      "animalType": animalType,
      "quantity": quantity,
      "code": code,
      "boxes": boxes,
      "email": email,
      "account": account,
      "collectionName": collectionName,
      "collectionAddress1": collectionAddressLine1,
      "collectionAddress2": collectionAddressLine2,
      "collectionAddress3": collectionAddressLine3,
      "collectionPostcode": collectionPostcode!.toUpperCase(),
      "collectionPhoneNumber": collectionPhoneNumber,
      "deliveryName": deliveryName,
      "deliveryAddress1": deliveryAddressLine1,
      "deliveryAddress2": deliveryAddressLine2,
      "deliveryAddress3": deliveryAddressLine3,
      "deliveryPostcode": deliveryPostcode!.toUpperCase(),
      "deliveryPhoneNumber": deliveryPhoneNumber,
      "addedBy": "",
      "payment": payment,
      "message": message
    }; 

    if(deliveryWeek != null){
      order['deliveryWeek'] = deliveryWeek;
    }

    if(price != null){
      order['price'] = price;
    }

    print(order);

    return order;

  }



}