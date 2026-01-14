import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:high_flyers_app/controllers/auth_controller.dart';
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
  String? test;

  @override
  void initState() {
    super.initState();
    driverSettingsScreenController = DriverSettingsScreenController();
    initialiseSettings();
  }

  void initialiseSettings() async{

    await driverSettingsScreenController.getNavigationPreferences();
    await driverSettingsScreenController.model.getAvailableNavigationApps();
    
    if(mounted){
      setState(() {
        
      });
    }
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
              SizedBox(height: screenWidth * 0.05,),
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
                            SizedBox(height: 10),
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
                            ),
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
