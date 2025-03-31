import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/login_controller.dart';
import 'package:naradaflow/VIEWS/User/signin/signin.dart';
import 'package:naradaflow/controllers/connectivity_controller.dart';

class ConnectivityWrapper extends StatelessWidget {
  final ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectivityController.isConnected.value) {
        return SignInScreen(); // Replace with your main screen
      } else {
        return NoConnectivityScreen();
      }
    });
  }
}

class NoConnectivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/no_connection.png'), // Add your image asset
            const SizedBox(height: 20),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please check your network settings.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
