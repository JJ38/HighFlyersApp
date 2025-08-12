import 'package:flutter/material.dart';

class StopCard extends StatelessWidget {

  final dynamic stop;
  final double width;

  const StopCard({super.key, required this.stop, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Color.fromARGB(64, 0, 0, 0), blurRadius: 10, spreadRadius: -4)
        ]
      ),
      child: Column(
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text("#${stop['stopData']['ID']}", style: Theme.of(context).textTheme.labelMedium),
              Text(stop['stopType'] == "collection" ? "Collection" : "Delivery", style: Theme.of(context).textTheme.labelMedium)
            ]
          ),
          Row(
            spacing: 20,
            children: [
              Text(stop['stopNumber'].toString(), style: Theme.of(context).textTheme.labelLarge, selectionColor: Color(0xFF2881FF)),
              //give the width of the row to the columnn to make sure it doenst overflow and text overflow works
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stop['stopData']['address1'].trim(), style: Theme.of(context).textTheme.titleSmall, maxLines: 1),
                    Row(
                      children: [
                        Text(stop['stopData']['address2'].trim() + ", ", style: Theme.of(context).textTheme.labelSmall),
                        Text(stop['stopData']['address3'].trim(), style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                    Text(stop['stopData']['postcode'].trim(), style: Theme.of(context).textTheme.labelSmall),
                  ]
                )
              )
            ],
          ),
        ]
      )
    );
  }
}