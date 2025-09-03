import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:map_launcher/map_launcher.dart';

class CurrentStopModel {

  Map<String, dynamic> stop = {};
  bool showStopForm = false;
  late String progressedRunID;
  late Map<String, dynamic> runData;
  List<AvailableMap>? availableMaps;
  bool isDefaultMapAvailable = false;


  Future<bool> skipStop() async{

    return await nextStop("Skipped");

  }

  Future<bool> completeStop(Map<String, dynamic>? formDetails) async{

    return await nextStop("Complete", formDetails);

  }


  Future<bool> nextStop(String stopStatus, [Map<String, dynamic>? formDetails]) async{  

    try{

      //update ProgressedRun doc stops[i] with stop status to skipped
      DocumentReference<Map<String, dynamic>> runDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: "development").collection('ProgressedRuns').doc(progressedRunID);
      
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
          
          newStops[i]['stopStatus'] = stopStatus;
          newStops[i]['formDetails'] = formDetails;

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

      Map<String, dynamic> fieldsToUpdate = 
      {
        'currentStopNumber': newStopNumber,
        'runStatus': runStatus,
        'stops': newStops
      };


      await runDocRef.update(fieldsToUpdate);
      
      if(isLastStop){
        print("is last stop. TODO:");
        return false;
      }

      runData['currentStopNumber'] = newStopNumber;
      runData['runStatus'] = runStatus;
      runData['stops'] = newStops;

      for(int i = 0; i < newStops.length; i++){

        if(newStopNumber == newStops[i]['stopNumber']){
          stop = newStops[i];
          print(stop);
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