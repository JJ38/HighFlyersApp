import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/icon_label.dart';

class StopScreen extends StatelessWidget {

  static const String id = "Stop Screen";

  final Map<String, dynamic> stop;
  
  const StopScreen({super.key, required this.stop});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  
          [
            Text("Order: ${stop['orderData']['ID'].toString()}", style: Theme.of(context).textTheme.titleMedium),
            IconLabel(icon: Icons.pets, child: Text(stop['stopData']['animalType'], style: Theme.of(context).textTheme.titleMedium)),
            IconLabel(icon: Icons.numbers, child: Text(stop['stopData']['quantity'].toString(), style: Theme.of(context).textTheme.titleMedium)),
            IconLabel(
              icon: Icons.location_pin, 
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stop['stopData']['address1'], style: Theme.of(context).textTheme.titleMedium),
                    Row(
                      children: [
                        Text("${stop['stopData']['address2']}, ", style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400)),
                        Text(stop['stopData']['address3'], style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400))
                      ],
                    ),
                    Text(stop['stopData']['postcode'], style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400)),
                  ]              
                )
              )
            ),
            IconLabel(icon: Icons.phone, child: Text(stop['stopData']['phoneNumber'], style: Theme.of(context).textTheme.titleMedium)),
            IconLabel(icon: Icons.payment, child: Text(stop['stopData']['payment'].toString(), style: Theme.of(context).textTheme.titleMedium)),
            IconLabel(icon: Icons.message, child: Text(stop['orderData']['message'], style: Theme.of(context).textTheme.titleMedium)),

            // IconLabel(icon: Icons.pets, text: stop['stopData']['quantity']),
            // IconLabel(icon: Icons.pets, text: stop['stopData']['quantity']),

          ]
      )
    );
  }
}