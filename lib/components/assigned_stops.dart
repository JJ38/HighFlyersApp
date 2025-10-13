import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/stop_card.dart';
import 'package:high_flyers_app/controllers/assigned_stops_controller.dart';


class AssignedStops extends StatefulWidget {

  final AssignedStopsController assignedStopsController = AssignedStopsController();
  final Map<String, dynamic> run;
  
  AssignedStops({super.key, required this.run});

  @override
  State<AssignedStops> createState() => _AssignedStopsState();
}

class _AssignedStopsState extends State<AssignedStops> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final screenWidth = MediaQuery.of(context).size.width;
    final stops = widget.run['stops'] as List<dynamic>? ?? [];

    return Column(
            children: stops.map<Widget>((stop){
              return StopCard(
                stop: stop,
                width: screenWidth,
              );
            }).toList()                               
          );       
  }


}

