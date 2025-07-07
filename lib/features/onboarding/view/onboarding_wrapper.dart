import 'package:ausa/common/widget/settings_header.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/dimensions.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_lang_selection_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_terms_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_wifi_selection_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/otp_verification_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/phone_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../controller/onboarding_controller.dart';

class OnboardingWrapper extends StatelessWidget {
  const OnboardingWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6B9FFF), Color(0xFF7ED3D1), Color(0xFFA8E6CF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CustomHeader(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(80),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
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
                            children: [
                              Obx(
                                () => OnboardingStepList(
                                  currentStep: controller.currentStep.value,
                                  completedSteps: controller.completedSteps,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
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
                          child: Obx(() {
                            switch (controller.currentStep.value) {
                              case OnboardingStep.language:
                                return OnboardingLanguagePage();
                              case OnboardingStep.wifi:
                                return OnboardingWifiPage();
                              case OnboardingStep.phone:
                                return PhoneNumberWidget();
                              case OnboardingStep.otp:
                                return OtpVerificationWidget();
                              case OnboardingStep.terms:
                                return OnboardingTermsWidget();
                              default:
                                return Container();
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingStepList extends StatelessWidget {
  final OnboardingStep currentStep;
  final Set<OnboardingStep> completedSteps;
  const OnboardingStepList({
    super.key,
    required this.currentStep,
    required this.completedSteps,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'label': 'Language',
        'image': AppImages.langSelected,
        'step': OnboardingStep.language,
        'unselectedImage': AppImages.langSelected,
      },
      {
        'label': 'Wi-Fi',
        'image': AppImages.wifiSelected,
        'step': OnboardingStep.wifi,
        'unselectedImage': AppImages.wifiUnSelected,
      },
      {
        'label': 'Phone',
        'image': AppImages.phoneSelected,
        'step': OnboardingStep.phone,
        'unselectedImage': AppImages.phoneUnSelected,
      },
      {
        'label': 'Terms',
        'image': AppImages.termsSelected,
        'step': OnboardingStep.terms,
        'unselectedImage': AppImages.termsUnSelected,
      },
      // {'label': 'Face-ID', 'icon': Icons.face, 'step': OnboardingStep.faceId},
      // {
      //   'label': 'Gestures',
      //   'icon': Icons.pan_tool,
      //   'step': OnboardingStep.gestures,
      // },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, 👋',
            style: AppTypography.headline(
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lets Get you started',
            style: AppTypography.body(color: AppColors.textColor),
          ),
          const SizedBox(height: 32),
          for (int i = 0; i < steps.length; i++) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child:
                      completedSteps.contains(steps[i]['step'])
                          ? Image.asset(AppImages.done, width: 54, height: 54)
                          : steps[i]['step'] == currentStep
                          ? Image.asset(
                            steps[i]['image'] as String,
                            width: 54,
                            height: 54,
                          )
                          : Image.asset(
                            steps[i]['unselectedImage'] as String,
                            width: 54,
                            height: 54,
                          ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${i + 1}',
                      style: AppTypography.callout(
                        color: Color(0xff828282),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      steps[i]['label'] as String,
                      style: AppTypography.callout(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w400,
                      ).copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            if (i < steps.length - 1)
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 10,
                ).copyWith(left: 20),
                width: 2,
                height: 24,
                color: Colors.black12,
              ),
          ],
        ],
      ),
    );
  }
}
