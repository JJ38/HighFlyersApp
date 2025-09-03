import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:high_flyers_app/controllers/driver_settings_screen_controller.dart';
import 'package:map_launcher/map_launcher.dart';


class DriverSettingsScreen extends StatefulWidget {

  const DriverSettingsScreen({super.key});

  @override
  State<DriverSettingsScreen> createState() => _DriverSettingsScreenState();
}

class _DriverSettingsScreenState extends State<DriverSettingsScreen> {

  late DriverSettingsScreenController driverSettingsScreenController;
  bool loaded = true;
  bool successFullyLoaded = true;

  @override
  void initState() {
    super.initState();
    driverSettingsScreenController = DriverSettingsScreenController();
    initialiseSettings();
  }

  void initialiseSettings() async{
    await driverSettingsScreenController.getNavigationPreferences();
    await driverSettingsScreenController.model.getAvailableNavigationApps();
    print("update state");
    setState(() {
      
    });
  }

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
              Text("Settings", style: Theme.of(context).textTheme.titleLarge),

              ...driverSettingsScreenController.model.loaded ?

                [
                  ...driverSettingsScreenController.model.successfullyLoaded ? 

                    [
                      Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(screenWidth * 0.02, screenWidth * 0.05, screenWidth * 0.02, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Preferences", style: Theme.of(context).textTheme.titleMedium),
                            SizedBox(height: 20),
                            DropdownButtonFormField(
                              value: driverSettingsScreenController.model.navigationPreference,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                              decoration: InputDecoration(
                                label: Text("Navigation App"),
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
                              onChanged: (value) {driverSettingsScreenController.onNavigationPreferenceSelect(value);},
                              items: driverSettingsScreenController.model.availableMaps.map((AvailableMap map) {
                                    return DropdownMenuItem<String>(
                                        value: map.mapName,
                                        child: Row(
                                          children:[
                                            SvgPicture.asset(
                                              map.icon,
                                              height: 40.0,
                                              width: 40.0,
                                            ),
                                            SizedBox(width: 10,),
                                            Text(map.mapName),
                                          ] 
                                        ),
                                        onTap: () {
                                          driverSettingsScreenController.setNavigationPreference(map.mapName);
                                        },
                                      );
                                    }
                                ).toList(),
                            )
                          ]
                        ),       
                      ),
                    ]
                  
                  :

                    [
                      Center(child: Text("Error loading settings")),
                    ]

                ]

              :
                
                [
                  Center(child: CircularProgressIndicator()),
                ]
            ]
          ),
        ),
      )
    );
  }
}
