import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/basket_item.dart';
import 'package:high_flyers_app/components/customer_order_form.dart';
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

    if(mounted){
      setState(() {
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Order", style: Theme.of(context).textTheme.titleLarge),
                      GestureDetector(
                        onTap: () { customerOrderScreenController.onBasketTap(); },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topRight,
                          children: [
                            const Icon(Icons.shopping_cart_outlined, size: 35),
                            if (customerOrderScreenController.model.basket.isNotEmpty)
                              Transform.translate(
                                offset: const Offset(2, -12),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Text(
                                    customerOrderScreenController.model.basket.length.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                 
                  customerOrderScreenController.model.isLoaded ?

                    customerOrderScreenController.model.isSuccessfullyLoaded ?

                        Expanded(
                          child: ListView(
                            children: [
                              CustomerOrderForm(customerOrderScreenController: customerOrderScreenController)
                            ],
                          ),
                        ) 

                      :

                        const Center(
                          child: Text("Error loading profile"),
                        ) 
                        
                    :
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                ],
              ),
            ),

            if (customerOrderScreenController.model.showBasket)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                height: screenHeight,
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: customerOrderScreenController.onCloseBasketTap,
                              child: const Icon(Icons.close, size: 35),
                            ),
                            const SizedBox(width: 10),
                            Text("Basket", style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 246, 246, 246)
                          ),
                          child: ListView(
                            children:[
                              ...customerOrderScreenController.model.basket.map((order) {                          
                                return BasketItem(order: order, onRemoveFromBasketTap: customerOrderScreenController.onRemoveFromBasketTap);
                              }),

                              customerOrderScreenController.model.basket.isNotEmpty ?

                                customerOrderScreenController.model.isSubmitting ? 

                                    Center(
                                      child: CircularProgressIndicator(),
                                    )

                                  :
                            
                                    Center(
                                      child: SizedBox(
                                        width: screenWidth * 0.9,
                                        child: Material(              
                                          color: Theme.of(context).colorScheme.secondary,
                                          shadowColor: Color(0x00000000),                                
                                          borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                                          child: MaterialButton(
                                            onPressed: () {customerOrderScreenController.submitOrder(context);},
                                            child: Text("Submit Orders", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),                           
                                          ),
                                        ),
                                      ),
                                    )

                              :

                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Center(
                                    child: Text("Your basket is empty")
                                  )
                                )
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
