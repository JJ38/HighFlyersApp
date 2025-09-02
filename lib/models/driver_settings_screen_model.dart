import 'package:map_launcher/map_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverSettingsScreenModel {

  String? navigationPreference;
  bool loaded = false;
  bool successfullyLoaded = false;
  List<AvailableMap> availableMaps = [];


  Future<bool> getNavigationPreferences() async {

    try{

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Read values, providing a default if the key does not exist
      navigationPreference = prefs.getString('maptype_preference');
      print(navigationPreference);

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

  Future<bool> setNavigationPreference(String? mapType) async {

    if(mapType == null){
      return false;
    }

    try{

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Set the values with a key and a value
      await prefs.setString('maptype_preference', mapType);

    }catch(e){
      print(e);
      return false;
    }

    return true;

  }

  Future<void> getAvailableNavigationApps() async {

    try{

      availableMaps = await MapLauncher.installedMaps;
      print(availableMaps);

    }catch(e){
      print(e);
      
    }
  }

}