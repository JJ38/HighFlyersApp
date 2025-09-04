import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class CustomerProfileScreenModel {

  final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp digitRegex = RegExp(r'^\d+$');
  late Map<String, dynamic> customerProfileData;
  String validationErrorMessage = "";
  String? name;
  String? email;
  String? addressLine1;
  String? addressLine2;
  String? addressLine3;
  String? postcode;
  String? phoneNumber;
  bool isLoaded = false;
  bool isSuccessfullyLoaded = false;
  bool showUpdateButton = false;

  bool getShowUpdateButton(){

    return showUpdateButton;

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

      DocumentReference<Map<String, dynamic>> customerProfileDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "development").collection('Customers').doc(userID);
      DocumentSnapshot<Map<String, dynamic>> response = await customerProfileDocRef.get();

      if (response.data() == null) {
        return false;
      }

      customerProfileData = response.data()!;

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

  Future<bool> updateProfile() async {

    try{

      User? currentUser = FirebaseAuth.instance.currentUser;

      if(currentUser == null){
        return false;
      }

      final userID = currentUser.uid;

      DocumentReference<Map<String, dynamic>> customerDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "development").collection('Customers').doc(userID);

      Map<String, dynamic> fieldsToUpdate = 
      {
        'email': email,
        'collectionName': name,
        'collectionAddress1': addressLine1,
        'collectionAddress2': addressLine2,
        'collectionAddress3': addressLine3,
        'collectionPostcode': postcode,
        'collectionPhoneNumber': phoneNumber
      };

      await customerDocRef.update(fieldsToUpdate);

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

  bool validateProfileForm(){

    if(addressLine1 == null){
      validationErrorMessage = "Invalid Address Line 1";
      return false;
    }

    if(!isValidEmail(email)){
      return false;
    }

    if(!isValidPhoneNumber(phoneNumber)){
      return false;
    }

    if(!isValidPostcode(postcode)){
      return false;
    }


    return true;

  }

  bool isValidEmail(String? email){

    if(email == null){
      validationErrorMessage = "Please enter an email address";
      return false;
    }
 
    if(!emailRegex.hasMatch(email)){
      validationErrorMessage = "Invalid Email";
      return false;
    }
    
    
    return true;
  }

  bool isValidPhoneNumber(String? phoneNumberInput){

    if(phoneNumberInput == null){
      validationErrorMessage = "Please enter a phone number";
      return false;
    }

    if(phoneNumberInput.length != 11 || !digitRegex.hasMatch(phoneNumberInput)){
      validationErrorMessage = "Invalid Phone Number";
      return false;
    }

    return true;

  }

  bool isValidPostcode(String? postcodeInput){

    if(postcodeInput == null){
      validationErrorMessage = "Please enter a postcode";
      return false;
    }

    postcodeInput = postcodeInput.replaceAll(" ", "");

    if(postcodeInput.length < 2 || postcodeInput.length > 7){
      validationErrorMessage = "Invalid Postcode";
      return false;
    }

    return true;
  }

}