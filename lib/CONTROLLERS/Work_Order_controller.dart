import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/login_controller.dart';
import 'package:naradaflow/MODELS/USER/workdocModel.dart';

class WorkOrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoginController _loginController = Get.find();

  // Observable list of work orders
  RxList<WorkOrderModel> workOrders = <WorkOrderModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Predefined step order
  final List<String> _stepOrder = [
    'Initial_submission',
    'Admin',
    'HOD',
    'Ready'
  ];

  // Fetch work orders
  Future<void> fetchWorkOrders() async {
    try {
      // Set loading state
      isLoading.value = true;
      errorMessage.value = '';
      workOrders.clear();

      // Get student ID from login controller
      String studentId = _loginController.loginId.value;

      // Fetch all documents in the Documents subcollection
      QuerySnapshot documentsSnapshot = await _firestore
          .collection('USERS')
          .doc('MCA')
          .collection('MEN')
          .doc(studentId)
          .collection('Documents')
          .get();

      // Process each document
      for (var docSnapshot in documentsSnapshot.docs) {
        // Check Ready status in Status subcollection
        DocumentSnapshot readyStatusDoc = await _firestore
            .collection('USERS')
            .doc('MCA')
            .collection('MEN')
            .doc(studentId)
            .collection('Documents')
            .doc(docSnapshot.id)
            .collection('Status')
            .doc('Ready')
            .get();

        // Check if Ready status is not 'accepted'
        Map<String, dynamic>? readyStatusData =
            readyStatusDoc.data() as Map<String, dynamic>?;

        if (readyStatusData == null ||
            readyStatusData['status'] == null ||
            readyStatusData['status'] != 'rejected' ||
            readyStatusData['status'].toString().isEmpty) {
          // Fetch all status steps
          QuerySnapshot statusSnapshot = await _firestore
              .collection('USERS')
              .doc('MCA')
              .collection('MEN')
              .doc(studentId)
              .collection('Documents')
              .doc(docSnapshot.id)
              .collection('Status')
              .get();

          // Process status steps
          List<WorkOrderStatusStep> statusSteps =
              statusSnapshot.docs.map((statusDoc) {
            return WorkOrderStatusStep.fromFirestore(
                statusDoc.id, statusDoc.data() as Map<String, dynamic>);
          }).toList();

          // Sort steps based on predefined order
          statusSteps.sort((a, b) => _stepOrder
              .indexOf(a.stepName)
              .compareTo(_stepOrder.indexOf(b.stepName)));

          // Create and add work order
          workOrders.add(WorkOrderModel(
            documentId: docSnapshot.id,
            studentId: studentId,
            steps: statusSteps,
          ));
        }
      }

      // Clear loading state
      isLoading.value = false;
    } catch (e) {
      print('Error fetching work orders: $e');
      errorMessage.value = 'Failed to fetch work orders';
      isLoading.value = false;
    }
  }

  // Method to get a specific work order by document ID
  WorkOrderModel? getWorkOrderByDocumentId(String documentId) {
    try {
      return workOrders.firstWhere((order) => order.documentId == documentId);
    } catch (e) {
      return null;
    }
  }
}
