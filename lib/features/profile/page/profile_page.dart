import 'package:ausa/common/widget/app_back_header.dart';
import 'package:ausa/common/widget/app_icons.dart';
import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/base_scaffold.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/custom_nav.dart';
import 'package:ausa/common/widget/custom_header.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/design_scale.dart';
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
                    child: const AppBackHeader2(title: 'Your profile'),
                  ),
                  SizedBox(height: AppSpacing.xl2),

                  Padding(
                    padding: EdgeInsets.only(left: AppSpacing.xl6),
                    child: ProfileTabs(
                      selectedIndex: selectedTab,
                      onTabSelected: (i) => setState(() => selectedTab = i),
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ).copyWith(top: 12),
                  child: Image.asset(
                    ProfileIcons.ausaLogo,
                    height: DesignScaleManager.scaleValue(207),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.lg),
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
    );
  }
}
