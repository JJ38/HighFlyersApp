import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class CustomerOrderModel {

  late Map<String, dynamic> birdSpeciesData;
  late Map<String, dynamic> postcodes;
  Map<String, dynamic> customerProfileData = {};
  Set<String> birdSpeciesSet = {};
  List<dynamic> orders = [];
  String validationErrorMessage = "";
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
  bool isLoaded = false;
  bool isSuccessfullyLoaded = false;
  bool showCollectionDetails = false;

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
      print(birdSpeciesData);

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

    print(birdSpeciesSet);

  }

}