import 'package:ausa/common/model/user.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final Rx<User?> _user = Rx<User?>(null);

  User? get user => _user.value;

  void setUser(User user) {
    _user.value = user;
  }

  void clearUser() {
    _user.value = null;
  }
}

