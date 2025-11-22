import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/admin_order_form.dart';
import 'package:high_flyers_app/controllers/admin_edit_order_screen_controller.dart';

class AdminEditOrderScreen extends StatefulWidget {

  final Map<String, dynamic> order;
  final String uuid;

  const AdminEditOrderScreen({super.key, required this.order, required this.uuid});

  @override
  State<AdminEditOrderScreen> createState() => _AdminEditOrderScreenState();
}

class _AdminEditOrderScreenState extends State<AdminEditOrderScreen> {

  late AdminEditOrderScreenController adminEditOrderScreenController;

  @override
  void initState() {
    
    super.initState();
    adminEditOrderScreenController = AdminEditOrderScreenController(updateState: updateState, order: widget.order, uuid: widget.uuid);
    adminEditOrderScreenController.loadForm();

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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: screenWidth * 0.05),
          child: adminEditOrderScreenController.model.isLoaded ? 

              adminEditOrderScreenController.model.isSuccessfullyLoaded ? 

                  ListView(
                    children: [
                      GestureDetector(
                        onTap: (){adminEditOrderScreenController.onBackArrowTap(context);},
                        child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(vertical:  10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.arrow_back_sharp),
                                  Text("Back", style: Theme.of(context).textTheme.titleSmall),
                                ],
                              ),
                              Text("Edit", style: Theme.of(context).textTheme.titleSmall),
                            ]
                          ),
                        ),
                      ),
                      AdminOrderForm(orderController: adminEditOrderScreenController, buttonText: "Update Order", isDeletingHook: adminEditOrderScreenController.model.getIsDeleting,),

                      adminEditOrderScreenController.model.isSubmitting ? 

                          SizedBox(height: 0,)
                        
                        :
                        
                          Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(1,0,1,20),
                            child: Center(
                              child: ActionSlider.standard(
                                icon: Icon(Icons.delete_forever_rounded, color: Colors.white,),
                                toggleColor: Colors.red,
                                backgroundColor: const Color.fromARGB(255, 246, 246, 246),
                                boxShadow: [BoxShadow(color: Colors.red, blurRadius: 0, spreadRadius: 1)],
                                borderWidth: 4,
                                child: Text("Slide to delete order", style: TextStyle(color: Colors.black),),
                                action: (controller) async { await adminEditOrderScreenController.deleteOrder(context, controller);}
                              )
                            )
                          )
                    ],
                  )

                :

                  Center(child: Text("Error loading form"))
            
            :

              Center(child: CircularProgressIndicator(),)
        )
      )
    );
  }
}