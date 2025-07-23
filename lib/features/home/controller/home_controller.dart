import 'package:get/get.dart';

class HomeController extends GetxController {
  // Navigation tracking
  final RxInt _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;

  // Navigation method for future use
  void navigateToFeature(String routeName) {
    Get.toNamed(routeName);
  }

  // Update selected index for future features like tabs
  void updateSelectedIndex(int index) {
    _selectedIndex.value = index;
  }



}
