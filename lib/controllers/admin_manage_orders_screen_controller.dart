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

    updateState();

    getInitialOrders();
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
      getInitialOrders();
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
            builder: (context) => AdminAddOrderScreen(),
            settings: RouteSettings(name: '/Add Order Screen')));

    model.cancelOrderSubscription();
    model.orders = [];
    updateState();
    getInitialOrders();

  }

  void onAdminOrderTap(context, data, uuid) async{

    model.cancelOrderSubscription();

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AdminEditOrderScreen(order: data, uuid: uuid),
            settings: RouteSettings(name: '/Edit Order Screen')));

    //refetch orders

    print("popped add order");

    model.cancelOrderSubscription();
    model.orders = [];
    getInitialOrders();

  }

  void getInitialOrders() async{
    print("getInitialOrders");

    model.isLoadingOrders = true;
    updateState();

    final successfullyFetchedOrders = await model.getInitialOrders();
    model.isLoadingOrders = false;


    if(!successfullyFetchedOrders){
      showToastWidget(ToastNotification(message: "Error loading orders", isError: true));
      return;
    }

    model.isShowingFilteredOrders = false;
    model.initialiseNewOrderListener(updateState);

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
