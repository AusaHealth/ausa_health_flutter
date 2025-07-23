import 'dart:ui';

import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmartPromptDialog extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onTurnOff;

  const SmartPromptDialog({super.key, this.onClose, this.onTurnOff});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred dark background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 31.2, sigmaY: 31.2),
            child: Container(color: const Color.fromRGBO(0, 6, 20, 0.80)),
          ),
        ),
        Center(
          child: Container(
            width: 800,
            height: 420,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl3),
              image: DecorationImage(
                image: AssetImage(AppImages.knowMorePage),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              children: [
                // Left image
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.xl3),
                      child: Image.asset(
                        AppImages.notificationBg,
                        fit: BoxFit.cover,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
                // Right content
                Expanded(
                  flex: 1,
                  child: Material(
                    borderRadius: BorderRadius.circular(AppRadius.xl3),
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.xl2,
                        horizontal: AppSpacing.xl3,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppSpacing.xl7),
                          Text(
                            'Smart Prompt',
                            style: AppTypography.body(
                              color: Colors.white,
                              weight: AppTypographyWeight.medium,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xl3),
                          const Text(
                            'This feature automatically sets your preferences for notifications to get the best experience from Ausa Health platform.\n\n'
                            'You are in good hands :)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AusaButton(
                                borderColor: Colors.white,
                                textColor: Colors.white,

                                backgroundColor: Colors.transparent,
                                variant: ButtonVariant.secondary,
                                text: 'Close',
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                              SizedBox(width: AppSpacing.md),
                              AusaButton(
                                textColor: Color(0xff1A1A1A),

                                backgroundColor: Colors.white,

                                text: 'Turn Off',
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Close icon (optional, top right)
        Positioned(
          top: 32,
          right: 32,
          child: GestureDetector(
            onTap: onClose ?? () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }
}
