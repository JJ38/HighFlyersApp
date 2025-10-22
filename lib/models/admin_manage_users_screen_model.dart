import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/request_model.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AdminManageUsersScreenModel extends RequestModel {

  List<dynamic> users = [];
  bool isLoading = true;
  bool isUpdatingPassword = false;

  Future<bool> loadUsers() async{

    try{

      final databaseName = dotenv.env['DATABASE_NAME'];
      if(databaseName == null){
        return false;
      }
    
      final usersDocs = await FirebaseFirestore.instanceFor(
        app: Firebase.app(),
        databaseId: databaseName,
      )
      .collection('Users')
      .orderBy('role', descending: false)
      .get();

      print(usersDocs.docs);
      users = usersDocs.docs;

    }catch(error, stack){

       await Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) {
          scope.setContexts('load_users_error', {
            'module': 'admin_manage_users',
            'details': error.toString(),
          });
        },
      );
      
      print(error);
      return false;
    }

    return true;

  }

}