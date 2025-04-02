import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/login_controller.dart';
import 'package:naradaflow/MODELS/ADMIN/RequestModel.dart';

class RequestController extends GetxController
    with GetTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoginController _loginController = Get.find();

  // Observable lists for different request types
  RxList<RequestModel> pendingRequests = <RequestModel>[].obs;
  RxList<RequestModel> completedRequests = <RequestModel>[].obs;
  RxList<RequestModel> rejectedRequests = <RequestModel>[].obs;

  // Rx variable to store admin ID
  RxString adminId = ''.obs;

  // Current tab index
  RxInt currentTabIndex = 0.obs;

  // Tab controller for managing tabs
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    // Initialize TabController with 3 tabs
    tabController = TabController(length: 3, vsync: this);

    // Initialize admin ID
    ever(_loginController.loginId, (value) {
      adminId.value = value;
      fetchRequests('Pending');
    });

    // Fetch initial pending requests if login ID is already available
    if (_loginController.loginId.value.isNotEmpty) {
      adminId.value = _loginController.loginId.value;
      fetchRequests('Pending');
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> refreshCurrentTabRequests() async {
    String status;
    switch (currentTabIndex.value) {
      case 0:
        status = 'Pending';
        break;
      case 1:
        status = 'Completed';
        break;
      case 2:
        status = 'Rejected';
        break;
      default:
        status = 'Pending';
    }

    await fetchRequests(status);
  }

  // Method to remove a request from pending list
  void removeRequestFromPending(RequestModel request) {
    pendingRequests.remove(request);
  }

  // Method to add a request to completed list
  void addRequestToCompleted(RequestModel request) {
    completedRequests.add(request);
  }

  // Method to add a request to rejected list
  void addRequestToRejected(RequestModel request) {
    rejectedRequests.add(request);
  }

  Future<void> fetchRequests(String status) async {
    // Check if admin ID is valid
    if (adminId.value.isEmpty) {
      print('Admin ID is empty. Cannot fetch requests.');
      return;
    }

    try {
      // Clear existing requests for the specific status
      _clearRequestsList(status);

      print('Fetching $status requests for admin: ${adminId.value}');

      // Fetch documents from Firestore
      QuerySnapshot requestsSnapshot = await _firestore
          .collection('ADMINS')
          .doc('computer_science')
          .collection('admins')
          .doc(adminId.value)
          .collection(status)
          .get();

      print(
          'Number of ${status.toLowerCase()} requests found: ${requestsSnapshot.docs.length}');

      // Process each document
      List<RequestModel> requests = [];
      for (var doc in requestsSnapshot.docs) {
        // Safely extract document data
        Map<String, dynamic>? docData = doc.data() as Map<String, dynamic>?;

        if (docData == null) {
          print('Skipping document with null data');
          continue;
        }

        // Print document data for debugging
        print('Document Data: $docData');

        try {
          // Fetch student details
          // Use a method to get student ID from document data
          String studentId = _extractStudentId(docData);

          DocumentSnapshot studentSnapshot = await _firestore
              .collection('USERS')
              .doc('MCA')
              .collection('MEN')
              .doc(studentId)
              .get();

          // Safely get student data
          Map<String, dynamic>? studentData =
              studentSnapshot.data() as Map<String, dynamic>?;

          // Print student data for debugging
          print('Student Data: $studentData');

          // Create RequestModel only if both doc and student data are not null
          if (studentData != null) {
            RequestModel request =
                RequestModel.fromJson(doc.id, docData, studentData);
            requests.add(request);

            // Print created request for debugging
            print(
                'Created Request: ${request.documentName}, ${request.studentName}');
          }
        } catch (studentFetchError) {
          print('Error fetching student data: $studentFetchError');
        }
      }

      // Update the appropriate list based on status
      _updateRequestsList(status, requests);

      // Print final list for verification
      print(
          'Total ${status.toLowerCase()} requests after processing: ${requests.length}');
    } catch (e) {
      print('Error fetching $status requests: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch $status requests',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Method to extract student ID from document data
  String _extractStudentId(Map<String, dynamic> docData) {
    // Try different ways to extract student ID
    if (docData.containsKey('studentId')) {
      return docData['studentId'];
    }

    if (docData.containsKey('student_id')) {
      return docData['student_id'];
    }

    // Fallback to a default student ID if no ID is found
    return '24MCA00PY0020';
  }

  void _clearRequestsList(String status) {
    switch (status) {
      case 'Pending':
        pendingRequests.clear();
        break;
      case 'Completed':
        completedRequests.clear();
        break;
      case 'Rejected':
        rejectedRequests.clear();
        break;
    }
  }

  void _updateRequestsList(String status, List<RequestModel> requests) {
    switch (status) {
      case 'Pending':
        pendingRequests.addAll(requests);
        print('Updated Pending Requests: ${pendingRequests.length}');
        break;
      case 'Completed':
        completedRequests.addAll(requests);
        print('Updated Completed Requests: ${completedRequests.length}');
        break;
      case 'Rejected':
        rejectedRequests.addAll(requests);
        print('Updated Rejected Requests: ${rejectedRequests.length}');
        break;
    }
  }
}
