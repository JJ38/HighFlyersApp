import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/squared_input.dart';
import 'package:high_flyers_app/controllers/add_user_dialog_box_controller.dart';

class AddUserDialogBox extends StatefulWidget {

  final void Function() loadUsers; 

  const AddUserDialogBox({super.key, required this.loadUsers});

  @override
  State<AddUserDialogBox> createState() => _AddUserDialogBoxState();
}

class _AddUserDialogBoxState extends State<AddUserDialogBox> {

  late final AddUserDialogBoxController addUserDialogBoxController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addUserDialogBoxController = AddUserDialogBoxController(updateState: updateState, loadUsers: widget.loadUsers);

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

    return Dialog(
      child: SizedBox(
        width: screenWidth * 0.9,
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
                    Text("Create user", style: Theme.of(context).textTheme.titleSmall, maxLines: 2,),
                  SquaredInput(label: "Username", value: "", onChange: (value){addUserDialogBoxController.onUsernameChange(value);}, keyboardType: TextInputType.text,),
                  SquaredInput(label: "Password", value: "", onChange: (value){addUserDialogBoxController.onPasswordChange(value);}, keyboardType: TextInputType.text,),
                  SquaredInput(label: "Confirm Password", value: "", onChange: (value){addUserDialogBoxController.onConfirmPasswordChange(value);}, keyboardType: TextInputType.text,),
                  DropdownButtonFormField(
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15, overflow: TextOverflow.visible),
                    decoration: InputDecoration(
                      label: Text("Collected Payment"),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 2.0, 
                        ),
                      ),
                    ),
                    onChanged: (value){addUserDialogBoxController.onRoleSelect(value);},
                    items:<DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value: "admin",
                        child: Text('Admin'),
                      ),
                      DropdownMenuItem(
                        value: "customer",
                        child: Text('Customer'),
                      ),
                      DropdownMenuItem(
                        value: "driver",
                        child: Text('Driver'),
                      ),
                      DropdownMenuItem(
                        value: "staff",
                        child: Text('Staff'),
                      ),
                    ],
                  ),
                    addUserDialogBoxController.model.isCreatingUser?
                        Center(
                        child: CircularProgressIndicator()
                      )
                
                    :
                        Center(
                        child: SizedBox(
                          width: screenWidth * 0.9,
                          child: Material(              
                            color: Theme.of(context).colorScheme.secondary,
                            shadowColor: Color(0x00000000),                                
                            borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                            child: MaterialButton(
                              onPressed: (){addUserDialogBoxController.onCreateUserTap(context);},
                              child: Text("Create User", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18)),                           
                            ),
                          ),
                        ),
                      ),
                ],
              )
            )
          )
        )
      )
    );
  }
}
