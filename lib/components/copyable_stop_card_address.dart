import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableStopCardAddress extends StatelessWidget {
  final String address1;
  final String address2;
  final String address3;
  final String postcode;

  const CopyableStopCardAddress({
    super.key,
    required this.address1,
    required this.address2,
    required this.address3,
    required this.postcode,
  });

  String get fullAddress =>
      "${address1.trim()}\n${address2.trim()}, ${address3.trim()}\n${postcode.trim()}";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Clipboard.setData(ClipboardData(text: fullAddress));

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Address copied")),
        // );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address1.trim(),
            style: textTheme.titleSmall,
            maxLines: 10,
          ),

          Row(
            children: [
              Expanded(
                child: Text(
                  "${address2.trim()}, ${address3.trim()}",
                  style: textTheme.labelSmall,
                  maxLines: 100,
                ),
              ),
            ],
          ),

          Text(
            postcode.trim(),
            style: textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
