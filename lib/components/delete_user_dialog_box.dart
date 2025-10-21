import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/delete_user_dialog_box_controller.dart';

class DeleteUserDialogBox extends StatefulWidget {


  final dynamic userDoc;
  final void Function() loadUsers; 

  const DeleteUserDialogBox({super.key, required this.userDoc, required this.loadUsers});

  @override
  State<DeleteUserDialogBox> createState() => _DeleteUserDialogBoxState();
}

class _DeleteUserDialogBoxState extends State<DeleteUserDialogBox> {

  late DeleteUserDialogBoxController deleteUserDialogBoxController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();  
    deleteUserDialogBoxController = DeleteUserDialogBoxController(updateState: updateState, loadUsers: widget.loadUsers);
    deleteUserDialogBoxController.model.userDoc = widget.userDoc;
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

    return Center(
      child: Container(
        width: screenWidth * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text("Are you sure you want to delete this user?", style: Theme.of(context).textTheme.titleSmall, maxLines: 2,),
              SizedBox(height: 10,),
              Text(deleteUserDialogBoxController.model.userDoc.data()['username'], style: Theme.of(context).textTheme.titleSmall, maxLines: 2,),
              SizedBox(height: 10,),
              ActionSlider.standard(
                icon: Icon(Icons.delete_forever_rounded, color: Colors.white,),
                toggleColor: Colors.red,
                backgroundColor: const Color.fromARGB(255, 246, 246, 246),
                boxShadow: [BoxShadow(color: Colors.red, blurRadius: 0, spreadRadius: 1)],
                borderWidth: 4,
                child: Text("Slide to delete user", style: TextStyle(color: Colors.black),),
                action: (controller) async { deleteUserDialogBoxController.deleteUser(context, controller);}
              )
            ],
          )
        )
      )
    );
  }
}
