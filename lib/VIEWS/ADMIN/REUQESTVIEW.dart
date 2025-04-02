import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/ADMIN/RequestController.dart';
import 'package:naradaflow/CONTROLLERS/ADMIN/accept.dart';
import 'package:naradaflow/CONTROLLERS/ADMIN/reject.dart';

import 'package:naradaflow/MODELS/ADMIN/RequestModel.dart';

class RequestsView extends StatelessWidget {
  const RequestsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final RequestController requestController = Get.put(RequestController());
    final AcceptController acceptController = Get.put(AcceptController());
    final RejectController rejectController = Get.put(RejectController());

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFFE8F5E9),
            child: TabBar(
              controller: requestController.tabController,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.green,
              onTap: (index) {
                switch (index) {
                  case 0:
                    requestController.fetchRequests('Pending');
                    break;
                  case 1:
                    requestController.fetchRequests('Completed');
                    break;
                  case 2:
                    requestController.fetchRequests('Rejected');
                    break;
                }
              },
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'Completed'),
                Tab(text: 'Rejected'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: requestController.tabController,
              children: [
                _buildPendingRequestsTable(
                    requestController, acceptController, rejectController),
                _buildCompletedRequestsTable(requestController),
                _buildRejectedRequestsTable(requestController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Pending Requests Table
  Widget _buildPendingRequestsTable(RequestController requestController,
      AcceptController acceptController, RejectController rejectController) {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Student ID')),
              DataColumn(label: Text('Student Name')),
              DataColumn(label: Text('Phone')),
              DataColumn(label: Text('Document Name')),
              DataColumn(label: Text('Purpose')),
              DataColumn(label: Text('Actions')),
            ],
            rows: requestController.pendingRequests.map((request) {
              return DataRow(cells: [
                DataCell(Text(request.studentId)),
                DataCell(Text(request.studentName)),
                DataCell(Text(request.studentPhone)),
                DataCell(Text(request.documentName!)),
                DataCell(Text(request.purpose)),
                DataCell(Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showAcceptDialog(acceptController, request);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Accept'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _showRejectDialog(rejectController, request);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Reject'),
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ));
  }

  // Completed Requests Table
  Widget _buildCompletedRequestsTable(RequestController requestController) {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Student ID')),
              DataColumn(label: Text('Student Name')),
              DataColumn(label: Text('Phone')),
              DataColumn(label: Text('Document Name')),
              DataColumn(label: Text('Purpose')),
            ],
            rows: requestController.completedRequests.map((request) {
              return DataRow(cells: [
                DataCell(Text(request.studentId)),
                DataCell(Text(request.studentName)),
                DataCell(Text(request.studentPhone)),
                DataCell(Text(request.documentName!)),
                DataCell(Text(request.purpose)),
              ]);
            }).toList(),
          ),
        ));
  }

  // Rejected Requests Table
  Widget _buildRejectedRequestsTable(RequestController requestController) {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Student ID')),
              DataColumn(label: Text('Student Name')),
              DataColumn(label: Text('Phone')),
              DataColumn(label: Text('Document Name')),
              DataColumn(label: Text('Purpose')),
            ],
            rows: requestController.rejectedRequests.map((request) {
              return DataRow(cells: [
                DataCell(Text(request.studentId)),
                DataCell(Text(request.studentName)),
                DataCell(Text(request.studentPhone)),
                DataCell(Text(request.documentName!)),
                DataCell(Text(request.purpose)),
              ]);
            }).toList(),
          ),
        ));
  }

  // Helper method to extract document name
  String _getDocumentName(RequestModel request) {
    // List of potential name sources in order of preference
    List<String?> nameSources = [
      request.customDocumentName,
      request.documentName,
    ];

    // Find the first non-null and non-empty name
    for (var name in nameSources) {
      if (name != null && name.trim().isNotEmpty) {
        return name;
      }
    }

    // Return fallback if no name found
    return 'Unnamed Document';
  }
}

// Accept Dialog
// void _showAcceptDialog(
//     AcceptController acceptController, RequestModel request) {
//   Get.dialog(
//     AlertDialog(
//       title: const Text('Confirm Accept'),
//       content: const Text('Are you sure you want to accept this request?'),
//       actions: [
//         TextButton(
//           onPressed: () => Get.back(),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             String? documentName = _getDocumentName(request)!;
//             // Call accept method from AcceptController
//             acceptController
//                 .acceptDocument(
//               studentId: request.studentId,
//               documentId: request.documentId,
//               documentData: request.toJson(),
//               documentName: documentName,
//             )
//                 .then((_) {
//               // Optional: Show success message
//               Get.snackbar(
//                 'Success',
//                 'Document accepted successfully',
//                 backgroundColor: Colors.green,
//                 colorText: Colors.white,
//               );
//               Get.back(); // Close dialog
//             }).catchError((error) {
//               // Show error message if acceptance fails
//               Get.snackbar(
//                 'Error',
//                 'Failed to accept document',
//                 backgroundColor: Colors.red,
//                 colorText: Colors.white,
//               );
//             });
//           },
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//           child: const Text('Accept'),
//         ),
//       ],
//     ),
//   );
// }

void _showAcceptDialog(
    AcceptController acceptController, RequestModel request) {
  Get.dialog(
    AlertDialog(
      title: const Text('Confirm Accept'),
      content: const Text('Are you sure you want to accept this request?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(), // Close the dialog
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String? documentName = _getDocumentName(request)!;
            // Call accept method from AcceptController
            acceptController
                .acceptDocument(
              studentId: request.studentId,
              documentId: request.documentId,
              documentData: request.toJson(),
              documentName: documentName,
            )
                .then((_) {
              // Close the dialog
              Get.back();

              // Optional: Show success message
              Get.snackbar(
                'Success',
                'Document accepted successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            }).catchError((error) {
              // Close the dialog
              Get.back();

              // Show error message if acceptance fails
              Get.snackbar(
                'Error',
                'Failed to accept document',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Accept'),
        ),
      ],
    ),
  );
}

// Reject Dialog
void _showRejectDialog(
    RejectController rejectController, RequestModel request) {
  final TextEditingController reasonController = TextEditingController();
  Get.dialog(
    AlertDialog(
      title: const Text('Reject Request'),
      content: TextField(
        controller: reasonController,
        decoration: const InputDecoration(
          labelText: 'Reason for Rejection',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(), // Close the dialog
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String? documentName = _getDocumentName(request)!;
            // Call reject method from RejectController
            rejectController
                .rejectDocument(
              studentId: request.studentId,
              documentId: request.documentId,
              documentData: request.toJson(),
              rejectionReason: reasonController.text,
              documentName: documentName,
            )
                .then((_) {
              // Close the dialog
              Get.back();

              // Optional: Show success message
              Get.snackbar(
                'Success',
                'Document rejected successfully',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            }).catchError((error) {
              // Close the dialog
              Get.back();

              // Show error message if rejection fails
              Get.snackbar(
                'Error',
                'Failed to reject document',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Reject'),
        ),
      ],
    ),
  );
}

String? _getDocumentName(RequestModel request) {
  // Priority order for document name
  if (request.customDocumentName != null &&
      request.customDocumentName!.isNotEmpty) {
    return request.customDocumentName;
  }

  if (request.documentName != null && request.documentName!.isNotEmpty) {
    return request.documentName;
  }

  // Fallback to a generic name if no specific name is found
  return 'Unnamed Document';
}

// Reject Dialog
// void _showRejectDialog(
//     RejectController rejectController, RequestModel request) {
//   final TextEditingController reasonController = TextEditingController();
//   Get.dialog(
//     AlertDialog(
//       title: const Text('Reject Request'),
//       content: TextField(
//         controller: reasonController,
//         decoration: const InputDecoration(
//           labelText: 'Reason for Rejection',
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Get.back(),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             String? documentName = _getDocumentName(request)!;
//             // Call reject method from RejectController
//             rejectController
//                 .rejectDocument(
//               studentId: request.studentId,
//               documentId: request.documentId,
//               documentData: request.toJson(),
//               rejectionReason: reasonController.text,
//               documentName: documentName,
//             )
//                 .then((_) {
//               // Optional: Show success message
//               Get.snackbar(
//                 'Success',
//                 'Document rejected successfully',
//                 backgroundColor: Colors.green,
//                 colorText: Colors.white,
//               );
//               Get.back(); // Close dialog
//             }).catchError((error) {
//               // Show error message if rejection fails
//               Get.snackbar(
//                 'Error',
//                 'Failed to reject document',
//                 backgroundColor: Colors.red,
//                 colorText: Colors.white,
//               );
//             });
//           },
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//           child: const Text('Reject'),
//         ),
//       ],
//     ),
//   );
// }
