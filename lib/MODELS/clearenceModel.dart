import 'package:cloud_firestore/cloud_firestore.dart';

class ClearanceCertificateModel {
  final bool messPaid;
  final bool libraryPaid;
  final bool hostelPaid;

  ClearanceCertificateModel({
    this.messPaid = false,
    this.libraryPaid = false,
    this.hostelPaid = false,
  });

  // Factory method to create from Firestore data
  factory ClearanceCertificateModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ClearanceCertificateModel(
      messPaid: data['MESS'] ?? false,
      libraryPaid: data['LIBRARY'] ?? false,
      hostelPaid: data['HOSTEL'] ?? false,
    );
  }

  // Check if all payments are completed
  bool get isFullyPaid => messPaid && libraryPaid && hostelPaid;
}
