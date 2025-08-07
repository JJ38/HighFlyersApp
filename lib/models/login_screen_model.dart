import 'package:firebase_auth/firebase_auth.dart';


class LoginScreenModel {

  String? username;
  String? password;
  String? errorMessage;

  Future<dynamic> login() async {

    if(username == null && password == null){
      return false;
    }

    try{

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "${username!}@placeholder.com",
        password: password!
      );

      final user = userCredential.user;

      if(user == null){
        return false;
      }

      final jwt = await user.getIdTokenResult();
      final role = jwt.claims?['role'];

      print(role);

      if(role == null){
        return false;
      }

      return true;

    }on FirebaseAuthException catch (e){
      
      getFirebaseErrorMessage(e.code);
      return false;

    } catch(e){

      errorMessage = "Unknown Error";
      return false;

    }

  }

  void getFirebaseErrorMessage(errorType){

    switch (errorType){

      case 'invalid-credentials':
        errorMessage = "Invalid Credentials";
        break;

      case 'user-disabled':
        errorMessage = 'This account has been disabled';
        break;

      default:
        errorMessage = 'Invalid Credentials';

    }

  }

}