import 'package:flutter_styled_toast/flutter_styled_toast.dart' show showToastWidget;
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:map_launcher/map_launcher.dart';

class StopScreenController {

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

  void confirmOrder(controller){

    controller.loading();

    if(false){
      controller.success();
    }

    showToastWidget(ToastNotification(message: "Error confirming delivery", isError: true));
    controller.reset();

  }

  void closeStopForm(showStopForm, void Function(dynamic) setState){

    setState.call(showStopForm);

  }

}