import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/screens/admin/admin_label_runs_screen.dart';
import 'package:high_flyers_app/screens/admin/admin_manage_orders_screen.dart';
import 'package:high_flyers_app/screens/admin/admin_manage_users_screen.dart';
import 'package:high_flyers_app/screens/admin/admin_settings_screen.dart';

class AdminScreen extends StatefulWidget {
  static String id = "Admin Screen";

  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  int currentPageIndex = 0;
  late final String role;
  bool hasLoaded = false;

  List<Widget> adminScreens = [AdminManageOrdersScreen(), AdminLabelRunsScreen(), AdminManageUsersScreen(), AdminSettingsScreen()];
  List<Widget> staffScreens = [AdminManageOrdersScreen(), AdminLabelRunsScreen(), AdminSettingsScreen()];
  List<Widget> restrictedStaffScreens = [AdminLabelRunsScreen(), AdminSettingsScreen()];


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
      debugPrint('UID: ${user.uid}');
      debugPrint('Email: ${user.email}');
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
              body: adminScreens[currentPageIndex],
              bottomNavigationBar: NavigationBar(
                destinations: [
                  NavigationDestination(icon: Icon(Icons.receipt), label: "Orders"),
                  NavigationDestination(icon: Icon(Icons.discount), label: "Label Runs"),
                  NavigationDestination(icon: Icon(Icons.verified_user_sharp), label: "Users"),
                  NavigationDestination(icon: Icon(Icons.settings), label: "Settings")
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

            role == "staff" ? 

                Scaffold(
                  body: staffScreens[currentPageIndex],
                  bottomNavigationBar: NavigationBar(
                    destinations: [
                      NavigationDestination(icon: Icon(Icons.receipt), label: "Orders"),
                      NavigationDestination(icon: Icon(Icons.discount), label: "Label Runs"),
                      NavigationDestination(icon: Icon(Icons.settings), label: "Settings")
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
                  body: restrictedStaffScreens[currentPageIndex],
                  bottomNavigationBar: NavigationBar(
                    destinations: [
                      NavigationDestination(icon: Icon(Icons.discount), label: "Label Runs"),
                      NavigationDestination(icon: Icon(Icons.settings), label: "Settings")
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

        Center(
          child: CircularProgressIndicator()
        );

  }
}
