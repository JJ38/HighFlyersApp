import 'package:flutter/material.dart';

class StopCard extends StatelessWidget {

  final dynamic stop;
  final double width;

  const StopCard({super.key, required this.stop, required this.width});

  @override
  Widget build(BuildContext context) {

    final bool shouldHighlightStop = stop['label']?['arrivalNotice'] == "yes" || stop['label']?['message'] != "" && stop['label']?['message'] != null; 
    print(stop);
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: EdgeInsets.all(5),
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: shouldHighlightStop ? const Color(0xFF2881FF) : Color.fromARGB(69, 0, 0, 0), blurRadius: 10, spreadRadius: -4)
        ]//
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
              //give the width of the row to the column to make sure it doenst overflow and text overflow works
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
                    Text("Phone Number: ${stop['stopData']['phoneNumber'].trim()}", style: Theme.of(context).textTheme.labelSmall),

                  ]
                )
              )
            ],
          ),

          if(shouldHighlightStop)
            SizedBox(height: 5,),

          if(stop['label']?['arrivalNotice'] == "yes")

            Row(
              children: [
                Text("Notice period: ", style: Theme.of(context).textTheme.labelMedium),
                Text("${stop['label']?['noticePeriod']} mins", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14)),
              ],
            ),

          if(stop['label']?['message'] != "" && stop['label']?['message'] != null)

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Staff message: ", style: Theme.of(context).textTheme.labelMedium),
                Expanded(
                  child: Text("${stop['label']?['message']}", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, overflow: TextOverflow.visible)),
                )
              ],
            )

        ]
      )
    );
  }
}