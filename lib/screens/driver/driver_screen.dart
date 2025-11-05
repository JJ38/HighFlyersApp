import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/driver_screen_controller.dart';
import 'package:high_flyers_app/screens/driver/driver_home_screen.dart';
import 'package:high_flyers_app/screens/driver/driver_settings_screen.dart';

class DriverScreen extends StatefulWidget {
  static String id = 'Driver Screen';

  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {

  late final DriverScreenController driverScreenController;
  int currentPageIndex = 0;

  List<Widget> screens = [DriverHomeScreen(), DriverSettingsScreen()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    driverScreenController = DriverScreenController();
    driverScreenController.initialisedLocationTracking();

  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: screens[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"), 
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
    );
  }
}
