import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/input_pill.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: screenWidth * 0.05), 
        child: SafeArea(
          child: 
            Center(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Text("Your Profile", style: Theme.of(context).textTheme.titleLarge),
                  InputPill(text: "Email", iconData: Icons.person_outline, keyboardType: TextInputType.emailAddress, onChange: (input){}),
                  InputPill(text: "Address line 1", iconData: Icons.local_post_office_outlined, onChange: (input){}),
                  InputPill(text: "Address line 2", iconData: Icons.local_post_office_outlined, onChange: (input){}),
                  InputPill(text: "Address line 3", iconData: Icons.local_post_office_outlined, onChange: (input){}),
                  InputPill(text: "Postcode", iconData: Icons.local_post_office_outlined, onChange: (input){}),
                  InputPill(text: "Phone number", iconData: Icons.phone_outlined, keyboardType: TextInputType.phone, onChange: (input){}),

                ],
              ),
            )
        ),
      )
    );
  }
}
