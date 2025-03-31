import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naradaflow/VIEWS/ADMIN/admin_dashboard.dart';
import 'package:naradaflow/VIEWS/User/pAGES/1_service.dart';
import 'package:naradaflow/VIEWS/User/user_dashboard.dart';
import 'package:naradaflow/VIEWS/home.dart';
import 'package:naradaflow/VIEWS/User/signin/signin.dart';

void main() async {
// Ensure widgets are initialized before Firebase init
  WidgetsFlutterBinding.ensureInitialized();

// Initialize Firebase with your configuration values
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCleZBGgpAxKqLKkLOiK9O4uYVer5SXdfU",
      appId: "1:236524199731:web:33a71e4974bba4f0792846",
      messagingSenderId: "236524199731",
      projectId: "naradaflow",
      storageBucket: "naradaflow.firebasestorage.app",
      measurementId: "G-KCLQWBC82V",
    ),
  );

// Run the app after Firebase initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
// initialBinding: AppBindings(), // Bind your controllers here
      debugShowCheckedModeBanner: false,
      title: 'College Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
          ConnectivityWrapper(), // A wrapper view to handle connectivity changes
      getPages: [
        GetPage(name: '/', page: () => ConnectivityWrapper()),
        GetPage(name: '/signin', page: () => SignInScreen()),
        GetPage(name: '/user-dashboard', page: () => DashboardScreen()),
        GetPage(name: '/admin-dashboard', page: () => AdminDashboard()),
        GetPage(name: '/page1', page: () => UserProfileView()),
        GetPage(name: '/page2', page: () => UserProfileView()),
        GetPage(name: '/page1', page: () => UserProfileView()),
        GetPage(name: '/page2', page: () => UserProfileView()),
        GetPage(name: '/page1', page: () => UserProfileView()),
        GetPage(name: '/page2', page: () => UserProfileView()),
// Add additional pages as needed
      ],
    );
  }
}
