import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/ADMIN/CourseController.dart';
import 'package:naradaflow/CONTROLLERS/ADMIN/DashBoardController.dart';
import 'package:naradaflow/CONTROLLERS/ADMIN/RequestController.dart';
import 'package:naradaflow/CONTROLLERS/login_controller.dart';
import 'package:naradaflow/Responsiveness.dart';
import 'package:naradaflow/VIEWS/ADMIN/REUQESTVIEW.dart';
import 'package:naradaflow/VIEWS/ADMIN/dashBoardView.dart';
import 'package:naradaflow/VIEWS/ADMIN/departmentView.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool isSidebarOpen = true; // Controls the sidebar state
  String selectedOption = 'Dashboard'; // Tracks the selected option
  final LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    // Initialize all required controllers
    Get.put(CourseController()); // For DepartmentView
    Get.put(RequestController()); // For RequestsView
    Get.put(DashboardController()); // For DashboardView
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  // Mobile Layout
  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Ensures the menu icon is displayed
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
              color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE8F5E9),
        elevation: 4.0,
        actions: [
          PopupMenuButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Admin ID: ${loginController.loginId.value}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text("Designation: ADMIN",
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            _buildSidebarOption('Dashboard', Icons.dashboard),
            _buildSidebarOption('Requests', Icons.request_page),
            _buildSidebarOption('Department', Icons.apartment),
          ],
        ),
      ),
      body: _buildContent(),
    );
  }

  // Tablet Layout
  Widget _buildTabletLayout() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
              color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE8F5E9),
        elevation: 4.0,
        actions: [
          PopupMenuButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Admin ID: ${loginController.loginId.value}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text("Designation: HOD",
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: const Color(0xFFE8F5E9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildSidebarOption('Dashboard', Icons.dashboard),
                _buildSidebarOption('Requests', Icons.request_page),
                _buildSidebarOption('Department', Icons.apartment),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  // Desktop Layout
  Widget _buildDesktopLayout() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
              color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE8F5E9),
        elevation: 4.0,
        actions: [
          PopupMenuButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Admin ID: ${loginController.loginId.value}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text("Designation: HOD",
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSidebarOpen ? 200 : 0,
            color: const Color(0xFFE8F5E9),
            child: isSidebarOpen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildSidebarOption('Dashboard', Icons.dashboard),
                      _buildSidebarOption('Requests', Icons.request_page),
                      _buildSidebarOption('Department', Icons.apartment),
                    ],
                  )
                : null,
          ),
          // Main Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarOption(String title, IconData icon) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: SizedBox(
        width: 24,
        child: Icon(icon, color: Colors.green),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      onTap: () {
        setState(() {
          selectedOption = title; // Update selected option
        });
        if (Responsive.isMobile(context))
          Navigator.pop(context); // Close drawer on mobile
      },
    );
  }

  Widget _buildContent() {
    if (selectedOption == 'Dashboard') {
      return const DashboardView();
    } else if (selectedOption == 'Requests') {
      return const RequestsView();
    } else if (selectedOption == 'Department') {
      return const DepartmentView();
    } else {
      return const Center(
        child: Text(
          'Page not found',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }
  }
}
