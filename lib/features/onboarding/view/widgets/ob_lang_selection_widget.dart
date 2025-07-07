import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/color.dart';
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
          style: AppTypography.headline(color: AppColors.textColor),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the language familiar to you',
          style: AppTypography.callout(color: AppColors.textlightColor),
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
              },
            ),
            // const SizedBox(width: 24),
            LanguageCard(
              flagImage: AppImages.spainFlag,
              language: 'Español',
              onTap: () {
                controller.completeStep(OnboardingStep.language);
                controller.goToStep(OnboardingStep.wifi);
              },
            ),
            // const SizedBox(width: 24),
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
            children: const [
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
    Key? key,
    required this.flagImage,
    required this.language,
    required this.onTap,
  }) : super(key: key);

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
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(flagImage, width: 120, height: 100),

            Text(
              language,
              style: AppTypography.body(color: AppColors.bodyTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
