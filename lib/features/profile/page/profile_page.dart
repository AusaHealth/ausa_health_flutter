import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_icons.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/custom_nav.dart';
import 'package:ausa/common/widget/custom_header.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/features/profile/page/ausa_connect.dart';
import 'package:ausa/features/profile/page/care_page.dart';
import 'package:ausa/features/profile/page/condition_page.dart';

import 'package:ausa/features/profile/page/family_page.dart';
import 'package:ausa/features/profile/widget/profile_tabs.dart';
import 'package:ausa/features/profile/widget/profile_widget.dart';
import 'package:ausa/features/settings/page/setting_page.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                const CustomHeader(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppBackHeader(title: 'Your profile'),
                        // const CustomNav(title: 'Your profile'),
                        SizedBox(height: AppSpacing.md),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ).copyWith(left: AppSpacing.xl5),
                          child: ProfileTabs(
                            selectedIndex: selectedTab,
                            onTabSelected:
                                (i) => setState(() => selectedTab = i),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Image.asset(
                        ProfileIcons.ausaLogo,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.smMedium),
                AppMainContainer(
                  child: Builder(
                    builder: (context) {
                      if (selectedTab == 0) {
                        return ProfileWidget();
                      } else if (selectedTab == 1) {
                        return ConditionPage();
                      } else if (selectedTab == 2) {
                        return CarePage();
                      } else if (selectedTab == 3) {
                        return FamilyPage();
                      } else if (selectedTab == 4) {
                        return AusaConnect();
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                  // ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
