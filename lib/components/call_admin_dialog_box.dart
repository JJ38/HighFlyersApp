import 'package:flutter/material.dart';

class CallAdminDialogBox extends StatelessWidget {

  final void Function() callAdmin;

  const CallAdminDialogBox({super.key, required this.callAdmin});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text("Before moving on from this stop please call kev to notify him of the payment situation", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15), maxLines: 10, textAlign: TextAlign.center,),
            ),
            SizedBox(height: 10),
            Center(
              child: Material(
                color: Theme.of(context).colorScheme.primary,
                shadowColor: Color(0x00000000),                                
                borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                child: MaterialButton(
                  onPressed: callAdmin,
                  minWidth: screenWidth * 0.6,
                  height: screenWidth * 0.1,
                  child: Text("Call Kev", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),   
          ],
        )
      )
    );
  }
}