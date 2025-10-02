import 'package:flutter/material.dart';

class BasketItem extends StatefulWidget {

  final void Function(String?) onRemoveFromBasketTap;
  final Map<String, dynamic> order;

  const BasketItem({super.key, required this.order, required this.onRemoveFromBasketTap});

  @override
  State<BasketItem> createState() => _BasketItemState();
}

class _BasketItemState extends State<BasketItem> {

  // late Map<String, dynamic> order;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // order = widget.order;
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 20),
          child: Column(
            spacing: 5,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,0,6,0),
                    child: Icon(Icons.pets, size: 25,),
                  ),
                  Text("${widget.order['quantity']}x ", style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w300, fontSize: 18)),
                  Text(widget.order['animalType'], style: Theme.of(context).textTheme.titleSmall,)
                ],
              ),

              Padding(
                padding: EdgeInsets.all(8),
                child: Divider(height: 1,)
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Icon(Icons.person),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Delivery Name", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                                Text(widget.order['deliveryName'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),)
                              ],
                            ),
                          ]
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Icon(Icons.location_on),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Delivery Address", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
                                  Row(
                                    children: [
                                      Text(widget.order['deliveryAddress1'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),  
                                    ],
                                  ),
                                    Row(
                                    children: [
                                      if(widget.order['deliveryAddress2'] != null)
                                        Text("${widget.order['deliveryAddress2']}, ", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),
                                      if(widget.order['deliveryAddress3'] != null)
                                        Text(widget.order['deliveryAddress3'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),
                                    ]
                                  ),
                                  Text(widget.order['deliveryPostcode'], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18)),
                                ]              
                              )
                            ),
                          ]
                        ),
                      ]
                    ),
                  ),
                  GestureDetector(
                    onTap: (){ widget.onRemoveFromBasketTap(widget.order['clientSideUUID']);},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                          color: Colors.red[400]!,
                          blurRadius: 7,
                          spreadRadius: -3
                          )],
                        color: Colors.red[400]!,
                        borderRadius: BorderRadius.circular(3),
                        border: BoxBorder.all(color: Colors.red[500]!, width: 1)
                      ),
                      child: Icon(Icons.delete_forever_rounded, size: 30, color: Colors.white,),
                    ),
                  ),
                ]       
              ),

              Padding(
                padding: EdgeInsets.all(8),
                child: Divider(height: 1,)
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0,0,6,0),
                          child: Icon(Icons.card_travel, size: 25,),
                        ),
                        Text("Boxes: ", style: Theme.of(context).textTheme.labelSmall,),
                        Text(widget.order['boxes'], style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w300, fontSize: 18)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0,0,6,0),
                          child: Icon(Icons.payment, size: 25,),
                        ),
                        Text("Payment: ", style: Theme.of(context).textTheme.labelSmall,),
                        Text(widget.order['payment'], style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w300, fontSize: 18)),
                      ],
                    ),
                  ),
                ]
              ),
            ],
          ),
        ),
      
      )
    );
  }
}