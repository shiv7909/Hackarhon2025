import 'package:cloud_firestore/cloud_firestore.dart';

class MessReductionModel {
  final String id;
  final String studentId;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  // final List<String> proofDocuments;
  final String status;
  final DateTime requestedAt;

  MessReductionModel({
    this.id = "MESS REDUCTION",
    required this.studentId,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    // this.proofDocuments = const [],
    this.status = 'Pending',
    DateTime? requestedAt,
  }) : requestedAt = requestedAt ?? DateTime.now();

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'DocName': id,
      'studentId': studentId,
      'fromDate': Timestamp.fromDate(fromDate),
      'toDate': Timestamp.fromDate(toDate),
      'reason': reason,
      // 'proofDocuments': proofDocuments,
      'status': status,
      'requestedAt': Timestamp.fromDate(requestedAt),
    };
  }

  // Create from Firestore document
  factory MessReductionModel.fromFirestore(
    DocumentSnapshot doc,
  ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MessReductionModel(
      id: doc.id,
      studentId: data['studentId'] ?? '',
      fromDate: (data['fromDate'] as Timestamp).toDate(),
      toDate: (data['toDate'] as Timestamp).toDate(),
      reason: data['reason'] ?? '',
      //proofDocuments: List<String>.from(data['proofDocuments'] ?? []),
      status: data['status'] ?? 'Pending',
      requestedAt: (data['requestedAt'] as Timestamp).toDate(),
    );
  }

  // Validate form data
  bool validate() {
    return fromDate != null && toDate != null && reason.isNotEmpty;
    // fromDate.isBefore(toDate);
  }
}
