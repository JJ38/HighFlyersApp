import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/admin_order_card.dart';
import 'package:high_flyers_app/components/squared_input.dart';
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
    adminManageOrdersScreenController.initialiseManageOrders();
    adminManageOrdersScreenController.initialiseListViewScrollController();

    print("init state manage orders screen");
 
  }

  @override
  void dispose() {
    adminManageOrdersScreenController.model.orderSubscription?.cancel();
    super.dispose();
  }

  void updateState(){
    print("updateState manage orders");
    if(mounted){
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: const Color.fromARGB(255, 220, 220, 220), width: 1))
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 20.0, horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      GestureDetector(
                        onTap: adminManageOrdersScreenController.onFilterTap,
                        child: Icon(       
                          Icons.filter_alt_rounded,
                          color: adminManageOrdersScreenController.model.isShowingFilteredOrders ? Theme.of(context).colorScheme.secondary : Colors.black, // icon color
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
                    adminManageOrdersScreenController.model.showFilters ? 
                      Padding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String?>(
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                            decoration: InputDecoration(                      
                              label: Text("Filter field"),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              fillColor: Colors.grey,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.secondary,
                                  width: 2.0, 
                                ),
                              ),
                            ),
                            // value: orderController.model.animalType,  
                            hint: const Text("Select field to filter by"),                    
                            onChanged: (value){adminManageOrdersScreenController.onFilterFieldChange(value);},
                            items: adminManageOrdersScreenController.model.filterFields.entries.map((entry) =>                    
                                    DropdownMenuItem<String?>(
                                      value: entry.value['fieldValue'],
                                      child: Text(entry.key),
                                    )
                                  ).toList(),
                          ),
                          SizedBox(height: 10,),
                          SquaredInput(onChange: (value){adminManageOrdersScreenController.onSearchValueChange(value);}, label: "Search Value",),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  minimumSize: Size(screenWidth * 0.1, screenWidth * 0.05),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: (){adminManageOrdersScreenController.onSearchOrderTap();},
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Icon(Icons.search_outlined, color: Colors.white),
                                    Text("Search", style: TextStyle(color: Colors.white, fontSize: 18)),
                                  ]
                                )
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  minimumSize: Size(screenWidth * 0.1, screenWidth * 0.05),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: (){adminManageOrdersScreenController.onClearFilterTap();},
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    Icon(Icons.clear_outlined, color: Colors.white),
                                    Text("Clear", style: TextStyle(color: Colors.white, fontSize: 18)),
                                  ]
                                )
                              ),
                            ]
                          ),
                        ],
                      )
                    )
                 
                 :
                     SizedBox(height: 0,)
               ]
             ) 
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

                adminManageOrdersScreenController.model.isLoadingOrders ? 

                    Center(
                      child: CircularProgressIndicator()
                    )
                  
                  :
              
                    ListView.builder(
                      controller: adminManageOrdersScreenController.listViewScrollController,
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                      itemCount: adminManageOrdersScreenController.model.isLoadingAdditionalOrders || adminManageOrdersScreenController.model.hasLoadedAllOrders ? adminManageOrdersScreenController.model.orders.length + 1 : adminManageOrdersScreenController.model.orders.length,
                      itemBuilder: (context, index) {

                        if(index == adminManageOrdersScreenController.model.orders.length){

                          if(adminManageOrdersScreenController.model.hasLoadedAllOrders){
                            return Padding(
                              padding: EdgeInsetsGeometry.all(20),
                              child: Center(child: Text("All orders have been loaded"))
                            );
                          }

                          return Padding(
                            padding: EdgeInsetsGeometry.all(20),
                            child: Center(child: CircularProgressIndicator())
                          );
                        }

                        final doc = adminManageOrdersScreenController.model.orders[index];

                        final uuid = doc.id;
                        final data = doc.data() as Map<String, dynamic>;
                
                        return Padding(
                          padding: EdgeInsetsGeometry.only(top: 10),
                          child: GestureDetector(
                            onTap: (){ adminManageOrdersScreenController.onAdminOrderTap(context, data, uuid); },
                            child: AdminOrderCard(order: data, customerAccounts: adminManageOrdersScreenController.model.customerAccounts,)
                          )
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
