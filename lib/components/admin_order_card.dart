import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/icon_label.dart';

class AdminOrderCard extends StatelessWidget {

  final Map<String, dynamic> order;

  const AdminOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      // height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(screenWidth * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("#${order['ID']}"),
                  Text(order['account'].toString()),
                ]
              )
            ),

            SizedBox(height: 10,),

            Container(
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                // color: Color(0xFFFDFDFD)
                color: const Color.fromARGB(255, 245, 245, 245),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [ 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Animal: ", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
                      Text("${order['quantity']}x ${order['animalType']}", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),  
                      ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Email: ", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
                      Expanded(
                        child: Text(order['email'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15), textAlign: TextAlign.end,),  
                      )
                    ]
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconLabel(icon: Icons.card_travel_outlined, child: Text(order['boxes'].toString())),
                      IconLabel(icon: Icons.calendar_month_outlined, child: Text(order['deliveryWeek'].toString())),
                    ]
                  ),
                ]
              ),
            ),

            SizedBox(height: 20,),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Collection:", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
                      
                      Text(order['collectionName'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),  
                      Text(order['collectionAddress1'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),  

                      if(order['collectionAddress2'] != "" && order['collectionAddress2'] != null)
                        Text("${order['collectionAddress2']}", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                      if(order['collectionAddress3'] != "" && order['collectionAddress3'] != null)
                        Text(order['collectionAddress3'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                        
                      Text(order['collectionPostcode'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                      Text(order['collectionPhoneNumber'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),

                    ]              
                  )
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Delivery:", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
                      
                      Text(order['deliveryName'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),  
                      Text(order['deliveryAddress1'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),  
                                           
                      if(order['deliveryAddress2'] != "" && order['deliveryAddress2'] != null)
                        Text("${order['deliveryAddress2']}", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                      if(order['deliveryAddress3'] != "" && order['deliveryAddress3'] != null )
                        Text(order['deliveryAddress3'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                    
                      Text(order['deliveryPostcode'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                      Text(order['deliveryPhoneNumber'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15)),
                    ]              
                  )
                ),  
              ],
            ),
            SizedBox(height: 20,),

            if(order['message'] != "" && order['message'] != null)

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Message:", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
                  Text(order['message'] ?? "", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible), softWrap: true,),  
                  SizedBox(height: 20,),
                ]
              ),
              
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconLabel(icon: Icons.payment, child: Text(order['payment'] ?? "")),
                IconLabel(icon: Icons.currency_pound, spacing: 0, child: Text(order['price'].toString())),
                if(order['code'] != "")
                  IconLabel(icon: Icons.discount, spacing: 0, child: Text(order['code'].toString()))
              ],
            )
          ],
        ),
      ),
    );
  }
}