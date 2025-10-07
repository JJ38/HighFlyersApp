import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/admin_add_order_screen_model.dart';

class AdminAddOrderScreenController {

  AdminAddOrderScreenModel model = AdminAddOrderScreenModel();
  void Function() updateState;

  AdminAddOrderScreenController({required this.updateState});

  void onBackArrowTap(context){

    Navigator.pop(context);

  }
  
  void animalTypeOnChange(String? input){

    model.animalType = input;

  }

  void quantityOnChange(String input){

    model.quantity = input;

  }

  void codeOnChange(String input){

    model.code = input;

  }

  void boxesOnChange(String input){

    model.boxes = input;

  }
  
  void collectionNameOnChange(String input){

    model.collectionName = input;

  }

  void emailOnChange(String input){

    model.email = input;

  }

  void collectionAddressOneOnChange(String input){

    model.collectionAddressLine1 = input;

  }

  void collectionAddressTwoOnChange(String input){

    model.collectionAddressLine2 = input;

  }

  void collectionAddressThreeOnChange(String input){

    model.collectionAddressLine3 = input;

  }

  void collectionPostcodeOnChange(String input){

    model.collectionPostcode = input;

  }

  void collectionPhoneNumberOnChange(String input){

    model.collectionPhoneNumber = input;

  }

  void onCollectionDetailsTap(){

    model.showCollectionDetails = !model.showCollectionDetails;
    updateState();

  }

  void deliveryNameOnChange(String input){

    model.deliveryName = input;

  }

  void deliveryAddressOneOnChange(String input){

    model.deliveryAddressLine1 = input;

  }

  void deliveryAddressTwoOnChange(String input){

    model.deliveryAddressLine2 = input;

  }

  void deliveryAddressThreeOnChange(String input){

    model.deliveryAddressLine3 = input;

  }

  void deliveryPostcodeOnChange(String input){

    model.deliveryPostcode = input;

  }

  void deliveryPhoneNumberOnChange(String input){

    model.deliveryPhoneNumber = input;

  }

  void paymentOnChange(String? input){

    model.payment = input;

  }

  void messageOnChange(String input){

    model.message = input;

  }


  void loadForm() async {
    
    //fetch animal types
    await model.fetchBirdSpecies();

    model.isLoaded = true;

    //parse birdSpecies
    model.parseBirdSpecies();

    updateState();

    if(model.birdSpeciesData.isEmpty){
      showToastWidget(ToastNotification(message: "Failed to load form", isError: true));
      return;
    }

    //fetch postcodes

  }

  void submitOrder() async {

    final isValidOrder = model.validateOrder();

    if(!isValidOrder){
      showToastWidget(ToastNotification(message: model.errorMessage, isError: true));
      return;
    }

    model.isSubmitting = true;
    updateState();

    final submittedOrdersSuccessfully = await model.submitOrder();

    model.isSubmitting = false;

    if(!submittedOrdersSuccessfully){

      showToastWidget(ToastNotification(message: "Error adding order", isError: true));
      updateState();

      return;

    }

    showToastWidget(ToastNotification(message: "Successfully added order", isError: false));

    updateState();

  }

}