import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naradaflow/clearencecontroller.dart';

class ClearanceCertificateView extends StatelessWidget {
  final ClearanceCertificateController _controller =
      Get.put(ClearanceCertificateController());

  @override
  Widget build(BuildContext context) {
    // Fetch clearance details when view is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchClearanceCertificateDetails();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fee Clearance Status',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.fetchClearanceCertificateDetails(),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Obx(() {
              // Loading state
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Error state
              if (_controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Text(
                    _controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              // Main content
              return _buildClearanceContent(constraints);
            });
          },
        ),
      ),
    );
  }

  Widget _buildClearanceContent(BoxConstraints constraints) {
    // Determine layout based on screen size
    bool isCompact = constraints.maxWidth < 600;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fee Status Section
                _buildFeeStatusSection(isCompact),

                const SizedBox(height: 16),

                // Action Buttons
                _buildActionButtons(isCompact),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeeStatusSection(bool isCompact) {
    return Column(
      children: [
        Text(
          'Fee Clearance Status',
          style: GoogleFonts.plusJakartaSans(
            fontSize: isCompact ? 18 : 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildFeeItem(
          'Mess Fee',
          _controller.clearanceCertificate.value.messPaid,
          isCompact,
        ),
        _buildFeeItem(
          'Library Fee',
          _controller.clearanceCertificate.value.libraryPaid,
          isCompact,
        ),
        _buildFeeItem(
          'Hostel Fee',
          _controller.clearanceCertificate.value.hostelPaid,
          isCompact,
        ),
      ],
    );
  }

  Widget _buildFeeItem(String title, bool isPaid, bool isCompact) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: isCompact ? 14 : 16,
            ),
          ),
          Text(
            isPaid ? 'PAID' : 'NOT PAID',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isCompact ? 14 : 16,
              color: isPaid ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isCompact) {
    // Check if fully paid
    bool isFullyPaid = _controller.clearanceCertificate.value.isFullyPaid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Generate Certificate Button
        ElevatedButton(
          onPressed: isFullyPaid ? () => _showCertificateDialog() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isFullyPaid ? Colors.green : Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            'Generate Clearance Certificate',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isCompact ? 14 : 16,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Samarth Portal Button
        OutlinedButton(
          onPressed: !isFullyPaid ? _controller.openSamarthPortal : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: !isFullyPaid ? Colors.blue : Colors.grey,
            side: BorderSide(
              color: !isFullyPaid ? Colors.blue : Colors.grey,
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            'Go to Payment Portal',
            style: GoogleFonts.plusJakartaSans(
              fontSize: isCompact ? 14 : 16,
            ),
          ),
        ),
      ],
    );
  }

  // Show Certificate Dialog
  void _showCertificateDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Fee Clearance Certificate',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          _controller.generateClearanceCertificate(),
          style: GoogleFonts.plusJakartaSans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: GoogleFonts.plusJakartaSans(),
            ),
          ),
        ],
      ),
    );
  }
}
