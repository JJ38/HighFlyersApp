import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/auth_controller.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

 @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: screenWidth * 0.05),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenWidth * 0.05,),
              Text("Settings", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 20),
              Text("Account", style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 10),
              Center(
                child: Material(
                  color: const Color.fromARGB(255, 227, 24, 10),
                  shadowColor: Colors.red,                                
                  borderRadius: BorderRadius.all(Radius.circular(8)),  
                                                      
                  child: MaterialButton(
                    onPressed: AuthController.signOut,
                    minWidth: screenWidth * 0.9,
                    height: screenWidth * 0.1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text("Sign out", style: TextStyle(color: Colors.white)),
                        ),
                        Icon(Icons.logout, color: Colors.white)
                      ]
                    ),
                  ),
                ),
              ),  
            ],          
          ),
        ),
      )
    );
  }
}