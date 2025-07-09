import 'package:ausa/common/widget/app_icons.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/custom_nav.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/features/onboarding/view/onboarding_wrapper.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_wifi_selection_widget.dart';
import 'package:ausa/features/settings/model/network_info_model.dart';
import 'package:ausa/features/settings/page/bluetooth_page.dart';
import 'package:ausa/features/settings/page/call_settings_page.dart';
import 'package:ausa/features/settings/page/display_setting_page.dart';
import 'package:ausa/features/settings/page/notification_settings_page.dart';
import 'package:ausa/features/settings/widget/call_setting_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/wifi_controller.dart';
import '../../../common/widget/custom_header.dart';
import '../widget/settings_nav.dart';
import '../widget/settings_tabs.dart';
import '../widget/settings_network_list.dart';
import '../widget/wifi_password_modal.dart';
import '../widget/wifi_popup.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
    // NetworkInfo(
    //   name: 'Jian Zhing Primary Care',
    //   isSecure: false,
    //   isConnected: false,
    //   signalStrength: 2,
    // ),
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
                GestureDetector(
                  onTap: () {
                    Get.to(OnboardingWrapper());
                  },
                  child: const CustomHeader(),
                ),

                SizedBox(height: AppSpacing.xl2),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomNav(title: 'Settings'),
                        SizedBox(height: AppSpacing.xl),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: SettingsTabs(
                            selectedIndex: selectedTab,
                            onTabSelected:
                                (i) => setState(() => selectedTab = i),
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      ProfileIcons.ausaLogo,
                      height: 144,
                      width: 144,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                SizedBox(height: 8),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl3),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.mdLarge,
                        vertical: AppSpacing.mdLarge,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.xl3),
                      ),
                      child: Builder(
                        builder: (context) {
                          if (selectedTab == 0) {
                            return SettingsNetworkList(
                              networks: controller.networks,
                              selectedIndex:
                                  controller.selectedNetworkIndex.value,
                              onTileTap: controller.onNetworkTap,
                            );
                          } else if (selectedTab == 1) {
                            return DisplaySettingPage();
                          } else if (selectedTab == 2) {
                            return BluetoothPage();
                          } else if (selectedTab == 3) {
                            return NotificationSettingsPage();
                          } else if (selectedTab == 4) {
                            return CallSettingsPage();
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

            //     Expanded(
            //       child:
            //           selectedTab == 0
            //               ? Obx(
            //                 () => SettingsNetworkList(
            //                   networks: controller.networks,
            //                   selectedIndex:
            //                       controller.selectedNetworkIndex.value,
            //                   onTileTap: controller.onNetworkTap,
            //                 ),
            //               )
            //               : Container(
            //                 color: Colors.white,
            //                 child: const Center(
            //                   child: Text('Other tab content'),
            //                 ),
            //               ),
            //     ),
            //   ],
            // ),
            // // Password modal
            // Obx(
            //   () =>
            //       controller.showPasswordSheet.value
            //           ? WifiPasswordModal(
            //             networkName:
            //                 controller
            //                     .networks[controller
            //                         .selectedNetworkIndex
            //                         .value!]
            //                     .name,
            //             onSubmit: (password) {
            //               controller.submitPassword(password);
            //             },
            //             onClose: () {
            //               controller.showPasswordSheet.value = false;
            //             },
            //           )
            //           : const SizedBox.shrink(),
            // ),
            // // Connecting popup
            // Obx(
            //   () =>
            //       controller.isConnecting.value
            //           ? WifiPopup(type: WifiPopupType.connecting)
            //           : const SizedBox.shrink(),
            // ),
            // // Connected popup
            // Obx(
            //   () =>
            //       controller.showConnectedPopup.value
            //           ? WifiPopup(type: WifiPopupType.connected)
            //           : const SizedBox.shrink(),
            // ),
            // // Wrong password popup
            // Obx(
            //   () =>
            //       controller.showWrongPasswordPopup.value
            //           ? WifiPopup(
            //             type: WifiPopupType.wrongPassword,
            //             onClose: controller.closeWrongPasswordPopup,
            //           )
            //           : const SizedBox.shrink(),
            