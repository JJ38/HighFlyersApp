import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/admin_order_form.dart';
import 'package:high_flyers_app/controllers/admin_add_order_screen_controller.dart';

class AdminAddOrderScreen extends StatefulWidget {
  const AdminAddOrderScreen({super.key});

  @override
  State<AdminAddOrderScreen> createState() => _AdminAddOrderScreenState();
}

class _AdminAddOrderScreenState extends State<AdminAddOrderScreen> {

  late AdminAddOrderScreenController adminAddOrderScreenController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminAddOrderScreenController = AdminAddOrderScreenController(updateState: updateState);
  }

  void updateState(){

    if(mounted){
      setState(() {
        
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: screenWidth * 0.05),
          child: ListView(
            children: [
              GestureDetector(
                onTap: (){adminAddOrderScreenController.onBackArrowTap(context);},
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical:  10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_back_sharp),
                          Text("Back", style: Theme.of(context).textTheme.titleSmall),
                        ],
                      ),
                      Text("Add", style: Theme.of(context).textTheme.titleSmall),
                    ]
                  ),
                ),
              ),
              AdminOrderForm(orderController: adminAddOrderScreenController, buttonText: "Add Order",)
            ],
          )
        )
      )
    );
  }
}