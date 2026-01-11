import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/admin_order_form.dart';
import 'package:high_flyers_app/components/squared_input.dart';
import 'package:high_flyers_app/controllers/update_order_dialog_controller.dart';

class UpdateOrderDialog extends StatefulWidget {

  final Map<String, dynamic> order;
  final Map<String, dynamic> runData;
  final String runID; 

  const UpdateOrderDialog({super.key, required this.order, required this.runID, required this.runData});

  @override
  State<UpdateOrderDialog> createState() => _UpdateOrderDialogState();
}

class _UpdateOrderDialogState extends State<UpdateOrderDialog> {

  late UpdateOrderDialogController updateOrderDialogController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateOrderDialogController = UpdateOrderDialogController(updateState: updateState, order: widget.order, orderID: widget.order['orderID'], runID: widget.runID, runData: widget.runData);
    updateOrderDialogController.loadForm();

  }

  void updateState(){

    if(mounted){
      setState(() {
        
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    final Map<String, dynamic> order = updateOrderDialogController.model.order;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: SizedBox(
        width: screenWidth,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ID:", style: Theme.of(context).textTheme.labelMedium,),
                      Text(order['orderData']['ID'].toString(), style: Theme.of(context).textTheme.labelMedium,)
                    ],
                  ),
                 
                  AdminOrderForm(orderController: updateOrderDialogController, buttonText: 'Update Order',)
                 
                ],
              )
            )
          )
        )
      )
    );
  }
}