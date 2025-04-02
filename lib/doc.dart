import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DocumentStatusModel {
  final String documentId;
  final String stepName;
  final String status;
  final String name;
  final String description;
  final String remark;
  final DateTime? timestamp;

  DocumentStatusModel({
    required this.documentId,
    required this.stepName,
    this.status = '',
    this.name = '',
    this.description = '',
    this.remark = '',
    this.timestamp,
  });

  // Factory method to create from Firestore data
  factory DocumentStatusModel.fromFirestore(
      String documentId, String stepName, Map<String, dynamic> data) {
    return DocumentStatusModel(
      documentId: documentId,
      stepName: stepName,
      status: data['status'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      remark: data['remark'] ?? '',
      timestamp: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()
          : null,
    );
  }

  // Helper method to get status color
  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'success':
      case 'accepted':
      case 'ready':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get status icon
  IconData getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'success':
      case 'accepted':
      case 'ready':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  // Format timestamp
  String get formattedTimestamp {
    if (timestamp == null) return '';
    return DateFormat('MMM d, yyyy at h:mm a').format(timestamp!);
  }

  // Check if step is completed
  bool get isCompleted {
    final completedStatuses = ['success', 'accepted', 'ready'];
    return completedStatuses.contains(status.toLowerCase());
  }
}

class DocumentStatusController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable list of document status steps
  RxList<DocumentStatusModel> documentStatusSteps = <DocumentStatusModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Predefined step order
  final List<String> _stepOrder = [
    'Initial_submission',
    'Admin',
    'HOD',
    'Ready'
  ];

  // Fetch document status
  Future<void> fetchDocumentStatus(
      {required String studentId, required String documentId}) async {
    try {
      // Set loading state
      isLoading.value = true;
      errorMessage.value = '';
      documentStatusSteps.clear();

      // Fetch status for each step
      for (String stepName in _stepOrder) {
        try {
          DocumentSnapshot stepDoc = await _firestore
              .collection('USERS')
              .doc('MCA')
              .collection('MEN')
              .doc(studentId)
              .collection('Documents')
              .doc(documentId)
              .collection('Status')
              .doc(stepName)
              .get();

          if (stepDoc.exists) {
            // Convert to map
            Map<String, dynamic> stepData =
                stepDoc.data() as Map<String, dynamic>;

            // Create and add status model
            DocumentStatusModel statusModel = DocumentStatusModel.fromFirestore(
                documentId, stepName, stepData);
            documentStatusSteps.add(statusModel);
          }
        } catch (stepError) {
          print('Error fetching step $stepName: $stepError');
        }
      }

      // Sort steps based on predefined order
      documentStatusSteps.sort((a, b) => _stepOrder
          .indexOf(a.stepName)
          .compareTo(_stepOrder.indexOf(b.stepName)));

      // Clear loading state
      isLoading.value = false;
    } catch (e) {
      print('Error fetching document status: $e');
      errorMessage.value = 'Failed to fetch document status';
      isLoading.value = false;
    }
  }
}

class DocumentStatusTimeline extends StatelessWidget {
  final String studentId;
  final String documentId;

  DocumentStatusTimeline({
    Key? key,
    required this.studentId,
    required this.documentId,
  }) : super(key: key);

  final DocumentStatusController _controller =
      Get.put(DocumentStatusController());

  @override
  Widget build(BuildContext context) {
    // Fetch document status when widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchDocumentStatus(
          studentId: studentId, documentId: documentId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Document Status Timeline',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.fetchDocumentStatus(
                studentId: studentId, documentId: documentId),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
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

          // Empty state
          if (_controller.documentStatusSteps.isEmpty) {
            return Center(
              child: Text(
                'No status information available',
                style: GoogleFonts.plusJakartaSans(),
              ),
            );
          }

          // Timeline
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _controller.documentStatusSteps.length,
            itemBuilder: (context, index) {
              final step = _controller.documentStatusSteps[index];

              return TimelineTile(
                alignment: TimelineAlign.start,
                isFirst: index == 0,
                isLast: index == _controller.documentStatusSteps.length - 1,
                indicatorStyle: IndicatorStyle(
                  width: 40,
                  color: step.getStatusColor(),
                  iconStyle: IconStyle(
                    color: Colors.white,
                    iconData: step.getStatusIcon(),
                  ),
                ),
                beforeLineStyle: LineStyle(
                  color: _getLineColor(step, index),
                ),
                afterLineStyle: LineStyle(
                  color: _getLineColor(step, index),
                ),
                endChild: _buildStepDetailsCard(step),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildStepDetailsCard(DocumentStatusModel step) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.stepName,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: step.getStatusColor(),
            ),
          ),
          const SizedBox(height: 8),
          // Description
          if (step.description.isNotEmpty)
            Text(
              step.description,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.grey[700],
              ),
            ),
          // Name
          if (step.name.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Processed By: ${step.name}',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ),
          // Remark
          if (step.remark.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Remark: ${step.remark}',
                style: GoogleFonts.plusJakartaSans(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ),
          // Timestamp
          if (step.timestamp != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Processed On: ${step.formattedTimestamp}',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Determine line color based on step status and index
  Color _getLineColor(DocumentStatusModel step, int index) {
    // If it's the last step or the step is not completed, use grey
    if (index == _controller.documentStatusSteps.length - 1 ||
        !step.isCompleted) {
      return Colors.grey.shade300;
    }

    // If step is completed, use green
    return Colors.green;
  }
}
