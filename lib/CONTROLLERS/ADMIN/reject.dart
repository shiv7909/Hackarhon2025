import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/ADMIN/RequestController.dart';
import 'package:naradaflow/CONTROLLERS/login_controller.dart';

class RejectController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoginController _authController = Get.find();
  final RequestController _requestController = Get.put(RequestController());

  Future<void> rejectDocument({
    required String studentId,
    required String documentId,
    required Map<String, dynamic> documentData,
    required String rejectionReason,
    required String documentName, // Add document name parameter
  }) async {
    try {
      // Get current timestamp
      final timestamp = FieldValue.serverTimestamp();
      final adminName = _authController.loginId.value;

      // Add additional rejection reason and metadata to document data
      documentData['rejectionReason'] = rejectionReason;
      // documentData['rejectedBy'] = adminName;
      documentData['rejectedAt'] = timestamp;

      // 1. Add document to Rejected subcollection
      await _firestore
          .collection('ADMINS')
          .doc('computer_science')
          .collection('admins')
          .doc(adminName)
          .collection('Rejected')
          .doc(documentId)
          .set(documentData);

      // 2. Remove from Pending subcollection
      await _firestore
          .collection('ADMINS')
          .doc('computer_science')
          .collection('admins')
          .doc(adminName)
          .collection('Pending')
          .doc(documentId)
          .delete();

      // 3. Update Status subcollection in User's Documents
      await _updateUserDocumentStatus(
        studentId: studentId,
        documentId: documentId,
        rejectionReason: rejectionReason,
        documentName: documentName, // Pass document name
      );

      await _requestController.refreshCurrentTabRequests();
    } catch (e) {
      print('Error rejecting document: $e');
      throw Exception('Failed to reject document');
    }
  }

  Future<void> _updateUserDocumentStatus({
    required String studentId,
    required String documentId,
    required String rejectionReason,
    required String documentName, // Add document name parameter
  }) async {
    try {
      // Get admin name from auth controller
      String adminName = _authController.loginId.value;

      // Get current timestamp
      final timestamp = FieldValue.serverTimestamp();

      // Detailed rejection description
      String rejectionDescription =
          "Document '$documentName' has been rejected by admin $adminName. "
          "Reason: $rejectionReason";

      // Update Initial_submission document in Status subcollection
      await _firestore
          .collection('USERS')
          .doc('MCA')
          .collection('MEN')
          .doc(studentId)
          .collection('Documents')
          .doc(documentId)
          .collection('Status')
          .doc(adminName)
          .update({
        'name': adminName,
        'status': 'rejected',
        'remark': rejectionReason,
        'description': rejectionDescription,
        'timestamp': timestamp,
      });

      // Update Admin1 document in Status subcollection
      await _firestore
          .collection('USERS')
          .doc('MCA')
          .collection('MEN')
          .doc(studentId)
          .collection('Documents')
          .doc(documentId)
          .collection('Status')
          .doc(adminName)
          .update({
        'name': adminName,
        'status': 'rejected',
        'remark': rejectionReason,
        'description': rejectionDescription,
        'timestamp': timestamp,
      });
    } catch (e) {
      print('Error updating user document status: $e');
      throw Exception('Failed to update document status');
    }
  }
}
