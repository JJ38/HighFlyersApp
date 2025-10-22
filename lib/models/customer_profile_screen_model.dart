import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/validator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CustomerProfileScreenModel {

  Validator validator;
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


  CustomerProfileScreenModel({required this.validator});


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

    }catch(error, stack){

      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('customer_profile_error', {
            'module': 'customer_profile',
            'details': error.toString(),
          });
        },
      );

      print(error);
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

      final databaseName = dotenv.env['DATABASE_NAME'];

      if(databaseName == null){
        return false;
      }

      DocumentReference<Map<String, dynamic>> customerDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Customers').doc(userID);

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
      

    }catch(error, stack){


      await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('customer_update_profile_error', {
            'module': 'customer_profile',
            'details': error.toString(),
          });
        },
      );

      print(error);
      return false;
    }
    
    //update client = 
    customerProfileData['collectionName'] = name;
    customerProfileData['email'] = email;
    customerProfileData['collectionAddress1'] = addressLine1;
    customerProfileData['collectionAddress2'] = addressLine2;
    customerProfileData['collectionAddress3'] = addressLine3;
    customerProfileData['collectionPostcode'] = postcode;
    customerProfileData['collectionPhoneNumber'] = phoneNumber;

    return true;

  }

  bool validateProfileForm(){

    if(addressLine1 == null){
      validator.validationErrorMessage = "Invalid Address Line 1";
      return false;
    }

    if(!validator.isValidEmail(email)){
      return false;
    }

    if(!validator.isValidPhoneNumber(phoneNumber)){
      return false;
    }

    if(!validator.isValidPostcode(postcode)){
      return false;
    }

    return true;

  }

}