import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkOrderModel {
  final String documentId;
  final String studentId;
  final List<WorkOrderStatusStep> steps;

  WorkOrderModel({
    required this.documentId,
    required this.studentId,
    required this.steps,
  });

  // Helper method to get display file name
  String getDisplayFileName() {
    // Try to extract file name from Initial_submission description
    var initialStep = steps.firstWhere(
      (step) => step.stepName.toLowerCase() == 'initial_submission',
      orElse: () => WorkOrderStatusStep(stepName: 'Unknown'),
    );

    return initialStep.description.isNotEmpty
        ? initialStep.description
        : documentId;
  }
}

class WorkOrderStatusStep {
  final String stepName;
  final String status;
  final String name;
  final String description;
  final DateTime? timestamp;

  WorkOrderStatusStep({
    required this.stepName,
    this.status = '',
    this.name = '',
    this.description = '',
    this.timestamp,
  });

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

  // Factory method to create from Firestore data
  factory WorkOrderStatusStep.fromFirestore(
      String stepName, Map<String, dynamic> data) {
    return WorkOrderStatusStep(
      stepName: stepName,
      status: data['status'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      timestamp: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()
          : null,
    );
  }
}
