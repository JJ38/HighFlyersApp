import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/admin_manage_orders_screen_model.dart';

class AdminManageOrdersScreenController {

  void Function() updateState;
  final AdminManageOrdersScreenModel model = AdminManageOrdersScreenModel();
  final listViewScrollController = ScrollController();


  AdminManageOrdersScreenController({required this.updateState});


  void onFilterTap(){

    

  }

  void onAddOrderTap(){

    

  }

  void getInitialOrders() async{

    model.isLoadingInitialOrders = true;
    final successfullyFetchedOrders = await model.getInitialOrders();
    model.isLoadingInitialOrders = false;


    if(!successfullyFetchedOrders){
      showToastWidget(ToastNotification(message: "Error loading orders", isError: true));
      return;
    }

    model.initialiseNewOrderListener(updateState);

    updateState();

  }

  void initialiseListViewScrollController(){


    listViewScrollController.addListener(() async {

      if(model.isLoadingAdditionalOrders){
        return;
      }

      if (listViewScrollController.position.pixels >= listViewScrollController.position.maxScrollExtent - 200) {

        model.isLoadingAdditionalOrders = true;
        updateState();
        final successfullyFetchedOrders = await model.getAdditionalOrders();

        if(!successfullyFetchedOrders){
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
