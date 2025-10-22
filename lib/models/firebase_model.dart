import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseModel {

  FirebaseModel();

  static Future<List<dynamic>> fetchMultipleDocuments(runDocumentReferences) async{
    

    List<Future<DocumentSnapshot<Map<String, dynamic>>>> futureDocuments = [];


    for(var i = 0; i < runDocumentReferences.length; i++){

      futureDocuments.add(runDocumentReferences[i].get() as Future<DocumentSnapshot<Map<String, dynamic>>>);
      
    }

    Future.wait(futureDocuments);

    List<DocumentSnapshot<Map<String, dynamic>>> documents = [];

    for(var i = 0; i < futureDocuments.length; i++){

      final doc = await futureDocuments[i];

      documents.add(doc);

    }

    return documents;

  }

}