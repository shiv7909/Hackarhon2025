import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naradaflow/CONTROLLERS/Work_Order_controller.dart';
import 'package:naradaflow/MODELS/USER/Work_Order_model.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CurrentWorkOrders extends StatelessWidget {
  CurrentWorkOrders({Key? key}) : super(key: key);

  final works_Orders_controllers controller =
      Get.put(works_Orders_controllers());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.workOrders.isEmpty) {
                  return _buildEmptyState(context);
                }

                return _buildWorkOrderList(constraints);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Current Work Orders',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.grey[700]),
            onPressed: () => controller.fetchWorkOrders(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
      ),
    );
  }

  Widget _buildWorkOrderList(BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        children: controller.workOrders.map((order) {
          return _WorkOrderItem(
            order: order,
            onTrackTap: () => _showTrackDetailsDialog(order),
            isCompact: constraints.maxWidth < 600,
          );
        }).toList(),
      ),
    );
  }

  void _showTrackDetailsDialog(WorkOrderModel order) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: Get.width * 0.8,
          height: Get.height * 0.7,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogHeader(order),
              const SizedBox(height: 16),
              Expanded(
                child: _buildTimelineSteps(order),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader(WorkOrderModel order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${order.fileName} - Tracking Details',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }

  Widget _buildTimelineSteps(WorkOrderModel order) {
    return ListView.builder(
      itemCount: order.steps.length,
      itemBuilder: (context, index) {
        final step = order.steps[index];
        return TimelineTile(
          alignment: TimelineAlign.start,
          indicatorStyle: IndicatorStyle(
            width: 40,
            color: controller.getStatusColor(step.status),
            iconStyle: IconStyle(
              color: Colors.white,
              iconData: controller.getStatusIcon(step.status),
            ),
          ),
          beforeLineStyle: LineStyle(
            color: controller.getStatusColor(step.status),
          ),
          endChild: _buildStepDetailsCard(step),
        );
      },
    );
  }

  Widget _buildStepDetailsCard(WorkOrderStep step) {
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
            step.name,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            step.description,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.grey[700],
            ),
          ),
          ..._buildOptionalStepDetails(step),
        ],
      ),
    );
  }

  List<Widget> _buildOptionalStepDetails(WorkOrderStep step) {
    List<Widget> details = [];

    if (step.admin.isNotEmpty) {
      details.addAll([
        const SizedBox(height: 8),
        Text(
          'Admin: ${step.admin}',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      ]);
    }

    if (step.remark.isNotEmpty) {
      details.addAll([
        const SizedBox(height: 8),
        Text(
          'Remark: ${step.remark}',
          style: GoogleFonts.plusJakartaSans(
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
          ),
        ),
      ]);
    }

    if (step.date.isNotEmpty) {
      details.addAll([
        const SizedBox(height: 8),
        Text(
          'Date: ${step.date}',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.grey[600],
          ),
        ),
      ]);
    }

    return details;
  }
}

// The _WorkOrderItem class remains the same as in the previous implementation
class _WorkOrderItem extends StatefulWidget {
  final WorkOrderModel order;
  final VoidCallback onTrackTap;
  final bool isCompact;

  const _WorkOrderItem({
    Key? key,
    required this.order,
    required this.onTrackTap,
    this.isCompact = false,
  }) : super(key: key);

  @override
  __WorkOrderItemState createState() => __WorkOrderItemState();
}

class __WorkOrderItemState extends State<_WorkOrderItem> {
  bool _isHovered = false;
  final works_Orders_controllers _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _isHovered ? Colors.grey[100] : Colors.white,
              border: Border(
                bottom:
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: widget.isCompact
                ? _buildCompactLayout(constraints)
                : _buildFullLayout(constraints),
          ),
        );
      },
    );
  }

  Widget _buildFullLayout(BoxConstraints constraints) {
    return Row(
      children: [
        _buildColumn('File Name', widget.order.fileName, flex: 3),
        _buildColumn('Name', widget.order.name, flex: 2),
        _buildStatusColumn(),
        _buildTrackColumn(),
      ],
    );
  }

  Widget _buildCompactLayout(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.order.fileName,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.order.name,
              style: GoogleFonts.plusJakartaSans(),
            ),
            _buildStatusChip(),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: widget.onTrackTap,
          child: Text(
            widget.order.track,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColumn(String title, String value, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        value,
        style: GoogleFonts.plusJakartaSans(
          fontWeight:
              title == 'File Name' ? FontWeight.bold : FontWeight.normal,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildStatusColumn() {
    return Expanded(
      flex: 2,
      child: _buildStatusChip(),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _controller.getStatusColor(widget.order.status.toLowerCase()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.order.status,
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTrackColumn() {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: widget.onTrackTap,
        child: Text(
          widget.order.track,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
