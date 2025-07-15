import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/utils.dart';
import 'package:ausa/features/profile/model/family_model.dart';
import 'package:ausa/features/profile/page/add_new_member.dart';
import 'package:ausa/features/profile/widget/add_family_dialouge.dart';
import 'package:ausa/features/profile/widget/horizontal_tab_bar.dart';
import 'package:ausa/features/profile/widget/member_summary_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'dart:ui';

import 'package:get/get_core/src/get_main.dart';

class FamilyViewPage extends StatefulWidget {
  const FamilyViewPage({super.key});

  @override
  State<FamilyViewPage> createState() => _FamilyViewPageState();
}

class _FamilyViewPageState extends State<FamilyViewPage> {
  int selectedTab = 0;
  final List<String> tabItems = ['Chris', 'Monica', 'Santiago', 'Ashwin'];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              height: DesignScaleManager.scaleValue(96),
              width: DesignScaleManager.scaleValue(900),
              child: HorizontalTabBar(
                items: tabItems,
                selectedIndex: selectedTab,
                onSelected: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
              ),
            ),
            Spacer(),
            AusaButton(
              variant: ButtonVariant.secondary,
              borderColor: Color(0xff1570EF).withValues(alpha: 0.1),
              textColor: AppColors.primary400,
              backgroundColor: Colors.white,
              leadingIcon: SvgPicture.asset(
                AusaIcons.placeholder,
                height: DesignScaleManager.scaleValue(48),
                width: DesignScaleManager.scaleValue(48),
                colorFilter: ColorFilter.mode(
                  AppColors.primary400,
                  BlendMode.srcIn,
                ),
              ),
              text: 'Add Member',
              onPressed: () {
                Utils.showBlurredDialog(context, AddFamilyDialouge());
              },
            ),
          ],
        ),

        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(top: AppSpacing.lg),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.xl3),
                    child: Image.asset(
                      'assets/images/profile.png',
                      fit: BoxFit.fill,
                      height: 400,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.lg),

              // Profile Details Card with Gradient Background
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: AppSpacing.xl4,
                                right: AppSpacing.xl4,
                                top: AppSpacing.xl4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.xl3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MemberSummaryCardWidget(
                                    isFamily: true,
                                    member: FamilyModel(
                                      shortName: 'Chris',
                                      fullName: 'Christopher Chavez',
                                      phone: '+1 555-123-4567',
                                      email: 'johndoes@clinic.com',
                                      relationship: 'Friend',
                                      address:
                                          '1234 Maplewood Lane Springfield, IL 62704',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: AppSpacing.xl,
                              top: 14,
                              child: AusaButton(
                                height: DesignScaleManager.scaleValue(100),
                                onPressed: () async {},
                                variant: ButtonVariant.tertiary,
                                leadingIcon: SvgPicture.asset(
                                  height: DesignScaleManager.scaleValue(32),
                                  width: DesignScaleManager.scaleValue(32),
                                  AusaIcons.edit01,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.primary500,
                                    BlendMode.srcIn,
                                  ),
                                ),

                                text: 'Edit',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
