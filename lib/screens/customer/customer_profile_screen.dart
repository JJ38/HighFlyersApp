import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/squared_input.dart';
import 'package:high_flyers_app/components/stateful_button.dart';
import 'package:high_flyers_app/controllers/customer_profile_screen_controller.dart';
import 'package:high_flyers_app/models/validator.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {

  late CustomerProfileScreenController customerProfileScreenController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    customerProfileScreenController = CustomerProfileScreenController(updateState: updateState, validator: Validator());
    customerProfileScreenController.loadProfile();

  }

  void updateState(){
    
    if(mounted){
      setState(() {
      
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text("Your Profile", style: Theme.of(context).textTheme.titleLarge),

              customerProfileScreenController.model.isLoaded ? 

                customerProfileScreenController.model.isSuccessfullyLoaded ? 

                  Expanded(
                    child: ListView(
                      children: [
                        SquaredInput(label: "Name", value: customerProfileScreenController.model.name, icon: Icons.person_outline_outlined, onChange: customerProfileScreenController.nameOnChange),
                        SizedBox(height: 20,),
                        SquaredInput(label: "Email", value: customerProfileScreenController.model.email, icon: Icons.alternate_email_outlined, keyboardType: TextInputType.emailAddress, onChange: customerProfileScreenController.emailOnChange),
                        SizedBox(height: 20,),
                        SquaredInput(label: "Address line 1", value: customerProfileScreenController.model.addressLine1, icon: Icons.local_post_office_outlined, onChange: customerProfileScreenController.addressOneOnChange),
                        SizedBox(height: 20,),
                        SquaredInput(label: "Address line 2", value: customerProfileScreenController.model.addressLine2, icon: Icons.local_post_office_outlined, onChange: customerProfileScreenController.addressTwoOnChange),
                        SizedBox(height: 20,),
                        SquaredInput(label: "Address line 3", value: customerProfileScreenController.model.addressLine3, icon: Icons.local_post_office_outlined, onChange: customerProfileScreenController.addressThreeOnChange),
                        SizedBox(height: 20,),
                        SquaredInput(label: "Postcode", value: customerProfileScreenController.model.postcode, icon: Icons.local_post_office_outlined, onChange: customerProfileScreenController.postcodeOnChange),
                        SizedBox(height: 20,),
                        SquaredInput(label: "Phone number", value: customerProfileScreenController.model.phoneNumber, icon: Icons.phone_outlined, keyboardType: TextInputType.phone, onChange: customerProfileScreenController.phoneNumberOnChange),
                        SizedBox(height: 20,),
                        StatefulButton(controller: customerProfileScreenController)
                      ],
                    )
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
