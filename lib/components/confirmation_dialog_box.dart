import 'package:flutter/material.dart';

class ConfirmationDialogBox extends StatelessWidget {

  final String confirmationMessage;
  final void Function(bool) responseCallback;

  const ConfirmationDialogBox({super.key, this.confirmationMessage = "are you sure", required this.responseCallback});

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Center(
              child: Text(confirmationMessage, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 15), maxLines: 10, textAlign: TextAlign.center,),
            ),

            SizedBox(height: 10),

            Row(
              children: [

                Expanded(
                  child: Material(
                    color: Theme.of(context).colorScheme.primary,
                    shadowColor: Color(0x00000000),                                
                    borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                    child: MaterialButton(
                      onPressed: (){
                        responseCallback(true);
                        Navigator.of(context).pop();
                        print("Yes");
                      },
                      // minWidth: screenWidth * 0.6,
                      height: screenWidth * 0.07,
                      child: Text("Yes", style: TextStyle(color: Colors.white)),
                    ),
                  ),

                ),

                SizedBox(width: 10),

                Expanded(
                  child: Material(
                    color: Theme.of(context).colorScheme.primary,
                    shadowColor: Color(0x00000000),                                
                    borderRadius: BorderRadius.all(Radius.circular(8)),                                     
                    child: MaterialButton(
                      onPressed: (){
                        responseCallback(false);
                        Navigator.of(context).pop();
                        print("No");
                      },
                      // minWidth: screenWidth * 0.6,
                      // height: screenWidth * 0.07,
                      child: Text("No", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            )
        
          ],
        )
      )
    );
  }
}