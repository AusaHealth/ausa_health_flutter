import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/profile/controller/profile_controller.dart';
import 'package:ausa/features/profile/page/add_new_member.dart';
import 'package:ausa/features/profile/page/email_invite_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddFamilyDialouge extends StatelessWidget {
  const AddFamilyDialouge({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl3),
      ),
      width: DesignScaleManager.scaleValue(568),
      height: DesignScaleManager.scaleValue(736),

      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.smMedium).copyWith(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl3),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    profileController.showSummary.value = false;
                    Get.to(() => AddNewMember());
                  },
                  child: Container(
                    height: DesignScaleManager.scaleValue(424),
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.smMedium),
                    decoration: BoxDecoration(
                      color: const Color(0xffe3f2fd),
                      borderRadius: BorderRadius.circular(AppRadius.xl3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AusaIcons.userPlus01,
                          height: DesignScaleManager.scaleValue(40),
                          width: DesignScaleManager.scaleValue(40),
                          colorFilter: ColorFilter.mode(
                            AppColors.primary700,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        Text(
                          'Add new member\nmanually',
                          textAlign: TextAlign.center,
                          style: AppTypography.callout(
                            color: AppColors.primary700,
                            weight: AppTypographyWeight.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.xl5),

                // OR divider
                Row(
                  children: [
                    Expanded(
                      child: Container(height: 1, color: Colors.grey[300]),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: Text(
                        'OR',
                        style: AppTypography.callout(
                          weight: AppTypographyWeight.medium,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(height: 1, color: Colors.grey[300]),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl4),

                AusaButton(
                  variant: ButtonVariant.secondary,
                  borderColor: Color(0xff1570EF).withValues(alpha: 0.1),
                  textColor: AppColors.primary400,
                  backgroundColor: Colors.white,
                  leadingIcon: SvgPicture.asset(
                    AusaIcons.mail05,
                    height: DesignScaleManager.scaleValue(48),
                    width: DesignScaleManager.scaleValue(48),
                    colorFilter: ColorFilter.mode(
                      AppColors.primary400,
                      BlendMode.srcIn,
                    ),
                  ),
                  text: 'Send an email invitation',
                  onPressed: () {
                    Get.to(() => EmailInvitePage());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
