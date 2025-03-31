import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/login_controller.dart';
import 'package:naradaflow/MODELS/USER/User_data_model.dart';

class UserProvider extends GetxController {
  final LoginController loginController = Get.find<LoginController>();

  Future<UserModel?> fetchUserProfile() async {
    try {
      // Get current logged-in user's email from FirebaseAuth
      // User? currentUser = FirebaseAuth.instance.currentUser;
      // if (currentUser == null) {
      //   throw Exception('No user logged in');
      // }

      // Use loginId to fetch user document from Firestore
      String loginId = loginController.loginId.value;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('USERS')
          .doc("MCA") // Assuming loginId is the document ID
          .collection("MEN")
          .doc(loginId)
          .get();

      if (userDoc.exists) {
        // Convert document to UserModel
        return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  // Optional: Update user profile
  Future<void> updateUserProfile(UserModel userModel) async {
    try {
      // Get current logged-in user's email from FirebaseAuth
      //User? currentUser = FirebaseAuth.instance.currentUser;
      // if (currentUser == null) {
      //   throw Exception('No user logged in');
      // }

      // Use loginId to update user document in Firestore
      String loginId = loginController.loginId.value;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(loginId) // Assuming loginId is the document ID
          .update(userModel.toJson());
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }
}
