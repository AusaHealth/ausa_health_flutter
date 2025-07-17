import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/utils.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';
import 'package:ausa/features/profile/page/input_model.dart';
import 'package:ausa/features/profile/page/input_page.dart';
import 'package:ausa/features/profile/widget/add_family_dialouge.dart';
import 'package:ausa/features/profile/widget/horizontal_tab_bar.dart';
import 'package:ausa/features/profile/widget/member_summary_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FamilyViewPage extends StatefulWidget {
  const FamilyViewPage({super.key});

  @override
  State<FamilyViewPage> createState() => _FamilyViewPageState();
}

class _FamilyViewPageState extends State<FamilyViewPage> {
  int selectedTab = 0;
  final List<String> tabItems =
      Get.find<ProfileController>().familyMembers
          .map((e) => e.shortName)
          .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            tabItems.length > 1
                ? Expanded(
                  child: HorizontalTabBar(
                    items: tabItems,
                    selectedIndex: selectedTab,
                    onSelected: (index) {
                      setState(() {
                        selectedTab = index;
                      });
                    },
                  ),
                )
                : HorizontalTabBar(
                  items: tabItems,
                  selectedIndex: selectedTab,
                  onSelected: (index) {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                ),

            Spacer(),
            AusaButton(
              variant: ButtonVariant.secondary,
              borderColor: Color(0xff1570EF).withValues(alpha: 0.1),
              textColor: AppColors.primary400,
              backgroundColor: Colors.white,
              leadingIcon: SvgPicture.asset(
                AusaIcons.userPlus01,
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
                      height: DesignScaleManager.scaleValue(640),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.lg),

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
                              // padding: EdgeInsets.only(
                              //   left: AppSpacing.xl4,
                              //   right: AppSpacing.xl4,
                              //   top: AppSpacing.xl4,
                              // ),
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
                                    member:
                                        Get.find<ProfileController>()
                                            .familyMembers[selectedTab],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: AppSpacing.xl,
                              top: 14,
                              child: AusaButton(
                                height: DesignScaleManager.scaleValue(100),
                                onPressed: () async {
                                  final inputs = [
                                    InputModel(
                                      name: 'name',
                                      label: 'Name',
                                      inputType: InputTypeEnum.text,
                                    ),
                                    InputModel(
                                      name: 'phone',
                                      label: 'Phone',
                                      inputType: InputTypeEnum.text,
                                    ),
                                  ];
                                  Get.to(InputPage(inputs: inputs));
                                },
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
