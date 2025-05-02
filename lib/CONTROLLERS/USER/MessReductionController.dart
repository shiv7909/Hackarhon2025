import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naradaflow/CONTROLLERS/login_controller.dart';
import 'package:naradaflow/MODELS/USER/MessReductionModel.dart';

class MessReductionController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final LoginController _loginController = Get.find();

  // Form controllers
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final reasonController = TextEditingController();

  // Observable lists and states
  RxList<String> proofDocuments = <String>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Date selection methods
  Future<void> selectFromDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      fromDateController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      toDateController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  // Image picker method
  Future<void> pickProofDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // if (pickedFile != null) {
    //   // Upload to Firebase Storage
    //   await _uploadProofDocument(File(pickedFile.path));
    // }
  }

  // // Upload proof document to Firebase Storage
  // Future<void> _uploadProofDocument(File file) async {
  //   try {
  //     // Generate a unique filename
  //     String fileName =
  //         'mess_reduction_proof_${DateTime.now().millisecondsSinceEpoch}.jpg';

  //     // Reference to storage location
  //     Reference storageRef =
  //         _storage.ref().child('mess_reduction_proofs').child(fileName);

  //     // Upload file
  //     await storageRef.putFile(file);

  //     // Get download URL
  //     String downloadURL = await storageRef.getDownloadURL();

  //     // Add to proof documents list
  //     proofDocuments.add(downloadURL);
  //   } catch (e) {
  //     print('Error uploading proof document: $e');
  //     Get.snackbar(
  //       'Upload Error',
  //       'Failed to upload proof document',
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  // Submit mess reduction request
  Future<void> submitMessReductionRequest() async {
    try {
      // Validate input
      if (!_validateInput()) return;

      // Set loading state
      isLoading.value = true;

      // Get student ID
      String studentId = _loginController.loginId.value;

      // Get request count to generate unique document name
      QuerySnapshot requestsSnapshot = await _firestore
          .collection('USERS')
          .doc('MCA')
          .collection('MEN')
          .doc(studentId)
          .collection('Mess_reduction')
          .get();

      // Create mess reduction model
      MessReductionModel request = MessReductionModel(
        studentId: studentId,
        fromDate: _parseDate(fromDateController.text),
        toDate: _parseDate(toDateController.text),
        reason: reasonController.text,
        //  proofDocuments: proofDocuments.value,
      );

      // Save to Firestore
      await _firestore
          .collection('USERS')
          .doc('MCA')
          .collection('MEN')
          .doc(studentId)
          .collection('Mess_reduction')
          .doc('mess_reduction-${requestsSnapshot.docs.length + 1}')
          .set(request.toJson());

      await _firestore
          .collection('ADMINS')
          .doc('computer_science')
          .collection('admins')
          .doc('Admin')
          .collection('Pending')
          .doc('mess_reduction-${requestsSnapshot.docs.length + 1}')
          .set(request.toJson());
      // Reset form
      _resetForm();

      // Show success message
      Get.snackbar(
        'Success',
        'Mess Reduction Request Submitted',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error submitting mess reduction request: $e');
      Get.snackbar(
        'Error',
        'Failed to submit request',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Input validation
  bool _validateInput() {
    if (fromDateController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Please select From Date');
      return false;
    }

    if (toDateController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Please select To Date');
      return false;
    }

    if (reasonController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Please provide a reason');
      return false;
    }

    // if (proofDocuments.isEmpty) {
    //   Get.snackbar('Validation Error', 'Please upload proof documents');
    //   return false;
    // }

    return true;
  }

  // Parse date string to DateTime
  DateTime _parseDate(String dateString) {
    List<String> parts = dateString.split('/');
    return DateTime(
        int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  }

  // Reset form
  void _resetForm() {
    fromDateController.clear();
    toDateController.clear();
    reasonController.clear();
    proofDocuments.clear();
  }
}
