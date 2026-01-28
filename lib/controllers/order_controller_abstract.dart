import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';
import 'package:high_flyers_app/models/order_model_abstract.dart';

abstract class OrderController<T extends OrderModel> {

  late final T model;
  final void Function() updateState;

  OrderController({required this.updateState}){

    model = createModel();

  }

  T createModel();
  
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

  void accountOnChange(String? input){

    model.account = input;

  }

  void deliveryWeekOnChange(String input){

    model.deliveryWeek = input;

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

    if(input == "Collection"){
      input = "Pickup";
    }

    model.payment = input;

  }

  void priceOnChange(String input){

    model.price = input;

  }

  void messageOnChange(String input){

    model.message = input;

  }

  void loadForm() async {

    //fetch animal types
    await model.fetchFormData();

    if(!model.isSuccessfullyLoaded){
      updateState();
      showToastWidget(ToastNotification(message: "Failed to load form", isError: true));
      return;
    }

    model.parseBirdSpecies();
    model.parseCustomerAccounts();

    updateState();

  }

  void submitOrder(context);

}