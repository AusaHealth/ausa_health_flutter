import 'dart:developer';

import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/color.dart';
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
        Text(
          'Language',
          style: AppTypography.bodyBold(color: AppColors.textColor),
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          'Choose the language familiar to you',
          style: AppTypography.calloutMedium(color: AppColors.textlightColor),
        ),
        const SizedBox(height: 32),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                style: TextStyle(fontSize: 16, color: Colors.black54),
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                flagImage,
                width: 90,
                height: 90,
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
