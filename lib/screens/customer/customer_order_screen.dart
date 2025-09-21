import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/order_card.dart';
import 'package:high_flyers_app/components/order_form.dart';
import 'package:high_flyers_app/components/squared_input.dart';
import 'package:high_flyers_app/controllers/customer_order_screen_controller.dart';

class CustomerOrderScreen extends StatefulWidget {
  const CustomerOrderScreen({super.key});

  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {

  late CustomerOrderScreenController customerOrderScreenController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerOrderScreenController = CustomerOrderScreenController(updateState: updateState);
    customerOrderScreenController.loadForm();
  } 

  void updateState(){
    print("customer order screen set state");
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
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order", style: Theme.of(context).textTheme.titleLarge),
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topRight,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 35,),

                      customerOrderScreenController.model.basket.isNotEmpty ? 

                          Transform.translate(
                            offset: Offset(2, -12),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red
                              ),
                              child: Text(customerOrderScreenController.model.basket.length.toString(), style: TextStyle(color: Colors.white),),
                            ),
                          )
                        
                        :

                          SizedBox(height: 0, width: 0,)

                    ],
                  )
                ],
              ),

              customerOrderScreenController.model.isLoaded ? 

                customerOrderScreenController.model.isSuccessfullyLoaded ? 

                  Expanded(
                    child: ListView(
                      children: [
                        Expanded(child: OrderForm(customerOrderScreenController: customerOrderScreenController))
                      ]
                    ),
                  )
                
                :

                  Center(
                    child: Text("Error loading profile")
                  )

              :

                Center(
                  child: CircularProgressIndicator()
                )
              
            ],
          ),
        ),

      ),
    );
  }
}
