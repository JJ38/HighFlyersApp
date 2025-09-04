import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';
import 'package:high_flyers_app/models/customer_profile_screen_model.dart';

class CustomerProfileScreenController {

  final CustomerProfileScreenModel model = CustomerProfileScreenModel();
  final void Function() updateState;

  CustomerProfileScreenController({required this.updateState});

  void loadProfile() async {
 
    final bool successfullyFetchedProfile = await model.fetchProfile();
    print(successfullyFetchedProfile);
    updateState();

    if(!successfullyFetchedProfile){
      showToastWidget(ToastNotification(message: "Failed to load profile", isError: true));
      return;
    }

  }

}