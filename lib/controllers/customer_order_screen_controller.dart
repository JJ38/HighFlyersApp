import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/customer_order_model.dart';

class CustomerOrderScreenController{


  final CustomerOrderModel model = CustomerOrderModel();
  final void Function() updateState;

  CustomerOrderScreenController({required this.updateState});

  void animalTypeOnChange(String? input){

    model.animalType = input;
    print(model.animalType);

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

    List<Future> futures = [];

    //fetch animal types
    futures.add(model.fetchBirdSpecies());
    futures.add(model.fetchProfile());

    await Future.wait(futures);

    model.isLoaded = true;

    //parse birdSpecies
    model.parseBirdSpecies();

    updateState();

    if(model.birdSpeciesData.isEmpty){
      showToastWidget(ToastNotification(message: "Failed to load form", isError: true));
      return;
    }
    
    if(model.customerProfileData.isEmpty){
      showToastWidget(ToastNotification(message: "Failed to load profile", isError: true));
    }

    //fetch postcodes

  }

  void loadProfile() async {
 
    updateState();

  }

  void onAddToBasketTap() async {

    final isValidOrder = model.validateOrder();

    if(!isValidOrder){
      showToastWidget(ToastNotification(message: model.errorMessage, isError: true));
      return;
    }

    final successfullyAddedToBasket = await model.addOrderToBasket();

    if(!successfullyAddedToBasket){
      showToastWidget(ToastNotification(message: "Error adding order to basket", isError: true));
      return;
    }

    updateState();

    showToastWidget(ToastNotification(message: "Added order to basket", isError: false));

  }

}