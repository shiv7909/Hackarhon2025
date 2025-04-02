import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naradaflow/CONTROLLERS/Work_Order_controller.dart';
import 'package:naradaflow/MODELS/USER/workdocModel.dart';

import 'package:naradaflow/doc.dart'; // Import your DocumentStatusTimeline

class WorkOrdersView extends StatelessWidget {
  final WorkOrderController _controller = Get.put(WorkOrderController());

  WorkOrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch work orders when view is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchWorkOrders();
    });

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildWorkOrdersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Current Work Orders',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.grey[700],
          ),
          onPressed: () => _controller.fetchWorkOrders(),
        ),
      ],
    );
  }

  Widget _buildWorkOrdersList() {
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

      // Empty state
      if (_controller.workOrders.isEmpty) {
        return _buildEmptyState();
      }

      // Work orders list
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _controller.workOrders.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final workOrder = _controller.workOrders[index];
          return _WorkOrderItem(workOrder: workOrder);
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Work Orders Found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkOrderItem extends StatelessWidget {
  final WorkOrderModel workOrder;

  const _WorkOrderItem({
    Key? key,
    required this.workOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        workOrder.getDisplayFileName(),
        style: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        workOrder.documentId,
        style: GoogleFonts.plusJakartaSans(),
      ),
      trailing: TextButton(
        onPressed: () {
          // Navigate to document status timeline
          Get.to(() => DocumentStatusTimeline(
                studentId: workOrder.studentId,
                documentId: workOrder.documentId,
              ));
        },
        child: Text(
          'Track',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
