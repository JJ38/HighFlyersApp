import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';

class DeleteUserDialogBox extends StatelessWidget {

  final void Function(ActionSliderController) onDeleteUserSlide;

  const DeleteUserDialogBox({super.key, required this.onDeleteUserSlide});

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
              ActionSlider.standard(
                icon: Icon(Icons.delete_forever_rounded, color: Colors.white,),
                toggleColor: Colors.red,
                backgroundColor: const Color.fromARGB(255, 246, 246, 246),
                boxShadow: [BoxShadow(color: Colors.red, blurRadius: 0, spreadRadius: 1)],
                borderWidth: 4,
                child: Text("Slide to delete user", style: TextStyle(color: Colors.black),),
                action: (controller) async { onDeleteUserSlide(controller);}
              )
            ],
          )
        )
      )
    );
  }
}