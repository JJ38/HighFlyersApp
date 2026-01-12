import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/admin_order_form.dart';
import 'package:high_flyers_app/components/squared_input.dart';
import 'package:high_flyers_app/controllers/update_order_dialog_controller.dart';

class UpdateOrderDialog extends StatefulWidget {

  final Map<String, dynamic> stop;
  final Map<String, dynamic> runData;
  final void Function() markAsUnassignedCallback;
  final bool hasPreviouslyBeenMarkedAsUnassigned;
  final String runID; 

  const UpdateOrderDialog({super.key, required this.stop, required this.runID, required this.runData, required this.markAsUnassignedCallback, required this.hasPreviouslyBeenMarkedAsUnassigned});

  @override
  State<UpdateOrderDialog> createState() => _UpdateOrderDialogState();
}

class _UpdateOrderDialogState extends State<UpdateOrderDialog> {

  late UpdateOrderDialogController updateOrderDialogController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    updateOrderDialogController = UpdateOrderDialogController(
      updateState: updateState, 
      stop: widget.stop, 
      orderID: widget.stop['orderID'], 
      runID: widget.runID, 
      runData: widget.runData, 
      markAsUnassignedCallback: widget.markAsUnassignedCallback, 
      hasPreviouslyBeenMarkedAsUnassigned: widget.hasPreviouslyBeenMarkedAsUnassigned
    );

    updateOrderDialogController.loadForm();

    print("order");

    print(widget.stop);

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

    final Map<String, dynamic> stop = updateOrderDialogController.model.stop;

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
                      Text(stop['orderData']['ID'].toString(), style: Theme.of(context).textTheme.labelMedium,)
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