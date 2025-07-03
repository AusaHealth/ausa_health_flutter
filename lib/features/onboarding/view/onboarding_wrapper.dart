import 'package:ausa/common/widget/settings_header.dart';
import 'package:ausa/constants/dimensions.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_lang_selection_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/ob_wifi_selection_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/otp_verification_widget.dart';
import 'package:ausa/features/onboarding/view/widgets/phone_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../controller/onboarding_controller.dart';
import 'package:ausa/features/settings/model/network_info_model.dart';
import 'package:ausa/features/settings/widget/settings_network_tile.dart';

class OnboardingWrapper extends StatelessWidget {
  const OnboardingWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FF),
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(),
            Center(
              child: Container(
                width: Dimensions.onboardingContainerWidth,
                height: 604,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  border: Border.all(color: Colors.white, width: 10),
                ),
                child: Row(
                  children: [
                    // Left: Steps
                    GlassmorphicContainer(
                      width: 350,
                      height: 604,
                      borderRadius: 80,
                      blur: 40,
                      alignment: Alignment.center,
                      border: 2,
                      linearGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.blue.withOpacity(0.10),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.4),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Obx(
                          () => OnboardingStepList(
                            currentStep: controller.currentStep.value,
                            completedSteps: controller.completedSteps,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Right: Dynamic content
                    Expanded(
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
                            return OnboardingLanguagePage();
                          case OnboardingStep.faceId:
                            return OnboardingLanguagePage();
                          case OnboardingStep.gestures:
                            return OnboardingLanguagePage();
                          default:
                            return Container();
                        }
                      }),
                    ),
                  ],
                ),
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
        'icon': Icons.language,
        'step': OnboardingStep.language,
      },
      {'label': 'Wi-Fi', 'icon': Icons.wifi, 'step': OnboardingStep.wifi},
      {'label': 'Phone', 'icon': Icons.phone, 'step': OnboardingStep.phone},
      {
        'label': 'Terms',
        'icon': Icons.description,
        'step': OnboardingStep.terms,
      },
      {'label': 'Face-ID', 'icon': Icons.face, 'step': OnboardingStep.faceId},
      {
        'label': 'Gestures',
        'icon': Icons.pan_tool,
        'step': OnboardingStep.gestures,
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hello, 👋',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'Lets Get you started',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        for (int i = 0; i < steps.length; i++) ...[
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    completedSteps.contains(steps[i]['step'])
                        ? Colors.green
                        : (steps[i]['step'] == currentStep
                            ? Colors.blueAccent
                            : Colors.white),
                child:
                    completedSteps.contains(steps[i]['step'])
                        ? const Icon(Icons.check, color: Colors.white)
                        : Icon(
                          steps[i]['icon'] as IconData,
                          color:
                              steps[i]['step'] == currentStep
                                  ? Colors.white
                                  : Colors.blueAccent,
                        ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step ${i + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    steps[i]['label'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
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
    );
  }
}
