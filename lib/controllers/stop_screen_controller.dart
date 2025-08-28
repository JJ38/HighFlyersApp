import 'package:flutter_styled_toast/flutter_styled_toast.dart' show showToastWidget;
import 'package:high_flyers_app/components/toast_notification.dart';

class StopScreenController {

  void confirmOrder(controller){

    controller.loading();

    if(false){
      controller.success();
    }

    showToastWidget(ToastNotification(message: "Error confirming delivery", isError: true));
    controller.reset();

  }

}