import 'dart:developer';

import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/onboarding_controller.dart';

class OnboardingLanguagePage extends StatelessWidget {
  const OnboardingLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl6,
            vertical: AppSpacing.xl4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Language',
                style: AppTypography.headlineSemibold(
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Choose the language familiar to you',
                style: AppTypography.calloutMedium(
                  color: AppColors.textlightColor,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LanguageCard(
              flagImage: AppImages.usFlag,
              language: 'English',
              onTap: () {
                controller.completeStep(OnboardingStep.language);
                controller.goToStep(OnboardingStep.wifi);
                // controller.completeStep(OnboardingStep.language);
                // controller.goToStep(OnboardingStep.wifi);
              },
            ),

            LanguageCard(
              flagImage: AppImages.spainFlag,
              language: 'Español',
              onTap: () {
                controller.completeStep(OnboardingStep.language);
                controller.goToStep(OnboardingStep.wifi);
              },
            ),

            LanguageCard(
              flagImage: AppImages.chinaFlag,
              language: '中文',
              onTap: () {
                controller.completeStep(OnboardingStep.language);
                controller.goToStep(OnboardingStep.wifi);
              },
            ),
          ],
        ),
        const Spacer(),
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Color(0xFFEAF6FF),
                child: Icon(Icons.mic, size: 36, color: Colors.blueAccent),
              ),
              SizedBox(height: 12),
              Text(
                'Tap to speak / Toca para hablar / 点击说话',
                style: AppTypography.bodyMedium(
                  color: AppColors.textlightColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}

class LanguageCard extends StatelessWidget {
  final String flagImage;
  final String language;
  final VoidCallback onTap;
  const LanguageCard({
    super.key,
    required this.flagImage,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        margin: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        height: DesignScaleManager.scaleValue(336),
        width: DesignScaleManager.scaleValue(336),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Image.asset(
                flagImage,
                width: DesignScaleManager.scaleValue(200),
                height: DesignScaleManager.scaleValue(200),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              language,
              style: AppTypography.bodyMedium(color: AppColors.bodyTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
