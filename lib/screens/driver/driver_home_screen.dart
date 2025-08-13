import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:high_flyers_app/controllers/driver_home_screen_controller.dart';

class DriverHomeScreen extends StatefulWidget {

  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {

  late DriverHomeScreenController driverHomeScreenController;

  bool initialisedDriver = false;

  @override
  void initState(){ 
    super.initState();
    driverHomeScreenController = DriverHomeScreenController();
    initialiseDriver();
    
  }

  void initialiseDriver() async{
    initialisedDriver = await driverHomeScreenController.model.initialiseDriver();

    setState(() {
      initialisedDriver;
    });
  }


  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: initialisedDriver ? Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: screenWidth * 0.05), 
        child: SafeArea(
          child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Runs", style: Theme.of(context).textTheme.titleLarge),
              StreamBuilder<QuerySnapshot>(
                stream: driverHomeScreenController.model.getDriverRunsQuerySnapshot(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return ListView( 
                    shrinkWrap: true,
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;

                          final runName = data['runName'].toString();
                          final runWeek = data['runWeek'].toString();

                          return ListTile(
                            title: Text(runName),
                            subtitle: Text("Week $runWeek"),
                            onTap: () { driverHomeScreenController.onRunTileTap(document, context); } ,
                          );
                        })
                        .toList()
                        .cast(),
                    );
                },
              ),
            ]
          ),
        ),
      ) : Text("Inititalising driver")
    );
  }
}
