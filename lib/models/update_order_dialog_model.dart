import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/Requests/request_abstract.dart';
import 'package:high_flyers_app/models/admin_edit_order_screen_model.dart';
import 'package:high_flyers_app/models/order_model_abstract.dart';

class UpdateOrderDialogModel extends OrderModel{

  final void Function() markAsUnassignedCallback;
  final bool hasPreviouslyBeenMarkedAsUnassigned;
  Map<String, dynamic> stop;
  Map<String, dynamic> runData;
  String orderID;
  String runID;

  UpdateOrderDialogModel({
    required this.stop, 
    required this.orderID, 
    required this.runID, 
    required this.runData, 
    required this.markAsUnassignedCallback, 
    required this.hasPreviouslyBeenMarkedAsUnassigned}
  ){

    final orderData = stop['orderData'];

    if(orderData == null){
      return;
    }

    animalType = orderData['animalType'];
    quantity = orderData['quantity'].toString();
    code = orderData['code'];
    boxes = orderData['boxes'].toString();
    email = orderData['email'];
    account = orderData['account'];
    deliveryWeek = orderData['deliveryWeek'].toString();
    collectionName = orderData['collectionName'];
    collectionAddressLine1 = orderData['collectionAddress1'];
    collectionAddressLine2 = orderData['collectionAddress2'];
    collectionAddressLine3 = orderData['collectionAddress3'];
    collectionPostcode = orderData['collectionPostcode'];
    collectionPhoneNumber = orderData['collectionPhoneNumber'];
    deliveryName = orderData['deliveryName'];
    deliveryAddressLine1 = orderData['deliveryAddress1'];
    deliveryAddressLine2 = orderData['deliveryAddress2'];
    deliveryAddressLine3 = orderData['deliveryAddress3'];
    deliveryPostcode = orderData['deliveryPostcode'];
    deliveryPhoneNumber = orderData['deliveryPhoneNumber'];
    payment = orderData['payment'];
    price = orderData['price'].toString();
    message = orderData['message'];

  }

  bool doRunsNeedUpdating(formOrder, initialOrder){

    print(formOrder['deliveryWeek']);
    print(initialOrder['deliveryWeek']);


    if(formOrder['deliveryWeek'].toString() != initialOrder['deliveryWeek'].toString()){
      print("formOrder['deliveryWeek'] != initialOrder['deliveryWeek']");
      return true;
    }

    if(formOrder['collectionAddress1'] != initialOrder['collectionAddress1']){
      print("formOrder['collectionAddress1'] != initialOrder['collectionAddress1']");
      return true;
    }

    if(formOrder['collectionAddress2'] != initialOrder['collectionAddress2']){
      print("formOrder['collectionAddress2'] != initialOrder['collectionAddress2']");
      return true;
    }

    if(formOrder['collectionAddress3'] != initialOrder['collectionAddress3']){
      print("formOrder['collectionAddress3'] != initialOrder['collectionAddress3']");
      return true;
    }

    if(formOrder['collectionPostcode'] != initialOrder['collectionPostcode']){
      print("formOrder['collectionPostcode'] != initialOrder['collectionPostcode']");
      return true;
    }

    if(formOrder['deliveryAddress1'] != initialOrder['deliveryAddress1']){
      print("formOrder['deliveryAddress1'] != initialOrder['deliveryAddress1']");
      return true;
    }

    if(formOrder['deliveryAddress2'] != initialOrder['deliveryAddress2']){
      print("formOrder['deliveryAddress2'] != initialOrder['deliveryAddress2']");
      return true;
    }

    if(formOrder['deliveryAddress3'] != initialOrder['deliveryAddress3']){
      print("formOrder['deliveryAddress3'] != initialOrder['deliveryAddress3']");
      return true;
    }

    if(formOrder['deliveryPostcode'] != initialOrder['deliveryPostcode']){
      print("formOrder['deliveryPostcode'] != initialOrder['deliveryPostcode']");
      return true;
    }

    return false;

  }


  Future<bool> updateOrderAndRuns() async {
    
    final Map<String, dynamic> formOrder = getOrder();
    final initialOrder = stop['orderData'];


    AdminEditOrderScreenModel adminEditOrderScreenModel = AdminEditOrderScreenModel(order: formOrder, uuid: orderID);
    final JSONRequest request = adminEditOrderScreenModel.getEditOrderRequest();

    final bool doesRunNeedUpdating = doRunsNeedUpdating(formOrder, initialOrder);

    if(doesRunNeedUpdating && !hasPreviouslyBeenMarkedAsUnassigned){
      
      final bool successfullyUpdatedRuns = await updateRuns(formOrder, adminEditOrderScreenModel, request);

      if(!successfullyUpdatedRuns){
        return false;
      }

      markAsUnassignedCallback();

    }else{

      final submittedOrdersSuccessfully = await adminEditOrderScreenModel.submitAuthenticatedRequest(request);
      print("Updated order only");
      if(!submittedOrdersSuccessfully){
        return false;
      }

    }

    //add ID back to formOrder as ID isnt included in form

    formOrder['ID'] = initialOrder['ID'];

    //update client with new order data
    stop['orderData'] = formOrder;


    return true;
  }


  Future<bool> updateRuns(formOrder, adminEditOrderScreenModel, request) async {

    print('updateRuns');

    try{
      
      final databaseName = dotenv.env['DATABASE_NAME'];

      if(databaseName == null){
        return false;
      }

      final shipmentName = runData['shipmentName'];

      if(shipmentName == null){
        return false;
      }

      //fetch unassigned run to get id as queries cant be used inside a transaction 
      final unassignedRunDoc = await FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Runs').where('runName', isNull: true).where('shipmentName', isEqualTo: shipmentName).get();

      if(unassignedRunDoc.docs.isEmpty){
        print("unassignedRunDoc.docs.isEmpty");
        return false;
      }

      final unassignedRunDocID = unassignedRunDoc.docs[0].id;

      DocumentReference<Map<String, dynamic>> unassignedRunDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Runs').doc(unassignedRunDocID);
      DocumentReference<Map<String, dynamic>> runDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Runs').doc(runID);
      DocumentReference<Map<String, dynamic>> orderDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Orders').doc(orderID);


      await FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).runTransaction((transaction) async {
       
        final unassignedRunDoc = await transaction.get(unassignedRunDocRef);
 
        if (!unassignedRunDoc.exists) {
          throw Exception('unassignedRunDoc does not exist!');
        }

        final runDoc = await transaction.get(runDocRef);
        if (!runDoc.exists) {
          throw Exception('runDoc does not exist!');
        }

        final orderDoc = await transaction.get(orderDocRef);
        if (!orderDoc.exists) {
          throw Exception('orderDoc does not exist!');
        }

        final List<Map<String, dynamic>>? newRunStops = removeStopFromRunDoc(runDoc, orderID);

        if(newRunStops == null){
          throw Exception('Error removing stop from run doc');
        }

        final List<Map<String, dynamic>>? newUnassignedRunStops = addStopToUnassignedRunDoc(unassignedRunDoc);

        if(newUnassignedRunStops == null){
          throw Exception('Error removing stop from run doc');
        }


        transaction.update(runDocRef, {
          'stops': newRunStops,
          'isOptimised': false
        });

        
        transaction.update(unassignedRunDocRef, {
          'stops': newUnassignedRunStops,
        });


        final submittedOrdersSuccessfully = await adminEditOrderScreenModel.submitAuthenticatedRequest(request);
      
        if(!submittedOrdersSuccessfully){
          throw Exception('Error removing stop from run doc');
        }

      });


    }catch(error, stack){

      print(error);
      return false;

    }

    return true;

  }


  List<Map<String, dynamic>>? removeStopFromRunDoc(runDoc, String? orderDocID){

    final Map<String, dynamic> runData = runDoc.data();

    if(orderDocID == null || runData['stops'] == null){
      print("orderDocID == null || stops == null");
      return null;
    } 

    final List<Map<String, dynamic>> stops = (runData['stops'] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map)).toList();

    bool foundStop = false;

    for(int i = 0; i < stops.length; i++){

      if(stops[i]['orderID'] == orderDocID){
        stops.removeAt(i);
        foundStop = true;
      }

    }
    
    if(!foundStop){
      return null;
    }

    return stops;

  }

  List<Map<String, dynamic>>? addStopToUnassignedRunDoc(unassignedRunDoc){

    final Map<String, dynamic> runData = unassignedRunDoc.data();

    if(runData['stops'] == null){
      print("stops == null");
      return null;
    }   

    final List<Map<String, dynamic>> stops = (runData['stops'] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map)).toList();

    final Map<String, dynamic> stopToAdd = Map<String,dynamic>.from(stop);
    stopToAdd.remove('orderData');
    stopToAdd.remove('stopTime');
    stopToAdd.remove('coordinates');


    stops.add(stopToAdd);

    return stops;
  }
}