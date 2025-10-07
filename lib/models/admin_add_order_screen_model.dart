import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:high_flyers_app/models/validator.dart';
import 'package:http/http.dart' as http;

class AdminAddOrderScreenModel {

  final Validator validator = Validator();
  late Map<String, dynamic> birdSpeciesData;
  late Map<String, dynamic> postcodes;
  Map<String, dynamic> customerProfileData = {};
  Set<String> birdSpeciesSet = {};
  List<dynamic> basket = [];
  String? animalType;
  String? quantity;
  String? code = "";
  String? boxes;
  String? email;
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
  String? message = "";
  String errorMessage = "";
  bool isLoaded = false;
  bool isSuccessfullyLoaded = false;
  bool showCollectionDetails = false;
  bool showBasket = false;
  bool isSubmitting = false;
  
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

  Future<bool> submitOrder() async {

    try{

      final user = FirebaseAuth.instance.currentUser;
      String? token = await user?.getIdToken();  

      final url = Uri.parse('https://api-qjydin7gka-uc.a.run.app/storeorder');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "profileEmail": email,
          "orderDetails": basket
        }),
      );

      if (response.statusCode == 200) {

        print('Response: ${response.body}');

      } else {

        print('Error: ${response.statusCode} - ${response.body}');
        return false;

      }

    }catch(e){

      print(e);
      return false;

    }

    return true;
    
  }


}