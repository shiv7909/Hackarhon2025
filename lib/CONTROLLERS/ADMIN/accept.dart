// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:naradaflow/CONTROLLERS/ADMIN/RequestController.dart';
// import 'package:naradaflow/CONTROLLERS/login_controller.dart';

// class AcceptController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final LoginController _authController = Get.find();
//   final RequestController _requestController = Get.put(RequestController());

//   // Helper method to extract document name
//   String _getDocumentName(Map<String, dynamic> documentData) {
//     // Priority order for document name
//     if (documentData['customDocumentName'] != null &&
//         documentData['customDocumentName'].toString().isNotEmpty) {
//       return documentData['customDocumentName'];
//     }

//     if (documentData['documentName'] != null &&
//         documentData['documentName'].toString().isNotEmpty) {
//       return documentData['documentName'];
//     }

//     // Fallback to a generic name if no specific name is found
//     return 'Unnamed Document';
//   }

//   Future<void> acceptDocument({
//     required String studentId,
//     required String documentId,
//     required Map<String, dynamic> documentData,
//     required String documentName, // Add document name parameter
//   }) async {
//     try {
//       // Get current timestamp
//       final timestamp = FieldValue.serverTimestamp();
//       final adminName = _authController.loginId.value;

//       // Add additional acceptance metadata to document data
//       documentData['acceptedAt'] = timestamp;

//       // 1. Add document to Completed subcollection
//       await _firestore
//           .collection('ADMINS')
//           .doc('computer_science')
//           .collection('admins')
//           .doc(adminName)
//           .collection('Completed')
//           .doc(documentId)
//           .set(documentData);

//       // 2. Remove from Pending subcollection
//       await _firestore
//           .collection('ADMINS')
//           .doc('computer_science')
//           .collection('admins')
//           .doc(adminName)
//           .collection('Pending')
//           .doc(documentId)
//           .delete();

//       // 3. Update Status subcollection in User's Documents
//       await _updateUserDocumentStatus(
//         studentId: studentId,
//         documentId: documentId,
//         documentName: documentName,
//         status: 'accepted',
//       );

//       // 4. Check if admin is HOD and update Ready status
//       if (adminName == 'HOD') {
//         await _updateReadyStatus(
//           studentId: studentId,
//           documentId: documentId,
//           documentName: documentName,
//         );
//       }

//       await _requestController.refreshCurrentTabRequests();
//     } catch (e) {
//       print('Error accepting document: $e');
//       throw Exception('Failed to accept document');
//     }
//   }

//   Future<void> _updateUserDocumentStatus({
//     required String studentId,
//     required String documentId,
//     required String documentName,
//     required String status,
//   }) async {
//     try {
//       // Get admin name from auth controller
//       String adminName = _authController.loginId.value;

//       // Get current timestamp
//       final timestamp = FieldValue.serverTimestamp();

//       // Detailed acceptance description
//       String acceptanceDescription =
//           "Document '$documentName' has been accepted by admin $adminName.";

//       // Update Initial_submission document in Status subcollection
//       await _firestore
//           .collection('USERS')
//           .doc('MCA')
//           .collection('MEN')
//           .doc(studentId)
//           .collection('Documents')
//           .doc(documentId)
//           .collection('Status')
//           .doc(adminName)
//           .update({
//         'name': adminName,
//         'status': status,
//         'remark': 'Document accepted',
//         'description': acceptanceDescription,
//         'timestamp': timestamp,
//       });

//       // Update Admin1 document in Status subcollection
//       await _firestore
//           .collection('USERS')
//           .doc('MCA')
//           .collection('MEN')
//           .doc(studentId)
//           .collection('Documents')
//           .doc(documentId)
//           .collection('Status')
//           .doc(adminName)
//           .update({
//         'name': adminName,
//         'status': status,
//         'remark': 'Document accepted',
//         'description': acceptanceDescription,
//         'timestamp': timestamp,
//       });
//     } catch (e) {
//       print('Error updating user document status: $e');
//       throw Exception('Failed to update document status');
//     }
//   }

//   // New method to update Ready status
//   Future<void> _updateReadyStatus({
//     required String studentId,
//     required String documentId,
//     required String documentName,
//   }) async {
//     try {
//       // Get current timestamp
//       final timestamp = FieldValue.serverTimestamp();

//       // Prepare ready status update
//       await _firestore
//           .collection('USERS')
//           .doc('MCA')
//           .collection('MEN')
//           .doc(studentId)
//           .collection('Documents')
//           .doc(documentId)
//           .collection('Status')
//           .doc('Ready')
//           .update({
//         'name': '', // Empty as per requirement
//         'status': 'ready',
//         'description': documentName, // Document name as description
//         'remark':
//             'Your documents are ready to take away by showing physical proof',
//         'timestamp': timestamp,
//       });
//     } catch (e) {
//       print('Error updating Ready status: $e');
//       throw Exception('Failed to update Ready status');
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/ADMIN/RequestController.dart';
import 'package:naradaflow/CONTROLLERS/login_controller.dart';

class AcceptController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoginController _authController = Get.find();
  final RequestController _requestController = Get.put(RequestController());

  Future<void> acceptDocument({
    required String studentId,
    required String documentId,
    required Map<String, dynamic> documentData,
    required String documentName,
  }) async {
    try {
      // Get current timestamp
      final timestamp = FieldValue.serverTimestamp();
      final adminName = _authController.loginId.value;

      // Add additional acceptance metadata to document data
      documentData['acceptedAt'] = timestamp;
      documentData['acceptedBy'] = adminName;

      // 1. Add document to Completed subcollection
      await _firestore
          .collection('ADMINS')
          .doc('computer_science')
          .collection('admins')
          .doc(adminName)
          .collection('Completed')
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
        documentName: documentName,
        status: 'accepted',
      );

      // 4. Check if current admin is not HOD, transfer to HOD's Pending
      if (adminName != 'HOD') {
        await _transferToHODPending(
          documentId: documentId,
          documentData: documentData,
          studentId: studentId,
        );
      } else {
        // If HOD, update Ready status
        await _updateReadyStatus(
          studentId: studentId,
          documentId: documentId,
          documentName: documentName,
        );
      }

      // 5. Refresh current tab's requests
      await _requestController.refreshCurrentTabRequests();
    } catch (e) {
      print('Error accepting document: $e');
      throw Exception('Failed to accept document');
    }
  }

  // Method to transfer document to HOD's Pending subcollection
  Future<void> _transferToHODPending({
    required String documentId,
    required Map<String, dynamic> documentData,
    required String studentId,
  }) async {
    try {
      // Add transfer metadata
      documentData['transferredAt'] = FieldValue.serverTimestamp();
      documentData['transferredBy'] = _authController.loginId.value;
      documentData['studentId'] = studentId;

      // Add to HOD's Pending subcollection
      await _firestore
          .collection('ADMINS')
          .doc('computer_science')
          .collection('admins')
          .doc('HOD')
          .collection('Pending')
          .doc(documentId)
          .set(documentData);
    } catch (e) {
      print('Error transferring document to HOD: $e');
      throw Exception('Failed to transfer document to HOD');
    }
  }

  // Existing methods (_updateUserDocumentStatus and _updateReadyStatus) remain the same
  Future<void> _updateUserDocumentStatus({
    required String studentId,
    required String documentId,
    required String documentName,
    required String status,
  }) async {
    try {
      // Get admin name from auth controller
      String adminName = _authController.loginId.value;

      // Get current timestamp
      final timestamp = FieldValue.serverTimestamp();

      // Detailed acceptance description
      String acceptanceDescription =
          "Document '$documentName' has been accepted by admin $adminName.";

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
        'status': status,
        'remark': 'Document accepted',
        'description': acceptanceDescription,
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
        'status': status,
        'remark': 'Document accepted',
        'description': acceptanceDescription,
        'timestamp': timestamp,
      });
    } catch (e) {
      print('Error updating user document status: $e');
      throw Exception('Failed to update document status');
    }
  }

  // New method to update Ready status
  Future<void> _updateReadyStatus({
    required String studentId,
    required String documentId,
    required String documentName,
  }) async {
    try {
      // Get current timestamp
      final timestamp = FieldValue.serverTimestamp();

      // Prepare ready status update
      await _firestore
          .collection('USERS')
          .doc('MCA')
          .collection('MEN')
          .doc(studentId)
          .collection('Documents')
          .doc(documentId)
          .collection('Status')
          .doc('Ready')
          .update({
        'name': '', // Empty as per requirement
        'status': 'ready',
        'description': documentName, // Document name as description
        'remark':
            'Your documents are ready to take away by showing physical proof',
        'timestamp': timestamp,
      });
    } catch (e) {
      print('Error updating Ready status: $e');
      throw Exception('Failed to update Ready status');
    }
  }
}
