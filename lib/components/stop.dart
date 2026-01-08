import 'package:flutter/material.dart';

class Stop extends StatelessWidget {


  final dynamic stop;
  final double width;

  const Stop({super.key, required this.stop, required this.width});

  @override
  Widget build(BuildContext context) {
    
    return  Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: EdgeInsets.all(10),
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              stop['stopNumber'].toString(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [  
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(stop['stopType'] == "collection" ? "Collection" : "Delivery", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14)),
                    Text("#${stop['stopData']['ID']}", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14)),
                  ]  
                ),        
                Text(stop['stopData']['address1']?.trim(), style: Theme.of(context).textTheme.titleSmall, maxLines: 1),
                Row(                
                  children: [
                    Text(stop['stopData']['address2'] != null ? stop['stopData']['address2']?.trim() + ", " : "", style: Theme.of(context).textTheme.labelSmall),
                    Text(stop['stopData']['address3']?.trim(), style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),             
                Text(stop['stopData']['postcode']?.trim(), style: Theme.of(context).textTheme.labelSmall),
              ]
            ),
          )
        ]
      )
    );
  }
}