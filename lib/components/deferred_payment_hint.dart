import 'package:flutter/material.dart';

class DeferredPaymentHint extends StatelessWidget {

  final String hintType;

  const DeferredPaymentHint({super.key, required this.hintType});

  @override
  Widget build(BuildContext context) {

    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5)
        ),
        child: hintType == "Early" ? 

            Text("Payment isnt needed as it was paid on collection when delivery was stated", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15), maxLines: 10,)

          :

            Text("Payment is needed to be collected as it wasnt paid on collection as stated", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15), maxLines: 10,)
      )
    );
  }
}