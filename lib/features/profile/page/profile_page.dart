import 'package:ausa/common/widget/app_icons.dart';
import 'package:ausa/common/widget/custom_nav.dart';
import 'package:ausa/features/profile/widget/profile_tabs.dart';
import 'package:ausa/features/profile/widget/profile_widget.dart';
import 'package:ausa/features/settings/controller/wifi_controller.dart';
import 'package:ausa/features/settings/widget/settings_header.dart';
import 'package:ausa/features/settings/widget/wifi_password_modal.dart';
import 'package:ausa/features/settings/widget/wifi_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final WifiController controller = Get.put(WifiController());
  int selectedTab = 0;
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
                const SettingsHeader(),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomNav(title: 'Profile'),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: ProfileTabs(
                              selectedIndex: selectedTab,
                              onTabSelected:
                                  (i) => setState(() => selectedTab = i),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 24.0),
                      child: Image.asset(
                        ProfileIcons.ausaLogo,
                        height: 150,
                        width: 230,
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child:
                      selectedTab == 0
                          ? ProfileWidget()
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
