import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/login_controller.dart';
import 'package:naradaflow/MODELS/clearenceModel.dart';
import 'package:url_launcher/url_launcher.dart';

class ClearanceCertificateController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoginController _loginController = Get.find();

  // Observable clearance certificate data
  Rx<ClearanceCertificateModel> clearanceCertificate =
      ClearanceCertificateModel().obs;

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Fetch clearance certificate details
  Future<void> fetchClearanceCertificateDetails() async {
    try {
      // Set loading state
      isLoading.value = true;
      errorMessage.value = '';

      // Get student ID
      String studentId = _loginController.loginId.value;

      // Fetch clearance certificate document
      DocumentSnapshot doc = await _firestore
          .collection('USERS')
          .doc('MCA')
          .collection('MEN')
          .doc(studentId)
          .collection('clearence_certificates')
          .doc('clearence_certificates')
          .get();

      // Update clearance certificate data
      if (doc.exists) {
        clearanceCertificate.value =
            ClearanceCertificateModel.fromFirestore(doc);
      }

      // Clear loading state
      isLoading.value = false;
    } catch (e) {
      print('Error fetching clearance details: $e');
      errorMessage.value = 'Failed to fetch clearance details';
      isLoading.value = false;
    }
  }

  // Open Samarth Portal
  Future<void> openSamarthPortal() async {
    const samarthPortalUrl = 'https://your-samarth-portal-url.com';

    try {
      final Uri url = Uri.parse(samarthPortalUrl);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $samarthPortalUrl');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to open Samarth Portal',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Generate clearance certificate
  String generateClearanceCertificate() {
    return '''
CLEARANCE CERTIFICATE

This is to certify that the student has cleared all pending fees:

1. Mess Fee: ${clearanceCertificate.value.messPaid ? 'PAID' : 'NOT PAID'}
2. Library Fee: ${clearanceCertificate.value.libraryPaid ? 'PAID' : 'NOT PAID'}
3. Hostel Fee: ${clearanceCertificate.value.hostelPaid ? 'PAID' : 'NOT PAID'}

Overall Status: ${clearanceCertificate.value.isFullyPaid ? 'FULLY PAID' : 'PARTIALLY PAID'}

Date of Issue: ${DateTime.now().toString().split(' ')[0]}
    ''';
  }
}
