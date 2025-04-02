// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:naradaflow/CONTROLLERS/Work_Order_controller.dart';
// // // import 'package:naradaflow/MODELS/USER/workdocModel.dart';
// // // import 'package:naradaflow/doc.dart';

// // // class ProgressDocumentsView extends StatelessWidget {
// // //   final ProgressDocumentsController _controller =
// // //       Get.put(ProgressDocumentsController());

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     // Fetch progress documents when view is created
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       _controller.fetchProgressDocuments();
// // //     });

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(
// // //           'In Progress Documents',
// // //           style: GoogleFonts.plusJakartaSans(
// // //             fontWeight: FontWeight.bold,
// // //           ),
// // //         ),
// // //         actions: [
// // //           IconButton(
// // //             icon: Icon(Icons.refresh),
// // //             onPressed: () => _controller.fetchProgressDocuments(),
// // //           ),
// // //         ],
// // //       ),
// // //       body: Obx(() {
// // //         // Loading state
// // //         if (_controller.isLoading.value) {
// // //           return Center(child: CircularProgressIndicator());
// // //         }

// // //         // Empty state
// // //         if (_controller.progressDocuments.isEmpty) {
// // //           return Center(
// // //             child: Text(
// // //               'No Documents in Progress',
// // //               style: GoogleFonts.plusJakartaSans(),
// // //             ),
// // //           );
// // //         }

// // //         // Documents list
// // //         return ListView.builder(
// // //           itemCount: _controller.progressDocuments.length,
// // //           itemBuilder: (context, index) {
// // //             final document = _controller.progressDocuments[index];
// // //             return _ProgressDocumentItem(
// // //               document: document,
// // //             );
// // //           },
// // //         );
// // //       }),
// // //     );
// // //   }
// // // }

// // // class _ProgressDocumentItem extends StatelessWidget {
// // //   final DocumentProgressModel document;

// // //   const _ProgressDocumentItem({
// // //     Key? key,
// // //     required this.document,
// // //   }) : super(key: key);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Card(
// // //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // //       child: ListTile(
// // //         title: Text(
// // //           document.fileName,
// // //           style: GoogleFonts.plusJakartaSans(
// // //             fontWeight: FontWeight.bold,
// // //           ),
// // //         ),
// // //         subtitle: Text(
// // //           'Document ID: ${document.documentId}',
// // //           style: GoogleFonts.plusJakartaSans(),
// // //         ),
// // //         trailing: Text(
// // //           'View Progress',
// // //           style: GoogleFonts.plusJakartaSans(
// // //             color: Colors.blue,
// // //             decoration: TextDecoration.underline,
// // //           ),
// // //         ),
// // //         onTap: () {
// // //           // Navigate to detailed timeline
// // //           Get.to(() => DocumentStatusTimeline(
// // //                 studentId: document.studentId,
// // //                 documentId: document.documentId,
// // //               ));
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:naradaflow/CONTROLLERS/Work_Order_controller.dart';
// // import 'package:naradaflow/MODELS/USER/Work_Order_model.dart';
// // import 'package:naradaflow/MODELS/USER/workdocModel.dart';
// // import 'package:naradaflow/doc.dart';

// // class WorkOrdersView extends StatelessWidget {
// //   final WorkOrderController _controller = Get.put(WorkOrderController());

// //   WorkOrdersView({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     // Fetch work orders when view is created
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _controller.fetchWorkOrders();
// //     });

// //     return LayoutBuilder(
// //       builder: (context, constraints) {
// //         return Card(
// //           elevation: 4,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 _buildHeader(constraints),
// //                 const SizedBox(height: 16),
// //                 _buildWorkOrdersList(constraints),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildHeader(BoxConstraints constraints) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           'Current Work Orders',
// //           style: GoogleFonts.plusJakartaSans(
// //             fontSize: constraints.maxWidth < 600 ? 16 : 20,
// //             fontWeight: FontWeight.bold,
// //             color: Colors.black87,
// //           ),
// //         ),
// //         IconButton(
// //           icon: Icon(
// //             Icons.refresh,
// //             color: Colors.grey[700],
// //             size: constraints.maxWidth < 600 ? 20 : 24,
// //           ),
// //           onPressed: () => _controller.fetchWorkOrders(),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildWorkOrdersList(BoxConstraints constraints) {
// //     return Obx(() {
// //       // Loading state
// //       if (_controller.isLoading.value) {
// //         return const Center(child: CircularProgressIndicator());
// //       }

// //       // Error state
// //       if (_controller.errorMessage.value.isNotEmpty) {
// //         return Center(
// //           child: Text(
// //             _controller.errorMessage.value,
// //             style: const TextStyle(color: Colors.red),
// //           ),
// //         );
// //       }

// //       // Empty state
// //       if (_controller.workOrders.isEmpty) {
// //         return _buildEmptyState(constraints);
// //       }

// //       // Work orders list
// //       return ListView.separated(
// //         shrinkWrap: true,
// //         physics: const NeverScrollableScrollPhysics(),
// //         itemCount: _controller.workOrders.length,
// //         separatorBuilder: (context, index) => const Divider(height: 1),
// //         itemBuilder: (context, index) {
// //           final workOrder = _controller.workOrders[index];
// //           return _WorkOrderItem(
// //             workOrder: workOrder,
// //             isCompact: constraints.maxWidth < 600,
// //           );
// //         },
// //       );
// //     });
// //   }

// //   Widget _buildEmptyState(BoxConstraints constraints) {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(
// //             Icons.inbox_outlined,
// //             size: constraints.maxWidth < 600 ? 60 : 80,
// //             color: Colors.grey[400],
// //           ),
// //           const SizedBox(height: 16),
// //           Text(
// //             'No Work Orders Found',
// //             style: GoogleFonts.plusJakartaSans(
// //               fontSize: constraints.maxWidth < 600 ? 14 : 18,
// //               color: Colors.grey[600],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _WorkOrderItem extends StatefulWidget {
// //   final WorkDocModel workOrder;
// //   final bool isCompact;

// //   const _WorkOrderItem({
// //     Key? key,
// //     required this.workOrder,
// //     this.isCompact = false,
// //   }) : super(key: key);

// //   @override
// //   __WorkOrderItemState createState() => __WorkOrderItemState();
// // }

// // class __WorkOrderItemState extends State<_WorkOrderItem> {
// //   bool _isHovered = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return LayoutBuilder(
// //       builder: (context, constraints) {
// //         return MouseRegion(
// //           onEnter: (_) => setState(() => _isHovered = true),
// //           onExit: (_) => setState(() => _isHovered = false),
// //           child: AnimatedContainer(
// //             duration: const Duration(milliseconds: 200),
// //             decoration: BoxDecoration(
// //               color: _isHovered ? Colors.grey[100] : Colors.white,
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
// //             child: widget.isCompact
// //                 ? _buildCompactLayout(constraints)
// //                 : _buildFullLayout(constraints),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildFullLayout(BoxConstraints constraints) {
// //     return Row(
// //       children: [
// //         Expanded(
// //           flex: 3,
// //           child: Text(
// //             _getDisplayFileName(),
// //             style: GoogleFonts.plusJakartaSans(
// //               fontWeight: FontWeight.bold,
// //               color: Colors.black87,
// //               fontSize: constraints.maxWidth < 600 ? 14 : 16,
// //             ),
// //           ),
// //         ),
// //         Expanded(
// //           flex: 2,
// //           child: Text(
// //             widget.workOrder.documentId,
// //             style: GoogleFonts.plusJakartaSans(
// //               fontSize: constraints.maxWidth < 600 ? 12 : 14,
// //             ),
// //           ),
// //         ),
// //         Expanded(
// //           flex: 2,
// //           child: _buildTrackLink(),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildCompactLayout(BoxConstraints constraints) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           _getDisplayFileName(),
// //           style: GoogleFonts.plusJakartaSans(
// //             fontWeight: FontWeight.bold,
// //             fontSize: constraints.maxWidth < 600 ? 14 : 16,
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text(
// //               widget.workOrder.documentId,
// //               style: GoogleFonts.plusJakartaSans(
// //                 fontSize: constraints.maxWidth < 600 ? 12 : 14,
// //               ),
// //             ),
// //             _buildTrackLink(),
// //           ],
// //         ),
// //       ],
// //     );
// //   }

// //   // Helper method to get display file name
// //   String _getDisplayFileName() {
// //     // Try to extract file name from Initial_submission description
// //     var initialStep = widget.workOrder.steps.firstWhere(
// //       (step) => step.stepName.toLowerCase() == 'initial_submission',
// //       orElse: () => WorkOrderStep(),
// //     );

// //     return initialStep.description.isNotEmpty
// //       ? initialStep.description
// //       : widget.workOrder.documentId;
// //   }

// //   Widget _buildTrackLink() {
// //     return GestureDetector(
// //       onTap: () {
// //         // Navigate to document status timeline
// //         Get.to(() => DocumentStatusTimeline(
// //           studentId: '24MCA00PY0020', // Replace with actual student ID
// //           documentId: widget.workOrder.documentId,
// //         ));
// //       },
// //       child: Text(
// //         'Track',
// //         style: GoogleFonts.plusJakartaSans(
// //           color: Colors.blue,
// //           decoration: TextDecoration.underline,
// //           fontSize: 14,
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:naradaflow/CONTROLLERS/Work_Order_controller.dart';
// import 'package:naradaflow/doc.dart'; // Import your DocumentStatusTimeline

// // MODEL
// class WorkOrderModel {
//   final String documentId;
//   final String studentId;
//   final List<WorkOrderStatusStep> steps;

//   WorkOrderModel({
//     required this.documentId,
//     required this.studentId,
//     required this.steps,
//   });

//   // Helper method to get display file name
//   String getDisplayFileName() {
//     // Try to extract file name from Initial_submission description
//     var initialStep = steps.firstWhere(
//       (step) => step.stepName.toLowerCase() == 'initial_submission',
//       orElse: () => WorkOrderStatusStep(stepName: 'Unknown'),
//     );

//     return initialStep.description.isNotEmpty
//         ? initialStep.description
//         : documentId;
//   }
// }

// class WorkOrderStatusStep {
//   final String stepName;
//   final String status;
//   final String name;
//   final String description;
//   final DateTime? timestamp;

//   WorkOrderStatusStep({
//     required this.stepName,
//     this.status = '',
//     this.name = '',
//     this.description = '',
//     this.timestamp,
//   });

//   // Helper method to get status color
//   Color getStatusColor() {
//     switch (status.toLowerCase()) {
//       case 'success':
//       case 'accepted':
//       case 'ready':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   // Helper method to get status icon
//   IconData getStatusIcon() {
//     switch (status.toLowerCase()) {
//       case 'success':
//       case 'accepted':
//       case 'ready':
//         return Icons.check_circle;
//       case 'pending':
//         return Icons.pending;
//       case 'rejected':
//         return Icons.cancel;
//       default:
//         return Icons.help_outline;
//     }
//   }

//   // Format timestamp
//   String get formattedTimestamp {
//     if (timestamp == null) return '';
//     return DateFormat('MMM d, yyyy at h:mm a').format(timestamp!);
//   }
// }

// // CONTROLLER

// // VIEW
// class WorkOrdersView extends StatelessWidget {
//   final WorkOrderController _controller = Get.put(WorkOrderController());

//   WorkOrdersView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Fetch work orders when view is created
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _controller.fetchWorkOrders();
//     });

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeader(constraints),
//                 const SizedBox(height: 16),
//                 _buildWorkOrdersList(constraints),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHeader(BoxConstraints constraints) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Text(
//             'Current Work Orders',
//             style: GoogleFonts.plusJakartaSans(
//               fontSize: constraints.maxWidth < 600 ? 16 : 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         IconButton(
//           icon: Icon(
//             Icons.refresh,
//             color: Colors.grey[700],
//             size: constraints.maxWidth < 600 ? 20 : 24,
//           ),
//           onPressed: () => _controller.fetchWorkOrders(),
//         ),
//       ],
//     );
//   }

//   Widget _buildWorkOrdersList(BoxConstraints constraints) {
//     return Obx(() {
//       // Loading state
//       if (_controller.isLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       // Error state
//       if (_controller.errorMessage.value.isNotEmpty) {
//         return Center(
//           child: Text(
//             _controller.errorMessage.value,
//             style: const TextStyle(color: Colors.red),
//           ),
//         );
//       }

//       // Empty state
//       if (_controller.workOrders.isEmpty) {
//         return _buildEmptyState(constraints);
//       }

//       // Work orders list
//       return ListView.separated(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: _controller.workOrders.length,
//         separatorBuilder: (context, index) => const Divider(height: 1),
//         itemBuilder: (context, index) {
//           final workOrder = _controller.workOrders[index];
//           return _WorkOrderItem(
//             workOrder: workOrder,
//             isCompact: constraints.maxWidth < 600,
//           );
//         },
//       );
//     });
//   }

//   Widget _buildEmptyState(BoxConstraints constraints) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.inbox_outlined,
//             size: constraints.maxWidth < 600 ? 60 : 80,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No Work Orders Found',
//             style: GoogleFonts.plusJakartaSans(
//               fontSize: constraints.maxWidth < 600 ? 14 : 18,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // WORK ORDER ITEM
// class _WorkOrderItem extends StatefulWidget {
//   final WorkOrderModel workOrder;
//   final bool isCompact;

//   const _WorkOrderItem({
//     Key? key,
//     required this.workOrder,
//     this.isCompact = false,
//   }) : super(key: key);

//   @override
//   __WorkOrderItemState createState() => __WorkOrderItemState();
// }

// class __WorkOrderItemState extends State<_WorkOrderItem> {
//   bool _isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return MouseRegion(
//           onEnter: (_) => setState(() => _isHovered = true),
//           onExit: (_) => setState(() => _isHovered = false),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             decoration: BoxDecoration(
//               color: _isHovered ? Colors.grey[100] : Colors.white,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             child: widget.isCompact
//                 ? _buildCompactLayout(constraints)
//                 : _buildFullLayout(constraints),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFullLayout(BoxConstraints constraints) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 3,
//           child: Text(
//             widget.workOrder.getDisplayFileName(),
//             style: GoogleFonts.plusJakartaSans(
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//               fontSize: constraints.maxWidth < 600 ? 14 : 16,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           flex: 2,
//           child: Text(
//             widget.workOrder.documentId,
//             style: GoogleFonts.plusJakartaSans(
//               fontSize: constraints.maxWidth < 600 ? 12 : 14,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         const SizedBox(width: 8),
//         _buildTrackLink(),
//       ],
//     );
//   }

//   Widget _buildCompactLayout(BoxConstraints constraints) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.workOrder.getDisplayFileName(),
//           style: GoogleFonts.plusJakartaSans(
//             fontWeight: FontWeight.bold,
//             fontSize: constraints.maxWidth < 600 ? 14 : 16,
//           ),
//           overflow: TextOverflow.ellipsis,
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 widget.workOrder.documentId,
//                 style: GoogleFonts.plusJakartaSans(
//                   fontSize: constraints.maxWidth < 600 ? 12 : 14,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             _buildTrackLink(),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildTrackLink() {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to document status timeline
//         Get.to(() => DocumentStatusTimeline(
//               studentId: widget.workOrder.studentId,
//               documentId: widget.workOrder.documentId,
//             ));
//       },
//       child: Text(
//         'Track',
//         style: GoogleFonts.plusJakartaSans(
//           color: Colors.blue,
//           decoration: TextDecoration.underline,
//           fontSize: 14,
//         ),
//       ),
//     );
//   }
// }

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
