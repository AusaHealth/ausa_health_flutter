import 'package:ausa/features/settings/page/wifi_connected_page.dart';
import 'package:ausa/features/settings/widget/wifi_input_password_widget.dart';
import 'package:get/get.dart';
import '../model/network_info_model.dart';

class WifiController extends GetxController {
  var networks = <NetworkInfo>[].obs;
  var selectedNetworkIndex = RxnInt();
  var isConnecting = false.obs;
  var isConnected = false.obs;
  var showPasswordSheet = false.obs;
  var showConnectedPopup = false.obs;
  var showWrongPasswordPopup = false.obs;
  var savedPasswords = <String, String>{}.obs; // networkName -> password

  void setNetworks(List<NetworkInfo> nets) {
    networks.value = nets;
  }

  void onNetworkTap(int index) {
    selectedNetworkIndex.value = index;
    final net = networks[index];
    // Get.to(() => WifiConnectedPage());
    Get.to(() => WifiInputPasswordWidget());
    if (net.isConnected) {
      // Disconnect
      Get.showSnackbar(
        const GetSnackBar(
          message: 'Disconnecting...',
          duration: Duration(seconds: 1),
        ),
      );
      _disconnect(index);
    } else if (net.isSecure && savedPasswords.containsKey(net.name)) {
      // Connect with saved password
      Get.showSnackbar(
        const GetSnackBar(
          message: 'Connecting...',
          duration: Duration(seconds: 1),
        ),
      );
      _connect(index, savedPasswords[net.name]!);
    } else if (net.isSecure) {
      // Show password modal
      showPasswordSheet.value = true;
    } else {
      // Open network, connect directly
      Get.showSnackbar(
        const GetSnackBar(
          message: 'Connecting...',
          duration: Duration(seconds: 1),
        ),
      );
      _connect(index, '');
    }
  }

  void submitPassword(String password) {
    final idx = selectedNetworkIndex.value;
    if (idx == null) return;
    final net = networks[idx];
    // Simulate password check
    if (password == 'password123') {
      // Replace with real check
      savedPasswords[net.name] = password;
      showPasswordSheet.value = false;
      Get.showSnackbar(
        const GetSnackBar(
          message: 'Connecting...',
          duration: Duration(seconds: 1),
        ),
      );
      _connect(idx, password);
    } else {
      showWrongPasswordPopup.value = true;
    }
  }

  void _connect(int index, String password) async {
    isConnecting.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isConnecting.value = false;
    // Update state
    networks.value = [
      for (int i = 0; i < networks.length; i++)
        i == index
            ? networks[i].copyWith(isConnected: true)
            : networks[i].copyWith(isConnected: false),
    ];
    showConnectedPopup.value = true;
    await Future.delayed(const Duration(seconds: 2));
    showConnectedPopup.value = false;
    Get.back(); // Close modal/page
  }

  void _disconnect(int index) async {
    networks.value = [
      for (int i = 0; i < networks.length; i++)
        i == index ? networks[i].copyWith(isConnected: false) : networks[i],
    ];
  }

  void closeWrongPasswordPopup() {
    showWrongPasswordPopup.value = false;
  }
}
