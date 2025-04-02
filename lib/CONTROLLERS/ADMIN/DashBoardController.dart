import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Dashboard data
  var totalCourses = 10.obs;
  var totalStudents = 200.obs;
  var pendingRequests = 2.obs;
  var documentsAwaitingPickup = 5.obs;

  // Recent activity (dummy data for now)
  var recentActivity = [
    "Request approved for John Doe",
    "New request submitted by Jane Smith",
    "Document picked up by Alice Johnson",
  ].obs;
}
