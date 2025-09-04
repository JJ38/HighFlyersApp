import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class CustomerProfileScreenModel {

  String? name;
  String? email;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? postcode;
  String? phoneNumber;
  bool isLoaded = false;
  bool isSuccessfullyLoaded = false;

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

      Map<String, dynamic> customerProfileData = response.data()!;

      name = customerProfileData['collectionName'];
      email = customerProfileData['email'];
      addressLine1 = customerProfileData['collectionAddress1'];
      addressLine2 = customerProfileData['collectionAddress2'];
      addressLine3 = customerProfileData['collectionAddress3'];
      postcode = customerProfileData['collectionPostcode'];
      phoneNumber = customerProfileData['collectionPhoneNumber'];

      isLoaded = true;
      isSuccessfullyLoaded = true;

      print(customerProfileData);

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

}