import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naradaflow/CONTROLLERS/USER/2nd_service/documentsController.dart';

class DocumentApplicationView extends StatelessWidget {
  final DocumentController controller = Get.put(DocumentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Document Application',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Document Selection Section
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // Predefined Documents Dropdown
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() => DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Document',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.file_copy),
                          ),
                          items: [
                            // Predefined documents
                            ...controller.predefinedDocuments
                                .map((doc) => DropdownMenuItem(
                                      value: doc.name,
                                      child: Text(doc.name),
                                    ))
                                .toList(),
                            // Custom document option
                            DropdownMenuItem(
                              value: 'custom',
                              child: Text('Custom Document'),
                            ),
                          ],
                          value: controller.selectedDocument.value.isNotEmpty
                              ? controller.selectedDocument.value
                              : null,
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedDocument.value = value;
                            }
                          },
                          hint: Text('Choose a Document'),
                        )),
                  ),

                  // Custom Document Input (Shown when 'Custom Document' is selected)
                  Obx(() {
                    return controller.selectedDocument.value == 'custom'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) =>
                                  controller.customDocumentName.value = value,
                              decoration: InputDecoration(
                                labelText: 'Enter Custom Document Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.document_scanner),
                              ),
                            ),
                          )
                        : SizedBox.shrink();
                  }),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Purpose Input
            TextField(
              onChanged: (value) => controller.purpose.value = value,
              decoration: InputDecoration(
                labelText: 'Purpose of Document',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),

            // File Upload Section
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Supporting Document',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(() => controller.uploadedFile.value != null
                      ? ListTile(
                          leading: Icon(Icons.file_present),
                          title: Text(
                            controller.uploadedFile.value!.path.split('/').last,
                            style: GoogleFonts.inter(),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () =>
                                controller.uploadedFile.value = null,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton.icon(
                            onPressed: () => controller.pickFile(),
                            icon: Icon(Icons.upload_file),
                            label: Text('Upload Supporting Document'),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.blue),
                            ),
                          ),
                        )),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Submit Button
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => _submitApplication(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Submit Application',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                )),
          ],
        ),
      ),
    );
  }

  void _submitApplication() async {
    // Validation
    if (controller.selectedDocument.value.isEmpty &&
        controller.customDocumentName.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a document or enter a custom document name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (controller.purpose.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please provide a purpose for the document',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Submit application
    bool success = await controller.submitDocumentApplication();
    if (success) {
      Get.snackbar(
        'Success',
        'Document application submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      controller.resetForm();
    } else {
      Get.snackbar(
        'Error',
        controller.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
