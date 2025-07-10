import 'dart:ui';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/custom_text_field.dart';
import 'package:ausa/common/widget/on_screen_keyboard_widget.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/onboarding/view/onboarding_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class PhoneNumberInputModal extends StatefulWidget {
  const PhoneNumberInputModal({super.key});

  @override
  State<PhoneNumberInputModal> createState() => _PhoneNumberInputModalState();
}

class _PhoneNumberInputModalState extends State<PhoneNumberInputModal> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Scaffold(
      backgroundColor: Colors.transparent, // Important for blur effect
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(color: const Color(0xFF000A20).withOpacity(0.8)),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.close, color: Colors.white),
            ),
          ),

          Positioned(
            top: 80,
            left: 32,
            right: 32,
            child: CustomTextField(
              height: 100,
              controller: controller.phoneController.value,
              hint: '+1 (000)-000 0000',
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
            ),
          ),
          Positioned(
            top: 240,
            left: 32,
            right: 32,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryButton(
                    borderRadius: 60,
                    onPressed: () {
                      Get.offAll(() => OnboardingWrapper());
                      controller.completeStep(OnboardingStep.phone);
                      controller.goToStep(OnboardingStep.otp);

                      controller.startOtpTimer();
                    },
                    text: 'SEND OTP',
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: OnScreenKeyboardWidget(
              controller: controller.phoneController.value,
              type: VirtualKeyboardType.Numeric,
              color: Color(0xffE3E6EE),
            ),
          ),
        ],
      ),
    );
  }
}
