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

                      customerOrderScreenController.model.orders.isNotEmpty ? 

                          Transform.translate(
                            offset: Offset(2, -12),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red
                              ),
                              child: Text("1", style: TextStyle(color: Colors.white),),
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
                        Text("Order Details", style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 10, width: 0,),
                        Expanded(
                          child: Column(
                            children: [
                              DropdownButtonFormField(
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                                decoration: InputDecoration(
                                  icon: Icon(Icons.pets),
                                  label: Text("Animal Type"),
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
                                onChanged: (value){},
                                items:  customerOrderScreenController.model.birdSpeciesSet.toList().map((bird) {
                                            return DropdownMenuItem(
                                              value: bird,
                                              child: Text(bird),
                                            );
                                          },
                                        ).toList()
                              ),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Quantity", value: customerOrderScreenController.model.quantity, icon: Icons.numbers_outlined, onChange: customerOrderScreenController.quantityOnChange, keyboardType: TextInputType.number,),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Code", value: customerOrderScreenController.model.code, icon: Icons.redeem_outlined, onChange: customerOrderScreenController.codeOnChange),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Boxes", value: customerOrderScreenController.model.boxes, icon: Icons.card_travel_outlined, onChange: customerOrderScreenController.boxesOnChange, keyboardType: TextInputType.number,),
                              SizedBox(height: 20,),
                              SquaredInput(label: "Email", value: customerOrderScreenController.model.email, icon: Icons.alternate_email_outlined, onChange: customerOrderScreenController.emailOnChange, keyboardType: TextInputType.emailAddress,),
                              SizedBox(height: 20,),
                            ]
                          )
                        ),

                        SizedBox(height: 10, width: 0,),
                        Divider(height: 1,),
                        SizedBox(height: 10, width: 0,),
                        
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

                       
                    
                        Divider(height: 1,),
                        SizedBox(height: 10,),
                        Text("Payment Details", style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 10,),

                        DropdownButtonFormField(
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                          decoration: InputDecoration(
                            icon: Icon(Icons.payment_outlined),
                            label: Text("Collected Payment"),
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
                          onChanged: (value){},
                          items: [
                            DropdownMenuItem(
                              value: true,
                              child: Text('Yes'),
                            ),
                            DropdownMenuItem(
                              value: false,
                              child: Text('No'),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        TextField(
                          maxLines: null,
                          decoration: InputDecoration(
                            icon: Icon(Icons.message_outlined),
                            label: Text("Notes"),
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
                          keyboardType: TextInputType.text,
                          onChanged: (input){},
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                        ),

                        SizedBox(height: 20,),


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
