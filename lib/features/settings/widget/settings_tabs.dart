import 'package:ausa/common/widget/app_icons.dart';
import 'package:ausa/common/widget/custom_tab_button.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/icons.dart';

import 'package:flutter/material.dart';

class SettingsTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;

  const SettingsTabs({super.key, this.selectedIndex = 0, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'icon': AusaIcons.wifi, 'label': 'Wifi'},
      {'icon': AusaIcons.tv01, 'label': 'Display'},
      {'icon': AusaIcons.bluetoothOn, 'label': 'Bluetooth'},
      {'icon': AusaIcons.bankNote01, 'label': 'Notifications'},
      {'icon': AusaIcons.navigationPointerOff01, 'label': 'Call Settings'},
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
              icon: tab['icon'] as String,
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
