import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naradaflow/MODELS/USER/Work_Order_model.dart';

class works_Orders_controllers extends GetxController {
  // Observable list of work orders
  final RxList<WorkOrderModel> workOrders = <WorkOrderModel>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWorkOrders();
  }

  // Simulated data fetch (replace with actual data source)
  void fetchWorkOrders() {
    isLoading.value = true;

    // Simulated data - replace with actual data fetching
    List<WorkOrderModel> orders = [
      WorkOrderModel(
        fileName: 'Research Proposal',
        name: 'John Doe',
        status: 'In Progress',
        track: 'Preliminary Review',
        steps: [
          WorkOrderStep(
            name: 'Initial Submission',
            description: 'Document uploaded and primary check completed',
            status: 'completed',
            admin: 'Dr. Smith',
            remark: 'Document looks good, proceed to next stage',
            date: '2023-06-15',
          ),
          // Add more steps...
        ],
      ),
      // Add more orders...
    ];

    workOrders.value = orders;
    isLoading.value = false;
  }

  // Helper methods for status colors
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'in progress':
        return Icons.play_circle_fill;
      case 'pending':
        return Icons.warning_amber_rounded;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.radio_button_unchecked;
    }
  }
}
