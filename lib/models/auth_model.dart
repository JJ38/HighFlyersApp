import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {

  AuthModel();

  static Future<bool> signOut() async {

    try{

      await FirebaseAuth.instance.signOut();

    }catch(error, stack){
      print(error);
      return false;
    }

    return true;

  }

}