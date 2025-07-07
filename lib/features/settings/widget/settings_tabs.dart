import 'package:ausa/common/widget/app_icons.dart';
import 'package:ausa/common/widget/custom_tab_button.dart';
import 'package:ausa/constants/app_images.dart';

import 'package:flutter/material.dart';

class SettingsTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;

  const SettingsTabs({super.key, this.selectedIndex = 0, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {
        'selectedImagePath': AppImages.swifiSelected,
        'unselectedImagePath': AppImages.wifi,
        'label': 'Wifi',
      },
      {
        'selectedImagePath': AppImages.displaySelected,
        'unselectedImagePath': AppImages.display,
        'label': 'Display',
      },
      {
        'selectedImagePath': AppImages.bluetoothSelected,
        'unselectedImagePath': AppImages.bluetooth,
        'label': 'Bluetooth',
      },
      {
        'selectedImagePath': AppImages.notificationSelected,
        'unselectedImagePath': AppImages.notification,
        'label': 'Notifications',
      },
      {
        'selectedImagePath': AppImages.callSettingSelected,
        'unselectedImagePath': AppImages.callSetting,
        'label': 'Call Settings',
      },
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final tab = tabs[i];
          final isSelected = selectedIndex == i;
          return Padding(
            padding: EdgeInsets.only(right: i < tabs.length - 1 ? 16 : 0),
            child: CustomTabButton(
              selectedImagePath: tab['selectedImagePath'] as String,
              unselectedImagePath: tab['unselectedImagePath'] as String,
              label: tab['label'] as String,
              selected: isSelected,
              onTap: () => onTabSelected?.call(i),
            ),
          );
        }),
      ),
    );
  }
}
