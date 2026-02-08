import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:high_flyers_app/components/toast_notification.dart';

class CopyableAddress extends StatelessWidget {
  final String stopType;
  final String address1;
  final String address2;
  final String address3;
  final String postcode;

  const CopyableAddress({
    super.key,
    required this.stopType,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.postcode,
  });

  String get fullAddress =>
      "$address1\n$address2, $address3\n$postcode";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Clipboard.setData(ClipboardData(text: fullAddress));

        showToastWidget(ToastNotification(message: "Copied address to clipboard", isError: false));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Icon(Icons.location_on),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${stopType[0].toUpperCase()}${stopType.substring(1)} Address",
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),               
                ),
                Text(
                  address1,
                  style: textTheme.titleSmall?.copyWith(fontSize: 18),
                  maxLines: 100
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "$address2, $address3",
                        style: textTheme.titleSmall?.copyWith(fontSize: 18),
                        maxLines: 100,
                      ),
                    ),
                  ],
                ),
                Text(
                  postcode,
                  style: textTheme.titleSmall?.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
