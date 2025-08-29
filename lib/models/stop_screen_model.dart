import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class StopScreenModel {

  Map<String, dynamic> stop = {};
  bool showStopForm = false;
  late String runID;
  late Map<String, dynamic> runData;

  Future<bool> skipStop() async{  

    print("skipping stop");

    try{

      //update ProgressedRun doc stops[i] with stop status to skipped
      DocumentReference<Map<String, dynamic>> runDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "development").collection('ProgressedRuns').doc(runID);
      
      final stops = runData['stops'];

      List<dynamic> newStops = [...stops];

      //find stop to update
      final currentStopPrimaryKey = "${stop['orderID']}_${stop['stopType']}";

      bool foundStop = false; 

      int newStopNumber = runData['currentStopNumber'];
      bool isLastStop = true;

      for(int i = 0; i < newStops.length; i++){
        
        final stopPrimaryKey = "${newStops[i]['orderID']}_${newStops[i]['stopType']}";

        if(stopPrimaryKey == currentStopPrimaryKey){
          
          newStops[i]['stopStatus'] = "Skipped";
          newStopNumber += 1;
          isLastStop = false;
          foundStop = true;
          break;
        }

      }

      if(!foundStop){
        return false;
      }

      String runStatus = "Enroute";

      if(newStopNumber > stops.length){
        runStatus = "Completed";
        newStopNumber = newStopNumber - 1;
      }

      runDocRef.update(
        {
          'currentStopNumber': newStopNumber,
          'runStatus': runStatus,
          'stops': newStops
        }
      );
      
      if(isLastStop){
        print("is last stop. TODO:");
        return false;
      }

      runData['currentStopNumber'] = newStopNumber;
      runData['runStatus'] = runStatus;
      runData['stops'] = newStops;

      print("runData['currentStopNumber']: ${runData['currentStopNumber']}");

      for(int i = 0; i < newStops.length; i++){

        if(newStopNumber == newStops[i]['stopNumber']){
          stop = newStops[i];
          print(stop);
          return true;
        }

      }

      print("Next stop wasnt found");

      return false;

    }catch(e){
      
      print(e);
      return false;
    }

  }

}