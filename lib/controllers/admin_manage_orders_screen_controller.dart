import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/admin_manage_orders_screen_model.dart';
import 'package:high_flyers_app/screens/admin/admin_add_order_screen.dart';
import 'package:high_flyers_app/screens/admin/admin_edit_order_screen.dart';

class AdminManageOrdersScreenController {

  void Function() updateState;
  final AdminManageOrdersScreenModel model = AdminManageOrdersScreenModel();
  final listViewScrollController = ScrollController();


  AdminManageOrdersScreenController({required this.updateState});


  void onFilterTap(){

    model.showFilters = !model.showFilters;
    updateState();

  }

  void onClearFilterTap() async {

    model.showFilters = !model.showFilters;
    model.selectedFilterField = null;
    model.searchValue = null;

    model.orders = [];

    await getInitialOrders();
    updateState();
  }

  void onFilterFieldChange(String? field){
    model.selectedFilterField = field;
  }

  void onSearchValueChange(String? field){
    model.searchValue = field;
  }

  void onSearchOrderTap() async {
  
    print(model.selectedFilterField);
    print(model.searchValue);

    if(model.selectedFilterField == null){
      showToastWidget(ToastNotification(message: "Error selected a field to filter", isError: true));
      return;
    }

    if(model.searchValue == null){
      showToastWidget(ToastNotification(message: "Error enter a search value", isError: true));
      return;
    } 

    model.cancelOrderSubscription();
    model.orders = [];
    model.isLoadingOrders = true;
    updateState();

    final success = await model.getFilteredOrders();

    if(!success){
      showToastWidget(ToastNotification(message: "Error fetching filtered orders", isError: true));
      await getInitialOrders();
      updateState();
      return;
    }

    model.isShowingFilteredOrders = true;
    model.isLoadingOrders = false;
    updateState();

    showToastWidget(ToastNotification(message: "Successfully fetched filtered orders", isError: false));  

  } 

  void onAddOrderTap(context) async{

    model.cancelOrderSubscription();

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdminAddOrderScreen(knownCustomerAccounts: model.customerAccounts,),
            settings: RouteSettings(name: '/Add Order Screen')));

    model.cancelOrderSubscription();
    model.orders = [];
    updateState();
    await getInitialOrders();
    updateState();

  }

  void onAdminOrderTap(context, data, uuid) async{

    model.cancelOrderSubscription();

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdminEditOrderScreen(order: data, uuid: uuid, knownCustomerAccounts: model.customerAccounts),
            settings: RouteSettings(name: '/Edit Order Screen')));

    //refetch orders

    model.cancelOrderSubscription();
    model.orders = [];
    await getInitialOrders();
    updateState();

  }

  Future<bool> getInitialOrders() async{
    print("getInitialOrders");

    model.isLoadingOrders = true;
    updateState();

    final successfullyFetchedOrders = await model.getInitialOrders();

    model.isLoadingOrders = false;


    if(!successfullyFetchedOrders){
      showToastWidget(ToastNotification(message: "Error loading orders", isError: true));
      return false;
    }

    model.isShowingFilteredOrders = false;
    await model.initialiseNewOrderListener(updateState);

    return true;

  }

  void initialiseManageOrders() async {
    
    final successfullyFetchedInitialOrders = await getInitialOrders();

    if(!successfullyFetchedInitialOrders){
      updateState();
      return;
    }

    final successfullyFetchedCustomerAccounts = await model.fetchCustomerAccounts();

    if(!successfullyFetchedCustomerAccounts){
      //will show orders with account names as ids
      updateState();
      showToastWidget(ToastNotification(message: "Error loading customer accounts", isError: true));
      return;
    }

    //parse customer accounts
    model.parseCustomerAccounts();
    print("initialiseManageOrders finished");
    updateState();

  }

  void initialiseListViewScrollController(){

    listViewScrollController.addListener(() async {

      if(model.isLoadingAdditionalOrders){
        return;
      }

      if ((listViewScrollController.position.pixels >= listViewScrollController.position.maxScrollExtent - 1500) && !model.hasLoadedAllOrders) {

        model.isLoadingAdditionalOrders = true;
        updateState();
        final successfullyFetchedOrders = await model.getAdditionalOrders();

        if(!successfullyFetchedOrders && !model.hasLoadedAllOrders){       
          showToastWidget(ToastNotification(message: "Error fetching additional orders", isError: true));
        }

        model.isLoadingAdditionalOrders = false;
        updateState();
      }

    });
  
  }

  void getOrderListener(){

    model.updateOrderListener();
    updateState();

  }

}
