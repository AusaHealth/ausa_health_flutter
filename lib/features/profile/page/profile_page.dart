import 'package:ausa/common/widget/app_icons.dart';
import 'package:ausa/common/widget/custom_nav.dart';
import 'package:ausa/common/widget/settings_header.dart';
import 'package:ausa/features/profile/page/care_page.dart';
import 'package:ausa/features/profile/page/condition_page.dart';
import 'package:ausa/features/profile/widget/profile_tabs.dart';
import 'package:ausa/features/profile/widget/profile_widget.dart';

import 'package:flutter/material.dart';

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
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomNav(title: 'Your Profile'),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: ProfileTabs(
                              selectedIndex: selectedTab,
                              onTabSelected:
                                  (i) => setState(() => selectedTab = i),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 12.0),
                      child: Image.asset(
                        ProfileIcons.ausaLogo,
                        height: 150,
                        width: 230,
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (selectedTab == 0) {
                        return ProfileWidget();
                      } else if (selectedTab == 1) {
                        return ConditionPage();
                      } else if (selectedTab == 2) {
                        return CarePage();
                      } else if (selectedTab == 3) {
                        return Center(child: Text('Family View'));
                      } else if (selectedTab == 4) {
                        return Center(child: Text('AUSA Connect'));
                      } else {
                        return SizedBox.shrink();
                      }
                    },
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
