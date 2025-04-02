import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/ADMIN/DashBoardController.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.find();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildDashboardStat(
                  "Total Courses", dashboardController.totalCourses.value),
              _buildDashboardStat(
                  "Total Students", dashboardController.totalStudents.value),
              _buildDashboardStat("Pending Requests",
                  dashboardController.pendingRequests.value),
              _buildDashboardStat("Documents Awaiting Pickup",
                  dashboardController.documentsAwaitingPickup.value),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            "RECENT ACTIVITY",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: dashboardController.recentActivity.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      dashboardController.recentActivity[index],
                      style: const TextStyle(color: Colors.green),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardStat(String title, int value) {
    return Card(
      color: const Color(0xFFE8F5E9),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
