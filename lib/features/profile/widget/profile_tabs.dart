import 'package:ausa/common/widget/custom_tab_button.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/spacing.dart';

import 'package:flutter/material.dart';

class ProfileTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;

  const ProfileTabs({super.key, this.selectedIndex = 0, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'icon': AusaIcons.user01, 'label': 'Profile'},
      {'icon': AusaIcons.shieldPlus, 'label': 'Condition'},
      {'icon': AusaIcons.medicalCross, 'label': 'Care'},
      {'icon': AusaIcons.userPlus01, 'label': 'Family'},
      {'icon': AusaIcons.navigationPointer01, 'label': 'Ausa Connect'},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
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
