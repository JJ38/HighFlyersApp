import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/customer_order_model.dart';

class CustomerOrderScreenController{


  final CustomerOrderModel model = CustomerOrderModel();
  final void Function() updateState;

  CustomerOrderScreenController({required this.updateState});

  void animalTypeOnChange(String input){

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

  void collectionEmailOnChange(String input){

    model.collectionEmail = input;


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

  void deliveryEmailOnChange(String input){

    model.deliveryEmail = input;


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

  void loadForm() async {

    //fetch animal types
    final bool successfullyFetchedProfile = await model.fetchBirdSpecies();


    //parse birdSpecies
    model.parseBirdSpecies();

    updateState();

    if(!successfullyFetchedProfile){
      showToastWidget(ToastNotification(message: "Failed to load form", isError: true));
      return;
    }


    //fetch postcodes

  }

  void onAddToBasketTap(){

    

  }

}