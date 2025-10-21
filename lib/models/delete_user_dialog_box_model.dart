import 'package:high_flyers_app/models/Requests/delete_user_request.dart';
import 'package:high_flyers_app/models/request_model.dart';

class DeleteUserDialogBoxModel extends RequestModel{

  dynamic userDoc;
  String? userUID;
  String? username;
  String? role;


  void setUserDoc(userDoc){

    if(userDoc == null){
      return;
    }

    userUID = userDoc!.id;
    username = userDoc!.data()['username'];
    role = userDoc!.data()['role'];

  }

  Future<bool> deleteUser() async {

    if(userDoc == null){
      return false;
    }

    final String uid = userDoc!.id;

    final Map<String, dynamic>? userData = userDoc!.data();

    if(userData == null){
      return false;
    }

    final String? role = userData['role'];
    final String? username = userData['username'];

    if(role == null || username == null){
      return false;
    }
    
    try{

      final DeleteUserRequest deleteUserRequest = DeleteUserRequest(uid: uid, role: role);

      final bool successfullyDeletedUser = await submitAuthenticatedRequest(deleteUserRequest);

      if(!successfullyDeletedUser){
        return false;
      }

      return true;

    }catch(e){
      print(e);
      return false;
    }

  }

}