import 'package:flutter/material.dart';
import 'settings_tab_button.dart';

class SettingsTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;

  const SettingsTabs({
    super.key,
    this.selectedIndex = 0,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'icon': Icons.wifi, 'label': 'Wifi'},
      {'icon': Icons.tv, 'label': 'Display'},
      {'icon': Icons.bluetooth, 'label': 'Bluetooth'},
      {'icon': Icons.notifications, 'label': 'Notifications'},
      {'icon': Icons.link, 'label': 'Ausa Connect'},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final tab = tabs[i];
          return Padding(
            padding: EdgeInsets.only(right: i < tabs.length - 1 ? 16 : 0),
            child: SettingsTabButton(
              icon: tab['icon'] as IconData,
              label: tab['label'] as String,
              selected: selectedIndex == i,
              onTap: () => onTabSelected?.call(i),
            ),
          );
        }),
      ),
    );
  }
}
