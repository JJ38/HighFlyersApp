import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart' show showToastWidget;
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/stop_screen_model.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StopScreenController {

  StopScreenModel model = StopScreenModel();
  final void Function() updateState;

  StopScreenController({required this.updateState});

  void navigate(Map<String, dynamic> stop, BuildContext context) async{

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

    final MapType? mapPreference = await getMapPreference();

    if(mapPreference != null){
    
      if (await MapLauncher.isMapAvailable(mapPreference)) {
        await launchMap(stop, mapPreference);
        return;
      }

    }

    //show list of available maps to choose from as default isnt available
    final availableMaps = await MapLauncher.installedMaps;

    model.availableMaps = availableMaps;

    if(context.mounted){
      showAvailableMaps(context, model, stop);
    }

  }

  Future<MapType?> getMapPreference() async {

    try{

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? mapPreference = prefs.getString('maptype_preference');

      if(mapPreference == null){
        return null;
      }

      print(mapPreference);
      

      switch (mapPreference){

        case "Apple Maps":
          return MapType.apple;

        case "Google Maps":
          return MapType.google;

        case "Waze":
          return MapType.waze;

      }

      return null;

    }catch(e){
      print(e);
      return null;
    }

  }



  static Future<void> launchMap(stop, mapType) async{
    
    final coordinates = stop['coordinates'];

    await MapLauncher.showMarker(
      mapType: mapType,
      coords: Coords(coordinates['lat'], coordinates['lng']),
      title: "Order: ${stop['orderData']['ID']} ${stop['stopType']}",
      description: "${stop['stopData']['address1']}, ${stop['stopData']['address2']}, ${stop['stopData']['address3']}, ${stop['stopData']['postcode']},"
    );

  }

  Function(BuildContext, StopScreenModel, Map<String,dynamic>) showAvailableMaps = (context, model, stop){

    double screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: screenHeight * 0.25),
              child: Wrap(
                children: <Widget>[
                  for (var map in model.availableMaps!)
                    ListTile(
                      onTap: () => launchMap(stop, map.mapType),
                      title: Text(map.mapName, style: Theme.of(context).textTheme.titleSmall),
                      leading: SvgPicture.asset(
                        map.icon,
                        height: 40.0,
                        width: 40.0,
                      ),
                    )
                ],
              ),
            ),
        );
      },
    );
  };

  void confirmOrder(controller){

    controller.loading();

    if(false){
      controller.success();
    }

    showToastWidget(ToastNotification(message: "Error confirming delivery", isError: true));
    controller.reset();

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

  Future<void> completeStop(controller) async {

    controller.loading();

    //updates document in database
    final completedStopSuccessfully = await model.completeStop();

    if(!completedStopSuccessfully){

      showToastWidget(ToastNotification(message: "Error completing stop", isError: true));
      controller.reset();
      return;
    }

    await Future.delayed(Duration(seconds: 1),() {});
    
    model.showStopForm = false;
    updateState();
    controller.reset();
    showToastWidget(ToastNotification(message: "Successfully completed stop", isError: false));

  }

}