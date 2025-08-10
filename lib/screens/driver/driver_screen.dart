import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/driver_screen_controller.dart';
import 'package:high_flyers_app/screens/driver/driver_home_screen.dart';
import 'package:high_flyers_app/screens/driver/driver_settings_screen.dart';

class DriverScreen extends StatefulWidget {
  static String id = 'Driver Screen';

  final DriverScreenController controller;

  const DriverScreen({super.key, required this.controller});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  var currentPageIndex = 0;

  List<Widget> screens = [DriverHomeScreen(), DriverSettingsScreen()];

  @override
  void initState() {
    super.initState();
    widget.controller.model.fetchDriverDoc();
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
