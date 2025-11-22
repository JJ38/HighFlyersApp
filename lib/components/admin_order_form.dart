import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/squared_input.dart';
import 'package:high_flyers_app/controllers/order_controller_abstract.dart';

class AdminOrderForm extends StatefulWidget {

  final OrderController orderController;
  final String buttonText;
  final bool Function()? isDeletingHook;

  const AdminOrderForm({super.key, required this.orderController, required this.buttonText, this.isDeletingHook});

  @override
  State<AdminOrderForm> createState() => _AdminOrderFormState();
}

class _AdminOrderFormState extends State<AdminOrderForm> {

  late OrderController orderController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderController = widget.orderController;

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
            value: orderController.model.animalType,  
            hint: const Text("Select Animal"),                    
            onChanged: (value){orderController.animalTypeOnChange(value);},
            items:  orderController.model.birdSpeciesSet.map((bird) =>
                      DropdownMenuItem<String?>(
                        value: bird,
                        child: Text(bird),
                      ),
                    ).toList(),
          ),
          SizedBox(height: 20,),
          SquaredInput(label: "Quantity", value: orderController.model.quantity, icon: Icons.numbers_outlined, onChange: orderController.quantityOnChange, keyboardType: TextInputType.number,),
          SizedBox(height: 20,),
          SquaredInput(label: "Code", value: orderController.model.code, icon: Icons.redeem_outlined, onChange: orderController.codeOnChange),
          SizedBox(height: 20,),
          SquaredInput(label: "Boxes", value: orderController.model.boxes, icon: Icons.card_travel_outlined, onChange: orderController.boxesOnChange, keyboardType: TextInputType.number,),
          SizedBox(height: 20,),
          SquaredInput(label: "Email", value: orderController.model.email, icon: Icons.alternate_email_outlined, onChange: orderController.emailOnChange, keyboardType: TextInputType.emailAddress,),
          SizedBox(height: 20,),

          DropdownButtonFormField<String?>(
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.clip),
            decoration: InputDecoration(
              icon: Icon(Icons.account_balance_outlined),
              label: Text("Account"),
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
            value: orderController.model.account,  
            hint: Text("Select Account", overflow: TextOverflow.clip,),                    
            onChanged: (value){orderController.accountOnChange(value);},
            items:  orderController.model.customerAccounts.entries.map((account) =>
                      DropdownMenuItem<String?>(
                        value: account.key,
                        child: Text(account.value, overflow: TextOverflow.clip),
                      ),
                    ).toList(),
          ),

          SizedBox(height: 20,),
          SquaredInput(label: "Delivery Week", value: orderController.model.deliveryWeek, icon: Icons.calendar_month, onChange: orderController.deliveryWeekOnChange, keyboardType: TextInputType.number,),
          SizedBox(height: 20,),
              
          SizedBox(height: 10, width: 0,),
          Divider(height: 1,),
          SizedBox(height: 10, width: 0,),

          Text("Collection Details", style: Theme.of(context).textTheme.titleMedium),
          
          SizedBox(height: 20, width: 0,),

          SquaredInput(label: "Collection Name", value: orderController.model.collectionName, icon: Icons.person_outline_outlined, onChange: orderController.collectionNameOnChange),
          SizedBox(height: 20,),
          SquaredInput(label: "Collection Address line 1", value: orderController.model.collectionAddressLine1, icon: Icons.local_post_office_outlined, onChange: orderController.collectionAddressOneOnChange),
          SizedBox(height: 20,),
          SquaredInput(label: "Collection Address line 2", value: orderController.model.collectionAddressLine2, icon: Icons.local_post_office_outlined, onChange: orderController.collectionAddressTwoOnChange),
          SizedBox(height: 20,),
          SquaredInput(label: "Collection Address line 3", value: orderController.model.collectionAddressLine3, icon: Icons.local_post_office_outlined, onChange: orderController.collectionAddressThreeOnChange),
          SizedBox(height: 20,),
          SquaredInput(label: "Collection Postcode", value: orderController.model.collectionPostcode, icon: Icons.local_post_office_outlined, onChange: orderController.collectionPostcodeOnChange),
          SizedBox(height: 20,),
          SquaredInput(label: "Collection Phone number", value: orderController.model.collectionPhoneNumber, icon: Icons.phone_outlined, keyboardType: TextInputType.phone, onChange: orderController.collectionPhoneNumberOnChange),
          SizedBox(height: 20,),
                          
          Divider(height: 1,),
          SizedBox(height: 10, width: 0,),
          Text("Delivery Details", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 20, width: 0,),
          
          SquaredInput(label: "Delivery Name", value: orderController.model.deliveryName, icon: Icons.person_outline_outlined, onChange: orderController.deliveryNameOnChange),
          SizedBox(height: 20,),                          
          SquaredInput(label: "Delivery Address line 1", value: orderController.model.deliveryAddressLine1, icon: Icons.local_post_office_outlined, onChange: orderController.deliveryAddressOneOnChange),
          SizedBox(height: 20,),
          SquaredInput(label: "Delivery Address line 2", value: orderController.model.deliveryAddressLine2, icon: Icons.local_post_office_outlined, onChange: orderController.deliveryAddressTwoOnChange),
          SizedBox(height: 20,),
          SquaredInput(label: "Delivery Address line 3", value: orderController.model.deliveryAddressLine3, icon: Icons.local_post_office_outlined, onChange: orderController.deliveryAddressThreeOnChange),
          SizedBox(height: 20,),
          SquaredInput(label: "Delivery Postcode", value: orderController.model.deliveryPostcode, icon: Icons.local_post_office_outlined, onChange: orderController.deliveryPostcodeOnChange),
          SizedBox(height: 20,),
          SquaredInput(label: "Delivery Phone number", value: orderController.model.deliveryPhoneNumber, icon: Icons.phone_outlined, keyboardType: TextInputType.phone, onChange: orderController.deliveryPhoneNumberOnChange),
          SizedBox(height: 20,),
        
          
          Divider(height: 1,),
          SizedBox(height: 10,),
          Text("Payment Details", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 10,),
          DropdownButtonFormField<String?>(
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
            value: orderController.model.payment,
            onChanged: (value){orderController.paymentOnChange(value);},
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
          SquaredInput(label: "Price", value: orderController.model.price, icon: Icons.currency_pound_outlined, onChange: orderController.priceOnChange, keyboardType: TextInputType.number,),
          SizedBox(height: 20,),
          TextField(
            controller: TextEditingController(text: orderController.model.message),
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
            onChanged: (input){orderController.messageOnChange(input);},
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
          ),
          SizedBox(height: 20,), 

          orderController.model.isSubmitting ? 

              Center(
                child: CircularProgressIndicator(),
              )

            :

              widget.isDeletingHook != null && widget.isDeletingHook!() ? 

                  SizedBox(height: 0,)

                :

                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      child: Material(              
                        color: Theme.of(context).colorScheme.secondary,
                        shadowColor: Color(0x00000000),                                
                        borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                        child: MaterialButton(
                          onPressed: (){ orderController.submitOrder(context); },
                          child: Text(widget.buttonText, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),                           
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,)
        ]
      );

  }
}