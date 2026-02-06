import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart' show showToastWidget;
import 'package:high_flyers_app/components/call_admin_dialog_box.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/current_stop_model.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CurrentStopController {

  late CurrentStopModel model;
  final void Function() updateState;
  final void Function(Map<String, dynamic>) updateMapMarker;
  

  CurrentStopController({required this.updateState, required this.updateMapMarker, required stop}){
    model = CurrentStopModel(stop: stop);
  }

  void navigate(Map<String, dynamic>? stop, BuildContext context) async{

    if(stop == null){
      showToastWidget(ToastNotification(message: "Error launching navigation -  stop is null", isError: true));
      return;
    }

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

    final MapType? mapPreference = await model.getMapPreference();

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


  static Future<void> launchMap(stop, mapType) async{
    
    final coordinates = stop['coordinates'];

    // await MapLauncher.showMarker(
    //   mapType: mapType,
    //   coords: Coords(coordinates['lat'], coordinates['lng']),
    //   title: "Order: ${stop['orderData']['ID']} ${stop['stopType']}",
    //   description: "${stop['stopData']['address1']}, ${stop['stopData']['address2']}, ${stop['stopData']['address3']}, ${stop['stopData']['postcode']},"
    // );

    await MapLauncher.showDirections(
      mapType: mapType,
      destination: Coords(coordinates['lat'], coordinates['lng']),
      destinationTitle: "Order: ${stop['orderData']['ID']} ${stop['stopType']}", //Often blocked and uses "Drive" as title. Assumes currently driving in this mode so has restrictions
    );

  }

  Function(BuildContext, CurrentStopModel, Map<String,dynamic>) showAvailableMaps = (context, model, stop){

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


  void showStopForm(){

    model.showStopForm = true;
    updateState();

  }

  void hideStopFrom(){

    model.showStopForm = false;
    print("model.showStopForm: ${model.showStopForm}");
    updateState();

  }

  Future<void> skipStop(controller, BuildContext context) async {
    
    if(context.mounted){
      controller.loading();
    }


    //updates document in database
    final skippedStopSuccessfully = await model.skipStop();

    if(!skippedStopSuccessfully){

      showToastWidget(ToastNotification(message: model.errorMessage, isError: true));

      if(context.mounted){
        controller.reset();
      }

      return;
    }

    await Future.delayed(Duration(seconds: 1),() {  });


    updateMapMarkerNextStop();
    model.shouldAutoShowForm();
    updateState();
    
    if(context.mounted){
      controller.reset();
    }

    showToastWidget(ToastNotification(message: "Successfully skipped stop", isError: false));

  }

  
  Future<void> callCustomer(controller, context) async {

    controller.loading();

    final bool calledCustomerSuccessfully = await model.callCustomer();

    updateState();
    controller.reset();

    if(!calledCustomerSuccessfully){
      showToastWidget(ToastNotification(message: "Error calling customer", isError: true));
    }

  }

  void updateMapMarkerNextStop(){
    if(model.stop != null){
      updateMapMarker(model.stop!);
    }
  }

}