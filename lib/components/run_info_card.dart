import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/icon_label.dart';

class RunInfoCard extends StatelessWidget {

  final String? shipmentName;
  final String? runName;
  final int? runWeek;
  final int? numberOfStops;

  const RunInfoCard({required this.shipmentName, required this.runName, required this.runWeek, required this.numberOfStops, super.key});

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;

    return 
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(shipmentName ?? "Unknown shipment name", style: Theme.of(context).textTheme.titleSmall,),
              Text(runName ?? "Unknown run name", style: Theme.of(context).textTheme.labelMedium,),
              Row(
                spacing: 10,
                children: [
                  IconLabel(icon: Icons.calendar_month, child: Text(runWeek.toString(), style: Theme.of(context).textTheme.labelSmall,)),
                  IconLabel(icon: Icons.numbers, child: Text(numberOfStops.toString(), style: Theme.of(context).textTheme.labelSmall,)),
                ],
              )
            ],
          ),
        )
      );
  }
}