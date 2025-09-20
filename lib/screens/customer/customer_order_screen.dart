import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/order_card.dart';
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
  } 

  void updateState(){
    setState(() {
      
    });
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
              Text("Order", style: Theme.of(context).textTheme.titleLarge),

              // customerOrderScreenController.model.isLoaded ? 

              //   customerOrderScreenController.model.isSuccessfullyLoaded ? 
                  Expanded(
                    child: ListView(
                      children: [
                        Text("Order Details", style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 10, width: 0,),
                        Expanded(
                          child: Column(
                            children: [
                              SquaredInput(label: "Animal Type", value: customerOrderScreenController.model.animalType, icon: Icons.pets_outlined, onChange: customerOrderScreenController.animalTypeOnChange),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Quantity", value: customerOrderScreenController.model.quantity, icon: Icons.numbers_outlined, onChange: customerOrderScreenController.quantityOnChange),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Code", value: customerOrderScreenController.model.code, icon: Icons.redeem_outlined, onChange: customerOrderScreenController.codeOnChange),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Boxes", value: customerOrderScreenController.model.boxes, icon: Icons.card_travel_outlined, onChange: customerOrderScreenController.boxesOnChange),
                              SizedBox(height: 20,),
                            ]
                          )
                        ),
                        
                        Material(
                          color: Colors.white,
                          shadowColor: Color(0x00000000),                                
                          borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                          child: MaterialButton(
                            padding: EdgeInsets.all(0),
                            onPressed: customerOrderScreenController.onCollectionDetailsTap,
                            minWidth: screenWidth * 0.9,
                            height: screenWidth * 0.1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Collection Details", style: Theme.of(context).textTheme.titleMedium),
                                  customerOrderScreenController.model.showCollectionDetails ? 

                                      Icon(Icons.arrow_downward_sharp)
                                    
                                    :
                                    
                                      Icon(Icons.arrow_forward_sharp)

                                ]
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10, width: 0,),


                        customerOrderScreenController.model.showCollectionDetails ? 
                            
                            Expanded(
                              child: Column(
                                children: [
                                  SquaredInput(label: "Collection Name", value: customerOrderScreenController.model.collectionName, icon: Icons.person_outline_outlined, onChange: customerOrderScreenController.collectionNameOnChange),
                                  SizedBox(height: 20,),
                                  SquaredInput(label: "Collection Email", value: customerOrderScreenController.model.collectionEmail, icon: Icons.alternate_email_outlined, keyboardType: TextInputType.emailAddress, onChange: customerOrderScreenController.collectionEmailOnChange),
                                  SizedBox(height: 20,),
                                  SquaredInput(label: "Collection Address line 1", value: customerOrderScreenController.model.collectionAddressLine1, icon: Icons.local_post_office_outlined, onChange: customerOrderScreenController.collectionAddressOneOnChange),
                                  SizedBox(height: 20,),
                                  SquaredInput(label: "Collection Address line 2", value: customerOrderScreenController.model.collectionAddressLine2, icon: Icons.local_post_office_outlined, onChange: customerOrderScreenController.collectionAddressTwoOnChange),
                                  SizedBox(height: 20,),
                                  SquaredInput(label: "Collection Address line 3", value: customerOrderScreenController.model.collectionAddressLine3, icon: Icons.local_post_office_outlined, onChange: customerOrderScreenController.collectionAddressThreeOnChange),
                                  SizedBox(height: 20,),
                                  SquaredInput(label: "Collection Postcode", value: customerOrderScreenController.model.collectionPostcode, icon: Icons.local_post_office_outlined, onChange: customerOrderScreenController.collectionPostcodeOnChange),
                                  SizedBox(height: 20,),
                                  SquaredInput(label: "Collection Phone number", value: customerOrderScreenController.model.collectionPhoneNumber, icon: Icons.phone_outlined, keyboardType: TextInputType.phone, onChange: customerOrderScreenController.collectionPhoneNumberOnChange),
                                  SizedBox(height: 20,),
                                ],
                              )
                            )

                          :

                            SizedBox(height: 0, width: 0,),
                        
                        Divider(height: 1,),
                        SizedBox(height: 10, width: 0,),
                        Text("Delivery Details", style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 20, width: 0,),
                        Expanded(
                          child: Column(
                            children: [
                              SquaredInput(label: "Delivery Name", value: customerOrderScreenController.model.deliveryName, icon: Icons.person_outline_outlined, onChange: customerOrderScreenController.deliveryNameOnChange),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Delivery Email", value: customerOrderScreenController.model.deliveryEmail, icon: Icons.alternate_email_outlined, keyboardType: TextInputType.emailAddress, onChange: customerOrderScreenController.deliveryEmailOnChange),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Delivery Address line 1", value: customerOrderScreenController.model.deliveryAddressLine1, icon: Icons.local_post_office_outlined, onChange: customerOrderScreenController.deliveryAddressOneOnChange),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Delivery Address line 2", value: customerOrderScreenController.model.deliveryAddressLine2, icon: Icons.local_post_office_outlined, onChange: customerOrderScreenController.deliveryAddressTwoOnChange),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Delivery Address line 3", value: customerOrderScreenController.model.deliveryAddressLine3, icon: Icons.local_post_office_outlined, onChange: customerOrderScreenController.deliveryAddressThreeOnChange),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Delivery Postcode", value: customerOrderScreenController.model.deliveryPostcode, icon: Icons.local_post_office_outlined, onChange: customerOrderScreenController.deliveryPostcodeOnChange),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Delivery Phone number", value: customerOrderScreenController.model.deliveryPhoneNumber, icon: Icons.phone_outlined, keyboardType: TextInputType.phone, onChange: customerOrderScreenController.deliveryPhoneNumberOnChange),
                              SizedBox(height: 20,),
                            ],
                          )
                        ),

                        Material(
                          color: Theme.of(context).colorScheme.secondary,
                          shadowColor: Color(0x00000000),                                
                          borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                          child: MaterialButton(
                            padding: EdgeInsets.all(0),
                            onPressed: customerOrderScreenController.onAddToBasketTap,
                            child: Text("Add to basket", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),                           
                          ),
                        ),

                        SizedBox(height: 20,),
                    
                        Divider(height: 1,),
                        SizedBox(height: 30,),

                        Text("Basket", style: Theme.of(context).textTheme.titleMedium),
                        // OrderCard(order: {}),

                      ]
                    ),
                  ),
                  
                
              //   :

              //     Center(
              //       child: Text("Error loading profile")
              //     )

              // :

              //   Center(
              //     child: CircularProgressIndicator()
              //   )
              
            ],
          ),
        ),

      ),
    );
  }
}
