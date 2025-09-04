import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/customer_profile_screen_model.dart';

class CustomerProfileScreenController {

  final CustomerProfileScreenModel model = CustomerProfileScreenModel();
  final void Function() updateState;
  Function()? updateStatefulButtonState;


  CustomerProfileScreenController({required this.updateState});


  void setStatefulButtonUpdateState(updateButtonState){
    updateStatefulButtonState = updateButtonState;
  }

  void loadProfile() async {
 
    final bool successfullyFetchedProfile = await model.fetchProfile();

    updateState();

    if(!successfullyFetchedProfile){
      showToastWidget(ToastNotification(message: "Failed to load profile", isError: true));
      return;
    }

  }

  void nameOnChange(String input){

    model.name = input;
    shouldShowUpdateButton();

  }

  void emailOnChange(String input){

    model.email = input;
    shouldShowUpdateButton();


  }

  void addressOneOnChange(String input){

    model.addressLine1 = input;
    shouldShowUpdateButton();

  }

  void addressTwoOnChange(String input){

    model.addressLine2 = input;
    shouldShowUpdateButton();

  }

  void addressThreeOnChange(String input){

    model.addressLine3 = input;
    shouldShowUpdateButton();

  }

  void postcodeOnChange(String input){

    model.postcode = input;
    shouldShowUpdateButton();

  }

  void phoneNumberOnChange(String input){

    model.phoneNumber = input;
    shouldShowUpdateButton();

  }

  void shouldShowUpdateButton(){

    if(hasValueChanged(model.name, model.customerProfileData['collectionName'])){
      return;
    }

    if(hasValueChanged(model.email, model.customerProfileData['email'])){
      return;
    }

    if(hasValueChanged(model.addressLine1, model.customerProfileData['collectionAddress1'])){
      return;
    }

    if(hasValueChanged(model.addressLine2, model.customerProfileData['collectionAddress2'])){
      return;
    }

    if(hasValueChanged(model.addressLine3, model.customerProfileData['collectionAddress3'])){
      return;
    }

    if(hasValueChanged(model.postcode, model.customerProfileData['collectionPostcode'])){
      return;
    }

    if(hasValueChanged(model.phoneNumber, model.customerProfileData['collectionPhoneNumber'])){
      return;
    }

    model.showUpdateButton = false;
    if(updateStatefulButtonState != null){
      updateStatefulButtonState!();
    }

  }

  bool hasValueChanged(String? currentValue, String? initialValue){

    if(currentValue != initialValue){
      model.showUpdateButton = true;
      if(updateStatefulButtonState != null){
        updateStatefulButtonState!();
      }
      return true;
    }

    return false;

  }

}