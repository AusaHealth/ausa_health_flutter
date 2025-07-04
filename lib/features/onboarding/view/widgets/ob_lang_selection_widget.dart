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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          colors: [Color(0xFFF8FBFD), Color(0xFFB6F3F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LanguageCard(
                flagAsset: '🇺🇸',
                language: 'English',
                onTap: () {
                  controller.completeStep(OnboardingStep.language);
                  controller.goToStep(OnboardingStep.wifi);
                },
              ),
              const SizedBox(width: 24),
              LanguageCard(
                flagAsset: '🇪🇸',
                language: 'Español',
                onTap: () {
                  controller.completeStep(OnboardingStep.language);
                  controller.goToStep(OnboardingStep.wifi);
                },
              ),
              const SizedBox(width: 24),
              LanguageCard(
                flagAsset: '🇨🇳',
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
      ),
    );
    ;
  }
}

class LanguageCard extends StatelessWidget {
  final String flagAsset;
  final String language;
  final VoidCallback onTap;
  const LanguageCard({
    Key? key,
    required this.flagAsset,
    required this.language,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
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
          children: [
            Text(flagAsset, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              language,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
