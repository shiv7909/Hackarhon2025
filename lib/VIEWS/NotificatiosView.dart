// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:naradaflow/CONTROLLERS/NotificartionsController.dart';
// import 'package:your_app_name/controllers/notification_controller.dart';
// import 'package:your_app_name/models/notification_model.dart';

// class NotificationView extends StatelessWidget {
//   final NotificationController controller = Get.put(NotificationController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Notifications',
//           style: GoogleFonts.inter(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.clear_all),
//             onPressed: () => _showClearAllDialog(),
//           ),
//         ],
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           DeviceType deviceType = _getDeviceType(constraints);
//           return _buildNotificationContent(deviceType);
//         },
//       ),
//     );
//   }

//   Widget _buildNotificationContent(DeviceType deviceType) {
//     return Obx(() {
//       // Loading state
//       if (controller.isLoading.value) {
//         return Center(child: CircularProgressIndicator());
//       }

//       // Error state
//       if (controller.errorMessage.value.isNotEmpty) {
//         return Center(
//           child: Text(
//             controller.errorMessage.value,
//             style: TextStyle(color: Colors.red),
//           ),
//         );
//       }

//       // Empty state
//       if (controller.notifications.isEmpty) {
//         return _buildEmptyState(deviceType);
//       }

//       // Notification list
//       return RefreshIndicator(
//         onRefresh: () => controller.fetchNotifications(),
//         child: ListView.builder(
//           itemCount: controller.notifications.length,
//           itemBuilder: (context, index) {
//             final notification = controller.notifications[index];
//             return _buildNotificationItem(notification, deviceType);
//           },
//         ),
//       );
//     });
//   }

//   Widget _buildEmptyState(DeviceType deviceType) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.notifications_off_outlined,
//             size: controller.getResponsiveSize(deviceType, 100),
//             color: Colors.grey[400],
//           ),
//           SizedBox(height: 16),
//           Text(
//             'No Notifications',
//             style: GoogleFonts.inter(
//               fontSize: controller.getResponsiveSize(deviceType, 20),
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationItem(
//     NotificationModel notification, 
//     DeviceType deviceType
//   ) {
//     return Dismissible(
//       key: Key(notification.id),
//       background: _buildDeleteBackground(),
//       onDismissed: (_) => controller.deleteNotification(notification.id),
//       child: Container(
//         margin: EdgeInsets.symmetric(
//           vertical: 8,
//           horizontal: 16,
//         ),
//         decoration: BoxDecoration(
//           color: notification.isRead ? Colors.white : Colors.blue[50],
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 3,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: ListTile(
//           title: Text(
//             notification.title,
//             style: GoogleFonts.inter(
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           subtitle: Text(
//             notification.description,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           trailing: Text(
//             _formatTimestamp(notification.timestamp),
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//           onTap: () => controller.markNotificationAsRead(notification.id),
//         ),
//       ),
//     );
//   }

//   Widget _buildDeleteBackground() {
//     return Container(
//       color: Colors.red,
//       alignment: Alignment.centerRight,
//       padding: EdgeInsets.only(right: 20),
//       child: Icon(
//         Icons.delete,
//         color: Colors.white,
//       ),
//     );
//   }

//   void _showClearAllDialog() {
//     Get.dialog(
//       AlertDialog(
//         title: Text('Clear All Notifications'),
//         content: Text('Are you sure you want to clear all notifications?'),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               controller.clearAllNotifications();
//               Get.back();
//             },
//             child: Text('Clear'),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//           ),
//         ],
//       ),
//     );
//   }

//   // Determine device type
//   DeviceType _getDeviceType(BoxConstraints constraints) {
//     if (constraints.maxWidth < 600) return DeviceType.mobile;
//     if (constraints.maxWidth < 1200) return DeviceType.tablet;
//     return DeviceType.desktop;
//   }

//   // Timestamp formatting
//   String _formatTimestamp(DateTime timestamp) {
//     final now = DateTime.now();
//     if (now.difference(timestamp).inDays < 1) {
//       return DateFormat('hh:mm a').format(timestamp);
//     }
//     return DateFormat('dd MMM hh:mm a').format(timestamp);
//   }
// }