import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/stop_card.dart';


class AssignedStops extends StatefulWidget {

  final Map<String, dynamic>? runData;
  final String? progressedRunID;
  
  const AssignedStops({super.key, required this.runData, required this.progressedRunID});

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
    final stops = widget.runData?['stops'] as List<dynamic>? ?? [];

    return Column(
            children: stops.map<Widget>((stop){
              return StopCard(
                stop: stop,
                width: screenWidth,
                shouldShowOpenFormButton: true,
                runData: widget.runData,
                progressedRunID: widget.progressedRunID
              );
            }).toList()                               
          );       
  }


}

