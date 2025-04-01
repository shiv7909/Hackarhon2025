

// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:naradaflow/MODELS/NotificationModel.dart';
// import 'package:your_app_name/models/notification_model.dart';

// class NotificationController extends GetxController {
//   final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchNotifications();
//   }

//   Future<void> fetchNotifications() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';

//       // Fetch notifications from Firestore
//       QuerySnapshot querySnapshot = await _firestore
//           .collection('notifications')
//           .orderBy('timestamp', descending: true)
//           .get();

//       notifications.value = querySnapshot.docs
//           .map((doc) => NotificationModel.fromJson({
//                 ...doc.data() as Map<String, dynamic>,
//                 'id': doc.id,
//               }))
//           .toList();
//     } catch (e) {
//       errorMessage.value = 'Failed to fetch notifications: ${e.toString()}';
//       print(errorMessage.value);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> markNotificationAsRead(String notificationId) async {
//     try {
//       // Update in local list
//       int index = notifications.indexWhere((n) => n.id == notificationId);
//       if (index != -1) {
//         notifications[index] = notifications[index].copyWith(isRead: true);
//       }

//       // Update in Firestore
//       await _firestore
//           .collection('notifications')
//           .doc(notificationId)
//           .update({'isRead': true});
//     } catch (e) {
//       errorMessage.value = 'Failed to mark notification as read: ${e.toString()}';
//     }
//   }

//   Future<void> deleteNotification(String notificationId) async {
//     try {
//       // Remove from local list
//       notifications.removeWhere((n) => n.id == notificationId);

//       // Delete from Firestore
//       await _firestore
//           .collection('notifications')
//           .doc(notificationId)
//           .delete();
//     } catch (e) {
//       errorMessage.value = 'Failed to delete notification: ${e.toString()}';
//     }
//   }

//   void clearAllNotifications() {
//     // Implement batch delete if needed
//     notifications.clear();
//   }

//   // Helper method to get responsive size
//   double getResponsiveSize(DeviceType deviceType, double baseSize) {
//     switch (deviceType) {
//       case DeviceType.mobile:
//         return baseSize;
//       case DeviceType.tablet:
//         return baseSize * 1.2;
//       case DeviceType.desktop:
//         return baseSize * 1.5;
//     }
//   }
// }