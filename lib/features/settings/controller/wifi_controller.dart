import 'package:ausa/common/widget/custom_loader.dart';
import 'package:ausa/common/widget/toast.dart';
import 'package:ausa/features/profile/page/input_model.dart';
import 'package:ausa/features/profile/page/input_page.dart';
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

  void onNetworkTap(int index) async {
    selectedNetworkIndex.value = index;
    final net = networks[index];

    // "Other..." network (usually last in the list)
    if (net.name == 'Other...') {
      // Open the custom input page for other networks
      final result = await Get.to(
        () => InputPage(
          inputs: [
            InputModel(
              name: 'networkName',
              value: '',
              label: 'Name',
              inputType: InputTypeEnum.text,
            ),
            InputModel(
              name: 'Password',
              value: '',
              label: 'Password',
              inputType: InputTypeEnum.password,
            ),
            InputModel(
              inputSource: [
                'None',
                'WEP',
                'WPA',
                'WPA 2 or WPA 3',
                'WPA Enterprise',
                'WPA 2 Enterprise',
                'WPA 3 Enterprise',
              ],
              name: 'Security',
              value: '',
              label: 'Security',
              inputType: InputTypeEnum.selector,
            ),
          ],
          isOtherWifiNetwork: true,
        ),
      );
      // Handle result if needed (result will be a List<InputModel>)
      return;
    }
    // Already connected
    if (net.isConnected) {
      Get.to(() => WifiConnectedPage());
      return;
    }
    if (net.name == 'DIRECT_37129t4bg937') {
      final result = await Get.to(() => WifiInputPasswordWidget());
      if (result != null) {
        _connect(index, result);
      }
      return;
    }

    // Secure network with saved password
    if (net.isSecure && savedPasswords.containsKey(net.name)) {
      // Optionally show a connecting UI
      _connect(index, savedPasswords[net.name]!);
      return;
    }

    // Secure network, no saved password
    if (net.isSecure) {
      // Show password modal/page
      showPasswordSheet.value = true;
      return;
    }

    // Open network, connect directly
    if (!net.isSecure) {
      _connect(index, '');
      return;
    }
  }

  void submitPassword(String password) {
    final idx = selectedNetworkIndex.value;
    if (idx == null) return;
    final net = networks[idx];

    // Show connecting toast immediately
    CustomLoader.show(message: "Connecting to ${net.name}");
    Future.delayed(const Duration(seconds: 2), () {
      CustomLoader.hide();
    });

    // Simulate password check with a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (password == 'password123') {
        savedPasswords[net.name] = password;
        showPasswordSheet.value = false;
        _connect(idx, password);
      } else {
        Future.delayed(const Duration(seconds: 3), () {
          CustomToast.show(message: 'Wrong Password', type: ToastType.error);
          showWrongPasswordPopup.value = true;
        });
      }
    });
  }

  void _connect(int index, String password) async {
    isConnecting.value = true;

    // Optionally, show a connecting toast here
    CustomToast.show(message: 'Connecting...', type: ToastType.warning);

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 2));
    isConnecting.value = false;

    // Update connected network
    networks.value = [
      for (int i = 0; i < networks.length; i++)
        i == index
            ? networks[i].copyWith(isConnected: true)
            : networks[i].copyWith(isConnected: false),
    ];

    showConnectedPopup.value = true;

    // Show success toast
    CustomToast.show(
      message: 'Connected Successfully',
      type: ToastType.success,
    );

    // Delay closing the modal/page to allow toast to show
    await Future.delayed(const Duration(seconds: 2));

    showConnectedPopup.value = false;
    Get.back(); // Close modal/page AFTER toast is shown
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
