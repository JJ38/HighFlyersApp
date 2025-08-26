import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/stop_card.dart';
import 'package:high_flyers_app/controllers/assigned_stops_controller.dart';


class AssignedStops extends StatelessWidget {

  final AssignedStopsController assignedStopsController = AssignedStopsController();
  final Map<String, dynamic> run;
  
  AssignedStops({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
  
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
            flex: 1,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: run['stops'].length,
              itemBuilder: (BuildContext context, int index) {
                return StopCard(
                  stop: run['stops'][index],
                  width: screenWidth,
                );
              }
            )                       
          );
  }
}
