import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/close_button_widget.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/features/home/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ausa/constants/typography.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ausa/common/widget/scroller_widget.dart';

class TermsConditionPage extends StatelessWidget {
  const TermsConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF000A20).withOpacity(0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Align(alignment: Alignment.topRight, child: CloseButtonWidget()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [CloseButtonWidget()],
            ),
            Padding(
              padding: EdgeInsets.only(left: AppSpacing.xl6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms',
                    style: AppTypography.body(
                      color: Colors.white,
                      weight: AppTypographyWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Read through the terms and conditions.',
                    style: AppTypography.body(color: Colors.white),
                  ),
                ],
              ),
            ),

            // Terms content
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl2,
                      vertical: AppSpacing.xl2,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: ScrollWidget(
                        child: SingleChildScrollView(
                          child: Text(
                            '''WAIVER OF LIABILITY AND AGREEMENT OF USE
            
            Effective Date: Mar 15, 2025
            
            PLEASE READ THIS AGREEMENT CAREFULLY. BY USING THIS DEVICE, YOU ACKNOWLEDGE THAT YOU HAVE READ, UNDERSTOOD, AND AGREED TO THE FOLLOWING TERMS.
            
            1. Acceptance of Terms
            
            By proceeding with the use of this medical device ("Device"), you ("User") acknowledge and agree to the terms outlined in this Waiver of Liability and Agreement of Use ("Agreement"). If you do not agree to these terms, do not use the Device.
            
            2. Purpose of the Device
            
            This Device is designed to collect and monitor vital signs and provide digital access to health resources and analytics for facilitating...
            
            3. Use of the Device
            
            By proceeding with the use of this medical device ("Device"), you ("User") acknowledge and agree to the terms outlined in this Waiver of Liability and Agreement of Use ("Agreement"). If you do not agree to these terms, do not use the Device.
            
            2. Purpose of the Device
            
            This Device is designed to collect and monitor vital signs and provide digital access to health resources and analytics for facilitating...
                                    
            1. Acceptance of Terms
            
            By proceeding with the use of this medical device ("Device"), you ("User") acknowledge and agree to the terms outlined in this Waiver of Liability and Agreement of Use ("Agreement"). If you do not agree to these terms, do not use the Device.
            
            2. Purpose of the Device
            
            This Device is designed to collect and monitor vital signs and provide digital access to health resources and analytics for facilitating...
            
            3. Use of the Device
            
            By proceeding with the use of this medical device ("Device"), you ("User") acknowledge and agree to the terms outlined in this Waiver of Liability and Agreement of Use ("Agreement"). If you do not agree to these terms, do not use the Device.
            
            2. Purpose of the Device
            
            This Device is designed to collect and monitor vital signs and provide digital access to health resources and analytics for facilitating...

            
                  
            ''',
                            style: AppTypography.callout(
                              weight: AppTypographyWeight.regular,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Buttons
                  Positioned(
                    bottom: AppSpacing.xl5,
                    right: AppSpacing.xl4,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
