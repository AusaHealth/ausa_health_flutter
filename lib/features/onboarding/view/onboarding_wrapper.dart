import 'package:ausa/common/widget/app_main_container.dart';
import 'package:ausa/common/widget/custom_header.dart';
import 'package:ausa/constants/app_images.dart';
import 'package:ausa/constants/constants.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_lang_selection_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_personal_detail_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_terms_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_wifi_selection_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/otp_verification_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/phone_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

        'step': OnboardingStep.language,
        'icon': AusaIcons.translate01,
      },
      {'label': 'Wi-Fi', 'step': OnboardingStep.wifi, 'icon': AusaIcons.wifi},
      {'label': 'Phone', 'step': OnboardingStep.phone, 'icon': AusaIcons.phone},
      {
        'label': 'Personal Details',

        'step': OnboardingStep.personalDetails,
        'icon': AusaIcons.user01,
      },
      {
        'label': 'Terms',
        'icon': AusaIcons.file02,
        'step': OnboardingStep.terms,
      },
    ];
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl6,
        vertical: AppSpacing.xl4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, 👋',
            style: AppTypography.headline(weight: AppTypographyWeight.medium),
          ),
          Text(
            "Let's Get you started",
            style: AppTypography.body(weight: AppTypographyWeight.regular),
          ),
          SizedBox(height: AppSpacing.xl),
          for (int i = 0; i < steps.length; i++) ...[
            Row(
              children: [
                Container(
                  width: DesignScaleManager.scaleValue(80),
                  height: DesignScaleManager.scaleValue(80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    border:
                        (completedSteps.contains(steps[i]['step']) ||
                                steps[i]['step'] == currentStep)
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                  ),

                  child: Container(
                    height: DesignScaleManager.scaleValue(68),
                    width: DesignScaleManager.scaleValue(68),
                    decoration: BoxDecoration(
                      color:
                          completedSteps.contains(steps[i]['step'])
                              ? Colors.green
                              : steps[i]['step'] == currentStep
                              ? Colors.blue
                              : Colors.white,
                      shape: BoxShape.circle,
                      border:
                          (completedSteps.contains(steps[i]['step']) ||
                                  steps[i]['step'] == currentStep)
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                    ),
                    child: Center(
                      child:
                          completedSteps.contains(steps[i]['step'])
                              ? SvgPicture.asset(
                                AusaIcons.check,
                                width: DesignScaleManager.scaleValue(40),
                                height: DesignScaleManager.scaleValue(40),
                                color: Colors.white,
                              )
                              : SvgPicture.asset(
                                steps[i]['icon'].toString(),
                                width: DesignScaleManager.scaleValue(40),
                                height: DesignScaleManager.scaleValue(40),
                                color:
                                    steps[i]['step'] == currentStep
                                        ? Colors.white
                                        : Colors.grey,
                              ),
                    ),
                  ),
                ),
                // CircleAvatar(
                //   radius: 20,
                //   backgroundColor: Colors.transparent,
                //   child:
                //       completedSteps.contains(steps[i]['step'])
                //           ? Image.asset(AppImages.done, width: 50, height: 50)
                //           : steps[i]['step'] == currentStep
                //           ? Image.asset(
                //             steps[i]['image'] as String,
                //             width: 50,
                //             height: 50,
                //           )
                //           : Image.asset(
                //             steps[i]['unselectedImage'] as String,
                //             width: 50,
                //             height: 50,
                //           ),
                // ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${i + 1}',
                      style: AppTypography.callout(
                        color: Color(0xff828282),
                        weight: AppTypographyWeight.regular,
                      ),
                    ),
                    Text(
                      steps[i]['label'] as String,
                      style: AppTypography.body(
                        weight: AppTypographyWeight.medium,
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
