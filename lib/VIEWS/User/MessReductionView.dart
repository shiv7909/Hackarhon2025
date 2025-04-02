import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naradaflow/CONTROLLERS/USER/MessReductionController.dart';

class MessReductionView extends StatelessWidget {
  final MessReductionController _controller =
      Get.put(MessReductionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mess Reduction Request',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDateInputRow(context),
              const SizedBox(height: 16),
              _buildReasonInput(),
              const SizedBox(height: 16),
              // _buildProofDocumentsSection(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateInputRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDateInput(
            controller: _controller.fromDateController,
            label: 'From Date',
            onTap: () => _controller.selectFromDate(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateInput(
            controller: _controller.toDateController,
            label: 'To Date',
            onTap: () => _controller.selectToDate(context),
          ),
        ),
      ],
    );
  }

  Widget _buildDateInput({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: onTap,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      readOnly: true,
      onTap: onTap,
    );
  }

  Widget _buildReasonInput() {
    return TextField(
      controller: _controller.reasonController,
      decoration: InputDecoration(
        labelText: 'Reason for Mess Reduction',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      maxLines: 3,
    );
  }

  // Widget _buildProofDocumentsSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Proof Documents',
  //         style: GoogleFonts.plusJakartaSans(
  //           fontWeight: FontWeight.bold,
  //           fontSize: 16,
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       ElevatedButton.icon(
  //         onPressed: _controller.pickProofDocument,
  //         icon: const Icon(Icons.upload_file),
  //         label: Text(
  //           'Upload Proof',
  //           style: GoogleFonts.plusJakartaSans(),
  //         ),
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.blue,
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       Obx(() => Wrap(
  //             spacing: 8,
  //             runSpacing: 8,
  //             children: _controller.proofDocuments.map((url) {
  //               return Stack(
  //                 children: [
  //                   Image.network(
  //                     url,
  //                     width: 100,
  //                     height: 100,
  //                     fit: BoxFit.cover,
  //                   ),
  //                   Positioned(
  //                     top: 0,
  //                     right: 0,
  //                     child: IconButton(
  //                       icon: const Icon(
  //                         Icons.close,
  //                         color: Colors.red,
  //                         size: 20,
  //                       ),
  //                       onPressed: () {
  //                         _controller.proofDocuments.remove(url);
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               );
  //             }).toList(),
  //           )),
  //     ],
  //   );
  // }

  Widget _buildSubmitButton() {
    return Obx(() => ElevatedButton(
          onPressed: _controller.isLoading.value
              ? null
              : _controller.submitMessReductionRequest,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: _controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  'Submit Request',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ));
  }
}
