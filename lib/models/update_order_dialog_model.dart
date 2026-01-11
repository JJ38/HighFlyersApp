import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:high_flyers_app/models/order_model_abstract.dart';

class UpdateOrderDialogModel extends OrderModel{

  Map<String, dynamic> order;
  Map<String, dynamic> runData;
  String orderID;
  String runID;

  UpdateOrderDialogModel({required this.order, required this.orderID, required this.runID, required this.runData}){

    final orderData = order['orderData'];

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

  Future<bool> updateOrderAndRuns() async {

    try{
      
      final databaseName = dotenv.env['DATABASE_NAME'];

      if(databaseName == null){
        return false;
      }

      final shipmentName = runData['shipmentName'];

      print("shipmentName: $shipmentName");
  

      if(shipmentName == null){
        return false;
      }

      //fetch unassigned run to get id as queries cant be used inside a transaction 
      final unassignedRunDoc = await FirebaseFirestore.instance.collection('Runs').where('runName', isNull: true).where('shipmentName', isEqualTo: shipmentName).get();

      if(unassignedRunDoc.docs.isEmpty){
          return false;
      }

      final unassignedRunDocID = unassignedRunDoc.docs[0].id;

      DocumentReference<Map<String, dynamic>> unassignedRunDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Runs').doc(unassignedRunDocID);
      DocumentReference<Map<String, dynamic>> runDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Runs').doc(runID);
      DocumentReference<Map<String, dynamic>> orderDocRef = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: databaseName).collection('Orders').doc(orderID);


      //remove stop from run

      //add stop to unassigned run 

      await FirebaseFirestore.instance.runTransaction((transaction) async {
       
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

        print(unassignedRunDoc.data());
        print(runDoc.data());
        print(orderDoc.data());

      });


    }catch(error, stack){

      print(error);
      return false;

    }

    return true;

  }

}