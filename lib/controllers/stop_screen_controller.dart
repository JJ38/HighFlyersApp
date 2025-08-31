import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart' show showToastWidget;
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/stop_screen_model.dart';
import 'package:map_launcher/map_launcher.dart';

class StopScreenController {

  StopScreenModel model = StopScreenModel();
  final void Function() updateState;

  StopScreenController({required this.updateState});

  void navigate(Map<String, dynamic> stop) async{

    final coordinates = stop['coordinates'];

    if(coordinates == null){
      showToastWidget(ToastNotification(message: "Error launching navigation", isError: true));
      return;
    }

    if(coordinates['lat'] == null || coordinates['lng'] == null){
      showToastWidget(ToastNotification(message: "Error launching navigation", isError: true));
      return;
    }

    // get preferred map to launch into to

    final availableMaps = await MapLauncher.installedMaps;
    print(availableMaps);

    if (await MapLauncher.isMapAvailable(MapType.google)) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(coordinates['lat'], coordinates['lng']),
        title: "Order: ${stop['orderData']['ID']} ${stop['stopType']}",
        description: "${stop['stopData']['address1']}, ${stop['stopData']['address2']}, ${stop['stopData']['address3']}, ${stop['stopData']['postcode']},"
      );
    }

  }

  void showStopForm(){

    model.showStopForm = true;
    updateState();

  }

  void hideStopFrom(){

    model.showStopForm = false;
    updateState();

  }

  Future<void> skipStop(controller) async {

    controller.loading();

    //updates document in database
    final skippedStopSuccessfully = await model.skipStop();

    if(!skippedStopSuccessfully){

      showToastWidget(ToastNotification(message: "Error skipping stop", isError: true));
      controller.reset();
      return;
    }

    await Future.delayed(Duration(seconds: 1),() {  });
    
    updateState();
    controller.reset();
    showToastWidget(ToastNotification(message: "Successfully skipped stop", isError: false));

  }

}