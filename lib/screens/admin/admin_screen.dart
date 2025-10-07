import 'package:flutter/material.dart';
import 'package:high_flyers_app/screens/admin/admin_manage_orders_screen.dart';
import 'package:high_flyers_app/screens/admin/admin_manage_users_screen.dart';

class AdminScreen extends StatefulWidget {
  static String id = "Admin Screen";

  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  var currentPageIndex = 0;

  List<Widget> screens = [AdminManageOrdersScreen(), AdminManageUsersScreen()];

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.receipt), label: "Orders"),
          NavigationDestination(
              icon: Icon(Icons.verified_user_sharp), label: "Users")
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
