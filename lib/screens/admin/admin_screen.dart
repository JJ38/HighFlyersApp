import 'package:firebase_auth/firebase_auth.dart';
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
  late final String role;
  bool hasLoaded = false;

  List<Widget> screens = [AdminManageOrdersScreen(), AdminManageUsersScreen()];

  @override
  void initState(){
    super.initState();
    getRole();
  
  }

  Future<void> getRole() async{

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Not signed in
      return;
    } else {
      print('UID: ${user.uid}');
      print('Email: ${user.email}');
    }

    final jwt = await user.getIdTokenResult();
    role = jwt.claims?['role']; 

    setState(() {
      hasLoaded = true;
    });
    
  }

  @override
  Widget build(BuildContext context) {

    return

    hasLoaded ? 

        role == "admin" ? 

            Scaffold(
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
            )

          :

            Scaffold(
              body: screens[currentPageIndex],
            )
      :

        Center(
          child: CircularProgressIndicator()
        );

  }
}
