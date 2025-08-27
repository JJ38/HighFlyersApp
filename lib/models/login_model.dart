import 'package:firebase_auth/firebase_auth.dart';

class LoginScreenModel {
  String? username;
  String? password;
  String? errorMessage;
  String? role;

  Future<bool> login() async {

    if (username == null || password == null) {
      errorMessage = "Invalid Credentials";
      return false;
    }

    try {

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: "${username!}@placeholder.com", password: password!);

      final user = userCredential.user;

      if (user == null) {
        return false;
      }

      final jwt = await user.getIdTokenResult();
      role = jwt.claims?['role'];

      if (role == null) {
        errorMessage = "Invalid Credentials";
        return false;
      }

      return true;

    } on FirebaseAuthException catch (e) {

      getFirebaseErrorMessage(e.code);
      return false;

    } catch (e) {

      errorMessage = "Invalid Credentials";
      return false;

    }
  }

  void getFirebaseErrorMessage(errorType) {

    switch (errorType) {

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
