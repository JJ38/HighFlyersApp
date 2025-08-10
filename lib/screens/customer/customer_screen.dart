import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/customer_screen_controller.dart';
import 'package:high_flyers_app/screens/customer/customer_order_screen.dart';
import 'package:high_flyers_app/screens/customer/customer_profile_screen.dart';

class CustomerScreen extends StatefulWidget {
  static String id = "Customer Screen";

  final CustomerScreenController controller;

  // final LoginScreenController controller;

  const CustomerScreen({super.key, required this.controller});

  //declare model here

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  var currentPageIndex = 0;

  List<Widget> screens = [CustomerOrderScreen(), CustomerProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Order"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile")
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
