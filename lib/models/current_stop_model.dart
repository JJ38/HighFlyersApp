import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:map_launcher/map_launcher.dart';

class CurrentStopModel {

  Map<String, dynamic> stop = {};
  bool showStopForm = false;
  late String progressedRunID;
  late Map<String, dynamic> runData;
  List<AvailableMap>? availableMaps;
  bool isDefaultMapAvailable = false;
  late void Function(Map<String, dynamic>) updateCurrentStop;
  bool isRunCompleted = false;


  Future<bool> skipStop() async{

    final bool successfullySkippedStop = await nextStop("Skipped");

    if(!successfullySkippedStop){
      return false;
    }

    return true;

  }

  Future<bool> completeStop(Map<String, dynamic>? formDetails) async{

    return await nextStop("Complete", formDetails);

  }


  Future<bool> nextStop(String stopStatus, [Map<String, dynamic>? formDetails]) async{  

    try{

      final databaseName = dotenv.env['DATABASE_NAME'];

      if(databaseName == null){
        return false;
      }

      //update ProgressedRun doc stops[i] with stop status to skipped
      DocumentReference<Map<String, dynamic>> runDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('ProgressedRuns').doc(progressedRunID);
      
      final stops = runData['stops'];

      List<dynamic> newStops = [...stops];

      //find stop to update
      final currentStopPrimaryKey = "${stop['orderID']}_${stop['stopType']}";

      bool foundStop = false; 

      int newStopNumber = runData['currentStopNumber'];


      for(int i = 0; i < newStops.length; i++){
        
        final stopPrimaryKey = "${newStops[i]['orderID']}_${newStops[i]['stopType']}";

        if(stopPrimaryKey == currentStopPrimaryKey){
          
          newStops[i]['stopStatus'] = stopStatus;
          newStops[i]['formDetails'] = formDetails;

          newStopNumber += 1;
          foundStop = true;
          break;
        }

      }

      if(!foundStop){
        return false;
      }

      String runStatus = "Enroute";

      //is there a stop to show next? - is the run completed?
      if(newStopNumber > stops.length){

        isRunCompleted = true;
        runStatus = "Completed";
        newStopNumber = newStopNumber - 1;

      }

      Map<String, dynamic> fieldsToUpdate = 
      {
        'currentStopNumber': newStopNumber,
        'runStatus': runStatus,
        'stops': newStops
      };


      await runDocRef.update(fieldsToUpdate);
      
      //updates client that holds info for run
      runData['currentStopNumber'] = newStopNumber;
      runData['runStatus'] = runStatus;
      runData['stops'] = newStops;
      

      for(int i = 0; i < newStops.length; i++){

        if(newStopNumber == newStops[i]['stopNumber']){
          stop = newStops[i];
          updateCurrentStop(stop);
          print(stop['coordinates']);
          return true;
        }

      }


      return false;

    }catch(e){
      
      print(e);
      return false;
    }

  }

}