// lib/views/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naradaflow/MODELS/USER/user_model.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Center(
        child: Text('Welcome, ${user.username}!'),
      ),
    );
  }
}
