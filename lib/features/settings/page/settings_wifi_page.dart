import 'package:ausa/features/settings/model/network_info_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/wifi_controller.dart';
import '../../../common/widget/settings_header.dart';
import '../widget/settings_nav.dart';
import '../widget/settings_tabs.dart';
import '../widget/settings_network_list.dart';
import '../widget/wifi_password_modal.dart';
import '../widget/wifi_popup.dart';

class SettingsWifiPage extends StatefulWidget {
  const SettingsWifiPage({super.key});

  @override
  State<SettingsWifiPage> createState() => _SettingsWifiPageState();
}

class _SettingsWifiPageState extends State<SettingsWifiPage> {
  final WifiController controller = Get.put(WifiController());

  int selectedTab = 0;

  final List<NetworkInfo> initialNetworks = [
    NetworkInfo(
      name: 'DIRECT_37129t4bg937',
      isSecure: true,
      isConnected: false,
      signalStrength: 4,
    ),
    NetworkInfo(
      name: 'Mercy Housing Resident',
      isSecure: true,
      isConnected: true,
      signalStrength: 3,
    ),
    NetworkInfo(
      name: 'Jian Zhing Primary Care',
      isSecure: false,
      isConnected: false,
      signalStrength: 2,
    ),
    NetworkInfo(
      name: 'Other...',
      isSecure: false,
      isConnected: false,
      signalStrength: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    controller.setNetworks(initialNetworks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(),
                const SizedBox(height: 8),
                SettingsNav(),
                const SizedBox(height: 8),
                SettingsTabs(
                  selectedIndex: selectedTab,
                  onTabSelected: (i) => setState(() => selectedTab = i),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child:
                      selectedTab == 0
                          ? Obx(
                            () => SettingsNetworkList(
                              networks: controller.networks,
                              selectedIndex:
                                  controller.selectedNetworkIndex.value,
                              onTileTap: controller.onNetworkTap,
                            ),
                          )
                          : Container(
                            color: Colors.white,
                            child: const Center(
                              child: Text('Other tab content'),
                            ),
                          ),
                ),
              ],
            ),
            // Password modal
            Obx(
              () =>
                  controller.showPasswordSheet.value
                      ? WifiPasswordModal(
                        networkName:
                            controller
                                .networks[controller
                                    .selectedNetworkIndex
                                    .value!]
                                .name,
                        onSubmit: (password) {
                          controller.submitPassword(password);
                        },
                        onClose: () {
                          controller.showPasswordSheet.value = false;
                        },
                      )
                      : const SizedBox.shrink(),
            ),
            // Connecting popup
            Obx(
              () =>
                  controller.isConnecting.value
                      ? WifiPopup(type: WifiPopupType.connecting)
                      : const SizedBox.shrink(),
            ),
            // Connected popup
            Obx(
              () =>
                  controller.showConnectedPopup.value
                      ? WifiPopup(type: WifiPopupType.connected)
                      : const SizedBox.shrink(),
            ),
            // Wrong password popup
            Obx(
              () =>
                  controller.showWrongPasswordPopup.value
                      ? WifiPopup(
                        type: WifiPopupType.wrongPassword,
                        onClose: controller.closeWrongPasswordPopup,
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
