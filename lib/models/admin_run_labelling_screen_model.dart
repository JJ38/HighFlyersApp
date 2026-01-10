class AdminRunLabellingScreenModel {

  final dynamic runDocument;
  Map<String, dynamic>? runData;

  AdminRunLabellingScreenModel({required this.runDocument}){

    runData = runDocument.data();

  }

}