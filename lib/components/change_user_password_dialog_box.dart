import 'package:flutter/material.dart';
import 'package:high_flyers_app/components/squared_input.dart';
import 'package:high_flyers_app/controllers/change_password_dialog_box_controller.dart';

class ChangeUserPasswordDialogBox extends StatefulWidget {

  final String uid;

  const ChangeUserPasswordDialogBox({super.key, required this.uid});

  @override
  State<ChangeUserPasswordDialogBox> createState() => _ChangeUserPasswordDialogBoxState();
}

class _ChangeUserPasswordDialogBoxState extends State<ChangeUserPasswordDialogBox> {

  late final ChangePasswordDialogBoxController changePasswordDialogBoxController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changePasswordDialogBoxController = ChangePasswordDialogBoxController(updateState: updateState);

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
          child: Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Text("Reset password", style: Theme.of(context).textTheme.titleSmall, maxLines: 2,),
                SquaredInput(label: "New password", value: "", onChange: (value){changePasswordDialogBoxController.onPasswordChange(value);}, keyboardType: TextInputType.text,),

                changePasswordDialogBoxController.model.isUpdatingPassword?

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
                            onPressed: (){changePasswordDialogBoxController.onUpdatePasswordTap(context, widget.uid);},
                            child: Text("Update Password", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 18)),                           
                          ),
                        ),
                      ),
                    ),
              ],
            )
          )
        )
      )
    );
  }
}
