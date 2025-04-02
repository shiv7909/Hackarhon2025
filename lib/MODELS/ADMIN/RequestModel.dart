class RequestModel {
  final String documentId;
  final String? customDocumentName;
  final String? documentName;
  final String purpose;
  final String? uploadedFileUrl;
  final String? rejectionReason;

  // Student Details
  final String studentName;
  final String studentId;
  final String studentPhone;

  RequestModel({
    required this.documentId,
    this.customDocumentName,
    this.documentName,
    required this.purpose,
    this.uploadedFileUrl,
    this.rejectionReason,
    required this.studentName,
    required this.studentId,
    required this.studentPhone,
  });

  factory RequestModel.fromJson(String docId, Map<String, dynamic> documentData,
      Map<String, dynamic> studentData) {
    return RequestModel(
      documentId: docId,
      customDocumentName: documentData['customDocumentName'],
      documentName: documentData['documentName'] ?? 'Unnamed Document',
      purpose: documentData['purpose'] ?? 'No Purpose',
      uploadedFileUrl: documentData['uploadedFileUrl'],
      rejectionReason: documentData['rejectionReason'],
      studentName: studentData['NAME'] ?? 'Unknown Student',
      studentId: studentData['ID'] ?? 'N/A',
      studentPhone: studentData['PHONE'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customDocumentName': customDocumentName,
      'documentName': documentName,
      'purpose': purpose,
      'uploadedFileUrl': uploadedFileUrl,
      'rejectionReason': rejectionReason,
    };
  }
}
