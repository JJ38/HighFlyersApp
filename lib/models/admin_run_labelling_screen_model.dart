class AdminRunLabellingScreenModel {

  final dynamic runDocument;
  Map<String, dynamic>? runData;

  AdminRunLabellingScreenModel({required this.runDocument}){

    runData = runDocument.data();
    (runData?['stops'] as List).sort((a, b) => (a['orderData']['ID'] as int).compareTo(b['orderData']['ID'] as int));

  }

}