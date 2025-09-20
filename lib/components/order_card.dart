import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {

  final Map<String, dynamic> order;

  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {

  late final order;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    order = widget.order;
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: EdgeInsets.all(5),
      width: screenWidth,
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
              Text("#${order['stopData']['ID']}", style: Theme.of(context).textTheme.labelMedium),
              Text(order['stopType'] == "collection" ? "Collection" : "Delivery", style: Theme.of(context).textTheme.labelMedium)
            ]
          ),
          Row(
            spacing: 20,
            children: [
              Text(order['stopNumber'].toString(), style: Theme.of(context).textTheme.labelLarge, selectionColor: Color(0xFF2881FF)),
              //give the width of the row to the columnn to make sure it doenst overflow and text overflow works
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order['stopData']['address1'].trim(), style: Theme.of(context).textTheme.titleSmall, maxLines: 1),
                    Row(
                      children: [
                        Text(order['stopData']['address2'].trim() + ", ", style: Theme.of(context).textTheme.labelSmall),
                        Text(order['stopData']['address3'].trim(), style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                    Text(order['stopData']['postcode'].trim(), style: Theme.of(context).textTheme.labelSmall),
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