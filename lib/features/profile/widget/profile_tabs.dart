import 'package:ausa/common/widget/app_icons.dart';
import 'package:ausa/common/widget/custom_tab_button.dart';

import 'package:flutter/material.dart';

class ProfileTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;

  const ProfileTabs({super.key, this.selectedIndex = 0, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {
        'selectedImagePath': ProfileIcons.profileSelected,
        'unselectedImagePath': ProfileIcons.profileUnselected,
        'label': 'Profile',
      },
      {
        'selectedImagePath': ProfileIcons.conditionSelected,
        'unselectedImagePath': ProfileIcons.conditionUnselected,
        'label': 'Condition',
      },
      {
        'selectedImagePath': ProfileIcons.careSelected,
        'unselectedImagePath': ProfileIcons.careUnselected,
        'label': 'Care',
      },
      {
        'selectedImagePath': ProfileIcons.familySelected,
        'unselectedImagePath': ProfileIcons.familyUnselected,
        'label': 'Family',
      },
      {
        'selectedImagePath': ProfileIcons.ausaContentSelected,
        'unselectedImagePath': ProfileIcons.ausaContentUnselected,
        'label': 'Ausa Connect',
      },
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
