import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/controllers/order_controller_abstract.dart';

import 'package:high_flyers_app/models/customer_order_model.dart';

class CustomerOrderScreenController extends OrderController<CustomerOrderModel>{


  CustomerOrderScreenController({required super.updateState});

  @override
  CustomerOrderModel createModel(){
    return CustomerOrderModel();
  }

  void onCollectionDetailsTap(){

    model.showCollectionDetails = !model.showCollectionDetails;
    updateState();

  }

  @override
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

    //clear non profile form fields
    model.clearForm();


    updateState();

    showToastWidget(ToastNotification(message: "Added order to basket", isError: false));

  }


  void onRemoveFromBasketTap(String? uuid) async { 

    if(uuid == null){
      showToastWidget(ToastNotification(message: "Error removing order from basket", isError: true));
      return;
    }

    //find order in list based on uuid
    final bool successfullyRemovedOrder = await model.removeOrderFromBasket(uuid);

    if(!successfullyRemovedOrder){
      showToastWidget(ToastNotification(message: "Error removing order from basket", isError: true));
      return;
    }

    showToastWidget(ToastNotification(message: "Successfully removed order from basket", isError: false));

    updateState();

  }

  void loadBasket() async {

    final successfullyLoadedBasket = await model.loadBasket();

    if(!successfullyLoadedBasket){
      showToastWidget(ToastNotification(message: "Error adding order to basket", isError: true));
      return;
    }

    updateState();

  }

  void onBasketTap(){

    model.showBasket = !model.showBasket;
    updateState();

  }

  void onCloseBasketTap(){

    model.showBasket = !model.showBasket;
    updateState();

  }

  @override
  void submitOrder(context) async {

    model.isSubmitting = true;
    updateState();

    final request = model.getCustomerOrderRequest();
  

    print(model.deliveryAddressLine1);

    final submittedOrdersSuccessfully = await model.submitAuthenticatedRequest(request);
    final clearedBasketSuccessfully = await model.saveBasket([]);

    model.isSubmitting = false;

    if(!submittedOrdersSuccessfully){

      showToastWidget(ToastNotification(message: "Error submitting orders", isError: true));
      updateState();

      return;

    }

    if(!clearedBasketSuccessfully){

      showToastWidget(ToastNotification(message: "Error clearing basket", isError: true));
      updateState();

      return;

    }

    showToastWidget(ToastNotification(message: "Successfully submitted order(s) - you should revieve an email shortly", isError: false));

    //clear basket
    model.basket = [];
    updateState();

  }

}