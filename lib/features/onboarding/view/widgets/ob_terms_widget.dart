import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/home/page/home_page.dart';
import 'package:ausa/features/onboarding/view/terms_condtion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OnboardingTermsWidget extends StatelessWidget {
  const OnboardingTermsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Expand button
        Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.xl6,
            right: AppSpacing.xl,
            top: AppSpacing.xl,
            bottom: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.lg),
                child: Text(
                  'Terms',
                  style: AppTypography.headline().copyWith(),
                ),
              ),
              AusaButton(
                borderColor: Colors.transparent,
                text: 'Expand',
                leadingIcon: SvgPicture.asset(
                  AusaIcons.expand06,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary500,
                    BlendMode.srcIn,
                  ),
                  height: DesignScaleManager.scaleValue(40),
                  width: DesignScaleManager.scaleValue(40),
                ),
                variant: ButtonVariant.secondary,
                onPressed: () {
                  Get.to(() => TermsConditionPage());
                },
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl6),
          child: Text(
            'Read through the terms and conditions.',
            style: AppTypography.callout(
              weight: AppTypographyWeight.medium,
              color: AppColors.bodyTextColor,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.xl),
        // Terms content
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.mdLarge),
          child: Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              constraints: BoxConstraints(
                maxHeight: DesignScaleManager.scaleValue(800),
              ),
              child: SingleChildScrollView(
                child: Text(
                  '''WAIVER OF LIABILITY AND AGREEMENT OF USE
        
        Effective Date: Mar 15, 2025
        
        PLEASE READ THIS AGREEMENT CAREFULLY. BY USING THIS DEVICE, YOU ACKNOWLEDGE THAT YOU HAVE READ, UNDERSTOOD, AND AGREED TO THE FOLLOWING TERMS.
        
        1. Acceptance of Terms
        
        By proceeding with the use of this medical device ("Device"), you ("User") acknowledge and agree to the terms outlined in this Waiver of Liability and Agreement of Use ("Agreement"). If you do not agree to these terms, do not use the Device.
        
        2. Purpose of the Device
        
        This Device is designed to collect and monitor vital signs and provide digital access to health resources and analytics for facilitating...''',
                  style: AppTypography.callout(
                    weight: AppTypographyWeight.regular,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl3,
            vertical: AppSpacing.xl4,
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AusaButton(
                  size: ButtonSize.lg,
                  text: 'Decline',
                  variant: ButtonVariant.secondary,
                  onPressed: () {},
                ),

                SizedBox(width: AppSpacing.lg),
                AusaButton(
                  size: ButtonSize.lg,
                  onPressed: () {
                    Get.offAll(() => HomePage());
                  },
                  text: 'Accept',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
