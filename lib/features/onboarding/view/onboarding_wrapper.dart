import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/custom_header.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/constants.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_lang_selection_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_personal_detail_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_terms_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_wifi_selection_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/otp_verification_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/phone_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        child: Column(
          children: [
            CustomHeader(),
            SizedBox(height: AppSpacing.xl3),
            AppMainContainer(
              backgroundColor: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.xl3),
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
                  SizedBox(width: AppSpacing.lg),
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.xl3),
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
                          case OnboardingStep.personalDetails:
                            return ObPersonalDetailWidget();
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
          ],
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
        'label': 'Personal Details',
        'image': AppImages.personalDetails,
        'step': OnboardingStep.personalDetails,
        'unselectedImage': AppImages.personalDetailsUnselected,
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
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl6,
        vertical: AppSpacing.xl4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hello, 👋', style: AppTypography.headlineMedium()),
          Text('Lets Get you started', style: AppTypography.bodyRegular()),
          SizedBox(height: AppSpacing.xl),
          for (int i = 0; i < steps.length; i++) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child:
                      completedSteps.contains(steps[i]['step'])
                          ? Image.asset(AppImages.done, width: 50, height: 50)
                          : steps[i]['step'] == currentStep
                          ? Image.asset(
                            steps[i]['image'] as String,
                            width: 50,
                            height: 50,
                          )
                          : Image.asset(
                            steps[i]['unselectedImage'] as String,
                            width: 50,
                            height: 50,
                          ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${i + 1}',
                      style: AppTypography.calloutRegular(
                        color: Color(0xff828282),
                      ),
                    ),
                    Text(
                      steps[i]['label'] as String,
                      style: AppTypography.bodyMedium(
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (i < steps.length - 1)
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 2,
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
