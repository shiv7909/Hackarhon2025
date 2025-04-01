import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/login_controller.dart';
import 'package:naradaflow/Examine.dart/documentsModel.dart';

class DocumentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoginController loginController = Get.find<LoginController>();

  // final FirebaseStorage _storage = FirebaseStorage.instance;
  // final LoginController _loginController = Get.find<LoginController>();

  // Predefined documents list
  final RxList<DocumentModel> predefinedDocuments = <DocumentModel>[
    DocumentModel(
      id: '1',
      name: 'Bonafide Certificate',
      description: 'Certificate of bonafide student',
      requiresUpload: false,
    ),
    DocumentModel(
      id: '2',
      name: 'Bonafide ',
      description: 'Certificate of bonafide student',
      requiresUpload: false,
    ),
    DocumentModel(
      id: '3',
      name: 'Transfer Certificate',
      description: 'Transfer certificate from previous institution',
      requiresUpload: false,
    ),
    DocumentModel(
      id: '4',
      name: 'Transcript',
      description: 'Academic transcript',
      requiresUpload: false,
    ),
  ].obs;

  final Rx<File?> uploadedFile = Rx<File?>(null);
  final RxString selectedDocument = ''.obs;
  final RxString purpose = ''.obs;
  final RxString customDocumentName = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // File Picker
  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        uploadedFile.value = File(result.files.single.path!);
      }
    } catch (e) {
      errorMessage.value = 'File selection failed: ${e.toString()}';
    }
  }

  // there is not storage medium i can do fastly so i wish to commect this code!!

  // Future<String?> _uploadFileToStorage() async {
  //   if (uploadedFile.value == null) return null;

  //   try {
  //     String fileName =
  //         'documents/${_loginController.loginId.value}/${DateTime.now().millisecondsSinceEpoch}';

  //     final Reference storageReference = _storage.ref().child(fileName);
  //     final UploadTask uploadTask =
  //         storageReference.putFile(uploadedFile.value!);

  //     final TaskSnapshot downloadUrl = await uploadTask;
  //     return await downloadUrl.ref.getDownloadURL();
  //   } catch (e) {
  //     errorMessage.value = 'File upload failed: ${e.toString()}';
  //     return null;
  //   }
  // }

  // Submit Document Application
  Future<bool> submitDocumentApplication() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate inputs
      if (selectedDocument.value.isEmpty) {
        errorMessage.value = 'Please select a document';
        return false;
      }

      if (purpose.value.isEmpty) {
        errorMessage.value = 'Please provide a purpose';
        return false;
      }

      // // Upload file if required
      // String? fileUrl;
      // if (uploadedFile.value != null) {
      //   fileUrl = await _uploadFileToStorage();
      //   if (fileUrl == null) return false;
      // }

      // Prepare document application
      DocumentApplicationModel application = DocumentApplicationModel(
        documentName: selectedDocument.value,
        purpose: purpose.value,
        customDocumentName: customDocumentName.value,
        // uploadedFileUrl: fileUrl,
      );
      String loginId = loginController.loginId.value;
      // Save to Firestore
      // Save the application to the user's documents collection with a custom document ID
      // Get the current timestamp
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

// Save the application to the user's documents collection with a custom document ID
// Get the current timestamp
      // String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

// Save the application to the user's documents collection with a custom document ID
      await _firestore
          .collection('USERS')
          .doc('MCA')
          .collection('MEN')
          .doc(loginId)
          .collection('Documents')
          .doc(
              'DOC_${loginId}_$timestamp') // Set the document ID to 'DOC_<LoginID>_<timestamp>'
          .set(application.toJson()) // Use set instead of add
          .then((_) async {
        // Create the "Status" subcollection and documents
        await _firestore
            .collection('USERS')
            .doc('MCA')
            .collection('MEN')
            .doc(loginId)
            .collection('Documents')
            .doc('DOC_${loginId}_$timestamp')
            .collection('Status')
            .doc('Admin1')
            .set({
          'description': '',
          'name': '',
          'remark': '',
          'status': '',
        });

        await _firestore
            .collection('USERS')
            .doc('MCA')
            .collection('MEN')
            .doc(loginId)
            .collection('Documents')
            .doc('DOC_${loginId}_$timestamp')
            .collection('Status')
            .doc('Admin2')
            .set({
          'description': '',
          'name': '',
          'remark': '',
          'status': '',
        });

        await _firestore
            .collection('USERS')
            .doc('MCA')
            .collection('MEN')
            .doc(loginId)
            .collection('Documents')
            .doc('DOC_${loginId}_$timestamp')
            .collection('Status')
            .doc('Initial_submission')
            .set({
          'Date and Time': timestamp,
          'description': 'successfully placed a request',
          'name': 'User Name', // Replace with actual user name
          'remark': '',
          'status': 'success',
        });

        await _firestore
            .collection('USERS')
            .doc('MCA')
            .collection('MEN')
            .doc(loginId)
            .collection('Documents')
            .doc('DOC_${loginId}_$timestamp')
            .collection('Status')
            .doc('Ready')
            .set({
          'description': '',
          'name': '',
          'remark': '',
          'status': '',
        });
      });
// Save the application to the admin's pending collection with a custom document ID
      await _firestore
          .collection('ADMINS')
          .doc('computer_science')
          .collection('admins')
          .doc('ADMIN1')
          .collection('Pending')
          .doc(
              'DOC_${loginId}_$timestamp') // Set the document ID to 'DOC_<LoginID>_<timestamp>'
          .set(application.toJson()); // Use set instead of add
      return true;
    } catch (e) {
      errorMessage.value = 'Submission failed: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Reset form
  void resetForm() {
    uploadedFile.value = null;
    selectedDocument.value = '';
    purpose.value = '';
    customDocumentName.value = '';
    errorMessage.value = '';
  }
}
