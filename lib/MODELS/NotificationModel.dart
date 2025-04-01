// class NotificationModel {
//   final String id;
//   final String title;
//   final String description;
//   final DateTime timestamp;
//   final bool isRead;
//   final String type;

//   NotificationModel({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.timestamp,
//     this.isRead = false,
//     required this.type,
//   });

//   // Convert from JSON
//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     return NotificationModel(
//       id: json['id'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       timestamp: json['timestamp'] != null
//           ? DateTime.parse(json['timestamp'])
//           : DateTime.now(),
//       isRead: json['isRead'] ?? false,
//       type: json['type'] ?? 'general',
//     );
//   }

//   // Convert to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'description': description,
//       'timestamp': timestamp.toIso8601String(),
//       'isRead': isRead,
//       'type': type,
//     };
//   }

//   // Create a copy with optional updates
//   NotificationModel copyWith({
//     String? id,
//     String? title,
//     String? description,
//     DateTime? timestamp,
//     bool? isRead,
//     String? type,
//   }) {
//     return NotificationModel(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       timestamp: timestamp ?? this.timestamp,
//       isRead: isRead ?? this.isRead,
//       type: type ?? this.type,
//     );
//   }
// }

// // Device type enum
// enum DeviceType {
//   mobile,
//   tablet,
//   desktop,
// }
