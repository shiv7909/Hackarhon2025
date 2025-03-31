// lib/controllers/login_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:naradaflow/MODELS/USER/user_model.dart';

class LoginController extends GetxController {
  // GetStorage for persistent storage
  final _storage = GetStorage();

  // Observable variables
  final loginId = '24MCA00PY0020'.obs;

  final password = '24MCA00PY0020'.obs;
  final error = ''.obs;
  final isLoggedIn = false.obs;
  final userType = ''.obs; // 'admin', 'user', etc.

  @override
  void onInit() {
    super.onInit();
    // Check if there's a stored login session
    restoreSession();
  }

  void login() {
    if (loginId.value == '24MCA00PY0020' && password.value == 'SHIVA123') {
      // Admin login
      _saveSession(
        loginId: loginId.value,
        password: password.value,
        userType: 'admin',
        isAdmin: true,
      );
      Get.offNamed('/admin-dashboard',
          arguments: UserModel(
            username: loginId.value,
            password: password.value,
            isAdmin: true,
          ));
    } else if (loginId.value == '24MCA00PY0020' &&
        password.value == '24MCA00PY0020') {
      // User login
      _saveSession(
        loginId: loginId.value,
        password: password.value,
        userType: 'user',
      );
      Get.offNamed('/user-dashboard',
          arguments: UserModel(
            username: loginId.value,
            password: password.value,
          ));
    } else if (loginId.value == 'user@example.com' &&
        password.value == 'user123') {
      // Another user login
      _saveSession(
        loginId: loginId.value,
        password: password.value,
        userType: 'user',
      );
      Get.offNamed('/user-dashboard',
          arguments: UserModel(
            username: 'user',
            password: password.value,
          ));
    } else {
      error.value = 'Invalid login ID or password !!';
    }
  }

  void _saveSession({
    required String loginId,
    required String password,
    required String userType,
    bool isAdmin = false,
  }) {
    // Save to GetStorage
    _storage.write('loginId', loginId);
    _storage.write('password', password);
    _storage.write('userType', userType);
    _storage.write('isLoggedIn', true);

    // Update observable variables
    this.loginId.value = loginId;
    this.password.value = password;
    this.userType.value = userType;
    isLoggedIn.value = true;
  }

  void restoreSession() {
    // Check if there's a stored session
    bool? storedLoggedIn = _storage.read('isLoggedIn');

    if (storedLoggedIn == true) {
      loginId.value = _storage.read('loginId') ?? '';
      password.value = _storage.read('password') ?? '';
      userType.value = _storage.read('userType') ?? '';
      isLoggedIn.value = true;
    }
  }

  void logout() {
    // Clear storage
    _storage.remove('loginId');
    _storage.remove('password');
    _storage.remove('userType');
    _storage.remove('isLoggedIn');

    // Reset observable variables
    loginId.value = '';
    password.value = '';
    userType.value = '';
    isLoggedIn.value = false;

    // Navigate to login screen
    Get.offAllNamed('/login');
  }
}
