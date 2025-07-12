import 'dart:ui';

import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/on_screen_keyboard_widget.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/onboarding/view/onboarding_wrapper.dart';
import 'package:ausa/features/onboarding/view/phone_input_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    final defaultPinTheme = PinTheme(
      width: 64,
      height: 64,
      textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(32),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(color: Colors.white),
    );

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
            child: Obx(() {
              return Text(
                'Enter code sent to ${controller.phoneController.value.text}',
                style: AppTypography.title2(
                  color: Colors.white,
                ).copyWith(fontSize: 16, fontWeight: FontWeight.w500),
              );
            }),
          ),

          // const SizedBox(height: 32),
          Positioned(
            top: 120,
            left: 32,
            right: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width * 0.66,
                  child: Obx(() {
                    return Pinput(
                      controller: controller.otpController,
                      focusNode: controller.otpFocusNode,
                      length: 6,
                      obscureText: controller.obscureOtp.value,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      onChanged: (value) {
                        controller.handleOtpInputChange(value);
                      },
                      onCompleted: (pin) {
                        // Handle completion if needed
                      },
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: InkWell(
                    onTap: () => controller.toggleOtpVisibility(),
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Obx(() {
                        return Icon(
                          controller.obscureOtp.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blueGrey,
                          size: 28,
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Positioned(
          //   top: 220,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 18,
          //         vertical: 6,
          //       ),
          //       decoration: BoxDecoration(
          //         color: Colors.white.withOpacity(0.7),
          //         borderRadius: BorderRadius.circular(18),
          //       ),
          //       child: Obx(() {
          //         return Text(
          //           'OTP expires in 0:${controller.otpSeconds.value.toString().padLeft(2, '0')} seconds',
          //           style: AppTypography.body(
          //             color: AppColors.bodyTextColor,
          //           ).copyWith(fontWeight: FontWeight.w500),
          //         );
          //       }),
          //     ),
          //   ),
          // ),
          Positioned(
            top: 220,

            right: 32,
            child: Center(
              child: AusaButton(
                text: 'Proceed',
                onPressed: () {
                  if (!controller.isOtpValid) {
                    Get.snackbar('Error', 'Please enter a valid OTP');
                    return;
                  }
                  Get.to(() => OnboardingWrapper());
                  controller.completeStep(OnboardingStep.otp);
                  controller.goToStep(OnboardingStep.terms);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: OnScreenKeyboardWidget(
              controller: controller.otpController,
              type: VirtualKeyboardType.Numeric,
              color: Color(0xffE3E6EE),
            ),
          ),
        ],
      ),
    );
  }
}
