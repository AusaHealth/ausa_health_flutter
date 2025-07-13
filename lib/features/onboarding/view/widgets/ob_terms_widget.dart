import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/home/page/home_page.dart';
import 'package:ausa/features/onboarding/view/terms_condtion_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingTermsWidget extends StatelessWidget {
  const OnboardingTermsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl6,
        vertical: AppSpacing.xl4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Expand button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Terms', style: AppTypography.headline().copyWith()),
              AusaButton(
                borderColor: Colors.transparent,
                text: 'Expand',
                leadingIcon: Icon(Icons.open_in_full, color: Colors.blue),
                variant: ButtonVariant.secondary,
                onPressed: () {
                  Get.to(() => TermsConditionPage());
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Read through the terms and conditions.',
            style: TextStyle(fontSize: 18, color: Color(0xFF1A2341)),
          ),
          const SizedBox(height: 16),
          // Terms content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              // constraints: BoxConstraints(maxHeight: 228),
              child: SingleChildScrollView(
                child: Text(
                  '''WAIVER OF LIABILITY AND AGREEMENT OF USE
              
              Effective Date: Mar 15, 2025
              
              PLEASE READ THIS AGREEMENT CAREFULLY. BY USING THIS DEVICE, YOU ACKNOWLEDGE THAT YOU HAVE READ, UNDERSTOOD, AND AGREED TO THE FOLLOWING TERMS.
              
              1. Acceptance of Terms
              
              By proceeding with the use of this medical device ("Device"), you ("User") acknowledge and agree to the terms outlined in this Waiver of Liability and Agreement of Use ("Agreement"). If you do not agree to these terms, do not use the Device.
              
              2. Purpose of the Device
              
              This Device is designed to collect and monitor vital signs and provide digital access to health resources and analytics for facilitating...''',
                  style: AppTypography.body(
                    weight: AppTypographyWeight.regular,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AusaButton(
                text: 'Decline',
                variant: ButtonVariant.secondary,
                onPressed: () {},
              ),

              SizedBox(width: AppSpacing.lg),
              AusaButton(
                onPressed: () {
                  Get.offAll(() => HomePage());
                },
                text: 'Accept',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
