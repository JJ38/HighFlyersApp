import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/admin_order_card.dart';
import 'package:high_flyers_app/controllers/admin_manage_orders_screen_controller.dart';

class AdminManageOrdersScreen extends StatefulWidget {
  const AdminManageOrdersScreen({super.key});

  @override
  State<AdminManageOrdersScreen> createState() =>
      _AdminManageOrdersScreenState();
}

class _AdminManageOrdersScreenState extends State<AdminManageOrdersScreen> {

  late AdminManageOrdersScreenController adminManageOrdersScreenController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminManageOrdersScreenController = AdminManageOrdersScreenController(updateState: updateState);
    adminManageOrdersScreenController.getInitialOrders();
    adminManageOrdersScreenController.initialiseListViewScrollController();
    updateState();
  }

  void updateState(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 20.0, horizontal: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                GestureDetector(
                  onTap: adminManageOrdersScreenController.onFilterTap,
                  child: const Icon(       
                    Icons.filter_alt_rounded,
                    color: Colors.black, // icon color
                    size: 28,
                  ),
                ),
                
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size(screenWidth * 0.1, screenWidth * 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: (){adminManageOrdersScreenController.onAddOrderTap(context);},
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text("Add", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ]
                  )
                ),
              ]
            ),
          ),
          Expanded(
            child: Stack(

              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 246, 246, 246)
                  ),
                ),

                adminManageOrdersScreenController.model.isLoadingInitialOrders ? 

                    Center(
                      child: CircularProgressIndicator()
                    )
                  
                  :
              
                    ListView.builder(
                      controller: adminManageOrdersScreenController.listViewScrollController,
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      itemCount: adminManageOrdersScreenController.model.isLoadingAdditionalOrders ? adminManageOrdersScreenController.model.orders.length + 1 : adminManageOrdersScreenController.model.orders.length,
                      itemBuilder: (context, index) {

                        if(index == adminManageOrdersScreenController.model.orders.length){
                          return Padding(
                            padding: EdgeInsetsGeometry.all(20),
                            child: Center(child: CircularProgressIndicator())
                          );
                        }

                        final data = adminManageOrdersScreenController.model.orders[index].data() as Map<String, dynamic>;
                
                        return Padding(
                          padding: EdgeInsetsGeometry.only(top: 10),
                          child: AdminOrderCard(order: data)
                        );
                      },
                    )              
              ],          
            )
          )
        ]
      )
    
    );
  }
}
