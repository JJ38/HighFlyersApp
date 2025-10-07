import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/squared_input.dart';
import 'package:high_flyers_app/controllers/admin_add_order_screen_controller.dart';

class AdminOrderForm extends StatefulWidget {

  final AdminAddOrderScreenController adminAddOrderScreenController;

  const AdminOrderForm({super.key, required this.adminAddOrderScreenController});

  @override
  State<AdminOrderForm> createState() => _AdminOrderFormState();
}

class _AdminOrderFormState extends State<AdminOrderForm> {

  late AdminAddOrderScreenController adminAddOrderScreenController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminAddOrderScreenController = widget.adminAddOrderScreenController;
    adminAddOrderScreenController.loadForm();

  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [  
              Text("Order Details", style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 10, width: 0,),
              DropdownButtonFormField<String?>(
                // key: animalFieldKey,
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
                // value: adminAddOrderScreenController.model.getAnimalType(),  
                hint: const Text("Select Animal"),                    
                onChanged: (value){adminAddOrderScreenController.animalTypeOnChange(value);},
                items:  adminAddOrderScreenController.model.birdSpeciesSet.map((bird) =>
                          DropdownMenuItem<String?>(
                            value: bird,
                            child: Text(bird),
                          ),
                        ).toList(),
              ),
              SizedBox(height: 20,),
              SquaredInput(label: "Quantity", value: adminAddOrderScreenController.model.quantity, icon: Icons.numbers_outlined, onChange: adminAddOrderScreenController.quantityOnChange, keyboardType: TextInputType.number,),
              SizedBox(height: 20,),
              SquaredInput(label: "Code", value: adminAddOrderScreenController.model.code, icon: Icons.redeem_outlined, onChange: adminAddOrderScreenController.codeOnChange),
              SizedBox(height: 20,),
              SquaredInput(label: "Boxes", value: adminAddOrderScreenController.model.boxes, icon: Icons.card_travel_outlined, onChange: adminAddOrderScreenController.boxesOnChange, keyboardType: TextInputType.number,),
              SizedBox(height: 20,),
              SquaredInput(label: "Email", value: adminAddOrderScreenController.model.email, icon: Icons.alternate_email_outlined, onChange: adminAddOrderScreenController.emailOnChange, keyboardType: TextInputType.emailAddress,),
              SizedBox(height: 20,),
                  
              SizedBox(height: 10, width: 0,),
              Divider(height: 1,),
              SizedBox(height: 10, width: 0,),

              Text("Collection Details", style: Theme.of(context).textTheme.titleMedium),
              
              SizedBox(height: 20, width: 0,),

              SquaredInput(label: "Collection Name", value: adminAddOrderScreenController.model.collectionName, icon: Icons.person_outline_outlined, onChange: adminAddOrderScreenController.collectionNameOnChange),
              SizedBox(height: 20,),
              SquaredInput(label: "Collection Address line 1", value: adminAddOrderScreenController.model.collectionAddressLine1, icon: Icons.local_post_office_outlined, onChange: adminAddOrderScreenController.collectionAddressOneOnChange),
              SizedBox(height: 20,),
              SquaredInput(label: "Collection Address line 2", value: adminAddOrderScreenController.model.collectionAddressLine2, icon: Icons.local_post_office_outlined, onChange: adminAddOrderScreenController.collectionAddressTwoOnChange),
              SizedBox(height: 20,),
              SquaredInput(label: "Collection Address line 3", value: adminAddOrderScreenController.model.collectionAddressLine3, icon: Icons.local_post_office_outlined, onChange: adminAddOrderScreenController.collectionAddressThreeOnChange),
              SizedBox(height: 20,),
              SquaredInput(label: "Collection Postcode", value: adminAddOrderScreenController.model.collectionPostcode, icon: Icons.local_post_office_outlined, onChange: adminAddOrderScreenController.collectionPostcodeOnChange),
              SizedBox(height: 20,),
              SquaredInput(label: "Collection Phone number", value: adminAddOrderScreenController.model.collectionPhoneNumber, icon: Icons.phone_outlined, keyboardType: TextInputType.phone, onChange: adminAddOrderScreenController.collectionPhoneNumberOnChange),
              SizedBox(height: 20,),
                              
              Divider(height: 1,),
              SizedBox(height: 10, width: 0,),
              Text("Delivery Details", style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 20, width: 0,),
              
              SquaredInput(label: "Delivery Name", value: adminAddOrderScreenController.model.deliveryName, icon: Icons.person_outline_outlined, onChange: adminAddOrderScreenController.deliveryNameOnChange),
              SizedBox(height: 20,),                          
              SquaredInput(label: "Delivery Address line 1", value: adminAddOrderScreenController.model.deliveryAddressLine1, icon: Icons.local_post_office_outlined, onChange: adminAddOrderScreenController.deliveryAddressOneOnChange),
              SizedBox(height: 20,),
              SquaredInput(label: "Delivery Address line 2", value: adminAddOrderScreenController.model.deliveryAddressLine2, icon: Icons.local_post_office_outlined, onChange: adminAddOrderScreenController.deliveryAddressTwoOnChange),
              SizedBox(height: 20,),
              SquaredInput(label: "Delivery Address line 3", value: adminAddOrderScreenController.model.deliveryAddressLine3, icon: Icons.local_post_office_outlined, onChange: adminAddOrderScreenController.deliveryAddressThreeOnChange),
              SizedBox(height: 20,),
              SquaredInput(label: "Delivery Postcode", value: adminAddOrderScreenController.model.deliveryPostcode, icon: Icons.local_post_office_outlined, onChange: adminAddOrderScreenController.deliveryPostcodeOnChange),
              SizedBox(height: 20,),
              SquaredInput(label: "Delivery Phone number", value: adminAddOrderScreenController.model.deliveryPhoneNumber, icon: Icons.phone_outlined, keyboardType: TextInputType.phone, onChange: adminAddOrderScreenController.deliveryPhoneNumberOnChange),
              SizedBox(height: 20,),
            
              
              Divider(height: 1,),
              SizedBox(height: 10,),
              Text("Payment Details", style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 10,),
              DropdownButtonFormField<String?>(
                // key: paymentFieldKey,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                decoration: InputDecoration(
                  icon: Icon(Icons.payment_outlined),
                  label: Text("Payment"),
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
                hint: const Text("Select payment"),
                // value: adminAddOrderScreenController.model.getPayment(),
                onChanged: (value){adminAddOrderScreenController.paymentOnChange(value);},
                items: [
                  DropdownMenuItem(
                    value: 'Collection',
                    child: Text('Collection'),
                  ),
                  DropdownMenuItem(
                    value: 'Delivery',
                    child: Text('Delivery'),
                  ),
                  DropdownMenuItem(
                    value: 'Account',
                    child: Text('Account'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: TextEditingController(text: adminAddOrderScreenController.model.message),
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
                onChanged: (input){adminAddOrderScreenController.messageOnChange(input);},
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
              ),
              SizedBox(height: 20,), 

              adminAddOrderScreenController.model.isSubmitting ? 

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
                          onPressed: adminAddOrderScreenController.submitOrder,
                          child: Text("Add Order", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),                           
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,)
            ]
          );
  }
}