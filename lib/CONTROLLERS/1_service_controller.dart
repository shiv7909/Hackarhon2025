import 'package:get/get.dart';
import 'package:naradaflow/CONTROLLERS/User_provoider.dart';
import 'package:naradaflow/MODELS/USER/User_data_model.dart';

class UserProfileController extends GetxController {
  final UserProvider _userProvider = Get.put(UserProvider());

  // Observable user model
  final Rx<UserModel?> userProfile = Rx<UserModel?>(null);

  // Loading and error states
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      // Set loading to true at the start of fetch
      isLoading.value = true;
      errorMessage.value = '';

      // Simulate a minimum loading time of 2 seconds
      await Future.delayed(Duration(seconds: 2));

      // Fetch user profile
      UserModel? fetchedProfile = await _userProvider.fetchUserProfile();

      if (fetchedProfile != null) {
        userProfile.value = fetchedProfile;
      } else {
        errorMessage.value = 'User profile not found';
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch user profile';
      print('Error fetching profile: $e');
    } finally {
      // Ensure loading is set to false
      isLoading.value = false;
    }
  }

  // Optional: Update profile method
  Future<void> updateUserProfile(UserModel updatedProfile) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _userProvider.updateUserProfile(updatedProfile);

      // Refresh profile after update
      await fetchUserProfile();
    } catch (e) {
      errorMessage.value = 'Failed to update profile';
      print('Error updating profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to refresh profile
  void refreshProfile() {
    fetchUserProfile();
  }
}
