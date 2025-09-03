import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/driver_settings_screen_model.dart';

class DriverSettingsScreenController {

  DriverSettingsScreenModel model = DriverSettingsScreenModel();

  DriverSettingsScreenController();

  void onNavigationPreferenceSelect(Object? selectedPreference){
    print(selectedPreference);
  }

  Future<void> getNavigationPreferences() async {

    final succesfullyLoaded = await model.getNavigationPreferences();

    model.loaded = true;

    if(!succesfullyLoaded){
    
      return;

    }

    model.successfullyLoaded = true;

  } 

  void setNavigationPreference(String? mapName) async {
  
    final setNavigationPreferenceSuccessfully = await model.setNavigationPreference(mapName);

    if(!setNavigationPreferenceSuccessfully){

      showToastWidget(ToastNotification(message: "Error setting navigation preference", isError: true));
      return;

    }

    showToastWidget(ToastNotification(message: "Successfully updated navigation preference", isError: false));

  }

}