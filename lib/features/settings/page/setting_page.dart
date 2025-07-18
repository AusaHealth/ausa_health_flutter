import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/features/settings/model/network_info_model.dart';
import 'package:ausa/features/settings/page/bluetooth_page.dart';
import 'package:ausa/features/settings/page/call_settings_page.dart';
import 'package:ausa/features/settings/page/display_setting_page.dart';
import 'package:ausa/features/settings/page/notification_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/wifi_controller.dart';
import '../../../common/widget/custom_header.dart';
import '../widget/settings_tabs.dart';
import '../widget/settings_network_list.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final WifiController controller = Get.find<WifiController>();

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
    return BaseScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: AppSpacing.lg),
                    child: const AppBackHeader2(title: 'Settings'),
                  ),
                  SizedBox(height: AppSpacing.xl2),
                  Padding(
                    padding: EdgeInsets.only(left: AppSpacing.xl6),
                    child: SettingsTabs(
                      selectedIndex: selectedTab,
                      onTabSelected: (i) => setState(() => selectedTab = i),
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: AppSpacing.lg),

          AppMainContainer(
            // backgroundColor: Colors.orange,
            child: Builder(
              builder: (context) {
                if (selectedTab == 0) {
                  return SettingsNetworkList(
                    networks: controller.networks,
                    selectedIndex: controller.selectedNetworkIndex.value,
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
        ],
      ),
    );
  }
}
