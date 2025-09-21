import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:high_flyers_app/models/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerOrderModel {

  final Validator validator = Validator();
  late Map<String, dynamic> birdSpeciesData;
  late Map<String, dynamic> postcodes;
  Map<String, dynamic> customerProfileData = {};
  Set<String> birdSpeciesSet = {};
  List<dynamic> basket = [];
  String? animalType;
  String? quantity;
  String? code;
  String? boxes;
  String? email;
  String? collectionName;
  String? collectionAddressLine1;
  String? collectionAddressLine2;
  String? collectionAddressLine3;
  String? collectionPostcode;
  String? collectionPhoneNumber;
  String? deliveryName;
  String? deliveryAddressLine1;
  String? deliveryAddressLine2;
  String? deliveryAddressLine3;
  String? deliveryPostcode;
  String? deliveryPhoneNumber;
  String? payment;
  String? message;
  String errorMessage = "";
  bool isLoaded = false;
  bool isSuccessfullyLoaded = false;
  bool showCollectionDetails = false;
  bool showBasket = false;

  Future<bool> fetchProfile() async {

    isLoaded = false;
    isSuccessfullyLoaded = false;

    try{

      User? currentUser = FirebaseAuth.instance.currentUser;

      if(currentUser == null){
        return false;
      }

      final userID = currentUser.uid;

      DocumentReference<Map<String, dynamic>> customerProfileDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "development").collection('Customers').doc(userID);
      DocumentSnapshot<Map<String, dynamic>> response = await customerProfileDocRef.get();

      if (response.data() == null) {
        return false;
      }

      customerProfileData = response.data()!;

      collectionName = customerProfileData['collectionName'];
      email = customerProfileData['email'];
      collectionAddressLine1 = customerProfileData['collectionAddress1'];
      collectionAddressLine2 = customerProfileData['collectionAddress2'];
      collectionAddressLine3 = customerProfileData['collectionAddress3'];
      collectionPostcode = customerProfileData['collectionPostcode'];
      collectionPhoneNumber = customerProfileData['collectionPhoneNumber'];

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

  Future<bool> fetchBirdSpecies() async {

    isLoaded = false;
    isSuccessfullyLoaded = false;

    try{

      DocumentReference<Map<String, dynamic>> birdSpeciesDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "development").collection('Settings').doc('birdSpecies');
      DocumentSnapshot<Map<String, dynamic>> response = await birdSpeciesDocRef.get();

      if (response.data() == null) {
        return false;
      }

      birdSpeciesData = response.data()!;

      isSuccessfullyLoaded = true;

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

  void parseBirdSpecies(){

    createBirdSpeciesSet();
    //createPricing();

  }

  void createBirdSpeciesSet(){

    final species = birdSpeciesData['species'];

    for(var i = 0; i < species.length; i++){

      birdSpeciesSet.add(species[i]['name']);

    }

  }

  bool validateOrder(){

    //order details

    if(!validator.isValidValueInList(animalType, birdSpeciesSet.toList())){
      errorMessage = "${validator.validationErrorMessage} - Animal Type";
      print("INVLAID ANIMAL TYPE");
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

  Future<bool> addOrderToBasket() async {

   
    final Map<String, dynamic> order = {
      "animalType": animalType,
      "quantity": quantity,
      "code": code,
      "boxes": boxes,
      "email": email,
      "collectionName": collectionName,
      "collectionAddressLine1": collectionAddressLine1,
      "collectionAddressLine2": collectionAddressLine2,
      "collectionAddressLine3": collectionAddressLine3,
      "collectionPostcode": collectionPostcode,
      "collectionPhoneNumber": collectionPhoneNumber,
      "deliveryName": deliveryName,
      "deliveryAddressLine1": deliveryAddressLine1,
      "deliveryAddressLine2": deliveryAddressLine2,
      "deliveryAddressLine3": deliveryAddressLine3,
      "deliveryPostcode": deliveryPostcode,
      "deliveryPhoneNumber": deliveryPhoneNumber,
      "payment": payment,
      "message": message
    }; 

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


  Future<bool> loadBasket() async {

    try{

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      //use for manual reset 
      // await prefs.setString('basket', '{"basket": []}');

      // Read values, providing a default if the key does not exist
      String? basketJSON = prefs.getString('basket');

      //if basket is null
      basketJSON ??= '{"basket": []}';

      // print("--------------------------------------------------------------");
      // print("loadBasket");
      // print(basketJSON);
      // print("--------------------------------------------------------------");


      basket = json.decode(basketJSON)['basket'];

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

  Future<bool> saveBasket(List<Map<String, dynamic>> basketCopy) async {

    try{

      String basketJSON = json.encode(basketCopy);

      basketJSON = '{"basket": $basketJSON}';

      // print("--------------------------------------------------------------");
      // print("saveBasket");
      // print(basketJSON);
      // print("--------------------------------------------------------------");


      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Set the values with a key and a value
      await prefs.setString('basket', basketJSON);

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

}