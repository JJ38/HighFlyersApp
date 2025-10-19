import 'package:high_flyers_app/models/Requests/update_user_password_request.dart';
import 'package:high_flyers_app/models/request_model.dart';

class ChangePasswordDialogBoxModel extends RequestModel {

  String? newPassword;
  bool isUpdatingPassword = false;

  
  Future<bool> updateUserPassword(String uid) async{
    
    if(newPassword == null){
      return false;
    }

    try{
      
      final updateUserPasswordRequest = UpdateUserPasswordRequest(uid: uid, newPassword: newPassword!);

      final bool successfullyUpdatedUserPassword = await submitAuthenticatedRequest(updateUserPasswordRequest);

      if(!successfullyUpdatedUserPassword){
        return false;
      }

    }catch(e){
      print(e);
      return false;
    }
    
    return true;
  }

}