import 'package:high_flyers_app/models/driver_model.dart';

class DriverHomeScreenController {
  final DriverModel model = DriverModel();

  DriverHomeScreenController() {
    final driverInitialised = model.initialiseDriver();
    if (!driverInitialised) {
      //show error loading notification
    }
  }
}
