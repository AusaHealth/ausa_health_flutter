import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/features/home/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:ausa/constants/typography.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class TermsConditionPage extends StatelessWidget {
  const TermsConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF000A20).withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Expand button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Terms',
                    style: AppTypography.body(
                      color: Colors.white,
                      weight: AppTypographyWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Read through the terms and conditions.',
                style: AppTypography.body(color: Colors.white),
              ),
              const SizedBox(height: 24),
              // Terms content
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.all(24),
                      // constraints: const BoxConstraints(maxHeight: 415),
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
                  
                              ''',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    // Buttons
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              // Decline logic
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: const Text(
                              'Decline',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          AusaButton(
                            width: 130,

                            onPressed: () {
                              // Accept logic
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
      ),
    );
  }
}
