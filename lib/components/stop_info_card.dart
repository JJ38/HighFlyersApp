import 'package:flutter/material.dart';

class StopInfoCard extends StatelessWidget {

  final Map<String, dynamic> stop;
  final String stopType;
  final bool highlightStop;

  const StopInfoCard({super.key, required this.stop, required this.stopType, required this.highlightStop});

  @override
  Widget build(BuildContext context) {

    final String? paymentType = stop['orderData']?['payment']?.toString().toLowerCase() == "pickup" ? "collection" : stop['orderData']?['payment']?.toString().toLowerCase();

    return 
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: highlightStop ? 
          
              Border.all(
                width: 2,
                color: stopType == "collection" ? Colors.red : Colors.blue
              )
              
            :

              null
              
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(stop['orderData']?['${stopType}Name'], style: Theme.of(context).textTheme.titleSmall, maxLines: 5,),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(stop['orderData']?['${stopType}PhoneNumber'], style: Theme.of(context).textTheme.labelMedium?.copyWith(height: 2))
                  ),
                ),         
              ],
            ),
            SizedBox(height: 5,),
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(10, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stop['orderData']?['${stopType}Address1'].trim(), style: Theme.of(context).textTheme.titleSmall, maxLines: 5),
                  Row(
                    children: [
                      Text(stop['orderData']?['${stopType}Address2'].trim() + ", ", style: Theme.of(context).textTheme.labelSmall),
                      Text(stop['orderData']?['${stopType}Address3'].trim(), style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                  Text(stop['orderData']?['${stopType}Postcode'].trim(), style: Theme.of(context).textTheme.labelSmall),
                  if(highlightStop && (paymentType == stopType))
                    Column(
                      children: [
                        Row(
                          children: [
                            Text("Total: ", style: Theme.of(context).textTheme.labelMedium),
                            Text(stop['orderData']['price'] == null || stop['orderData']['price'] == "N/A" ? "N/A" : "£${stop['orderData']['price'].toString()}", style: Theme.of(context).textTheme.labelMedium),
                          ],
                        )
                      ]
                    ),
                ]
              )
            )
          ],
        ),
     );
  }
}