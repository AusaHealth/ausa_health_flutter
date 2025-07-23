import 'dart:ui';

import 'package:ausa/common/custom_keyboard.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/close_button_widget.dart';
import 'package:ausa/common/widget/otp_input_widget.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/helpers.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/onboarding/view/onboarding_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
      width: DesignScaleManager.scaleValue(219),
      height: DesignScaleManager.scaleValue(219),
      textStyle: AppTypography.headline(
        weight: AppTypographyWeight.medium,
        color: AppColors.bodyTextColor,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(200),
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
          Positioned(top: 4, right: 4, child: CloseButtonWidget()),

          Positioned(
            top: 80,
            left: DesignScaleManager.scaleValue(104),
            right: 32,
            child: Obx(() {
              return Text(
                'Enter code sent to ${Helpers.formatPhoneNumber(controller.phoneNumber.value)}',
                style: AppTypography.body(
                  color: Colors.white,
                  weight: AppTypographyWeight.regular,
                ),
              );
            }),
          ),

          Positioned(
            top: 120,
            left: DesignScaleManager.scaleValue(48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: DesignScaleManager.scaleValue(1500),

                  child: Obx(() {
                    return OtpInputWidget(
                      controller: controller.otpController,
                      focusNode: controller.otpFocusNode,
                      obscureText: controller.obscureOtp.value,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      preFilledWidget: Text(
                        'x',
                        style: AppTypography.headline(
                          weight: AppTypographyWeight.medium,
                          color: AppColors.greyTextColor,
                        ),
                      ),
                      onChanged: (value) {
                        controller.handleOtpInputChange(value);
                      },
                      onCompleted: (pin) {},
                      showVisibilityToggle: true,
                      onToggleVisibility: controller.toggleOtpVisibility,
                      isObscured: controller.obscureOtp.value,
                      visibilityIconColor: AppColors.blackColor2,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      length: 6,
                    );
                  }),
                ),
              ],
            ),
          ),

          Positioned(
            top: 220,
            right: DesignScaleManager.scaleValue(48),
            child: AusaButton(
              size: ButtonSize.lg,
              trailingIcon: SvgPicture.asset(
                AusaIcons.arrowRight,
                width: DesignScaleManager.scaleValue(40),
                height: DesignScaleManager.scaleValue(40),
                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              ),
              onPressed: () {
                controller.completeStep(OnboardingStep.otp);
                controller.goToStep(OnboardingStep.personalDetails);
                Get.to(() => OnboardingWrapper());
              },
              text: 'Proceed',
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomKeyboard(
              height: DesignScaleManager.keyboardHeight.toDouble(),
              fontSize: 14,
              keyboardType: CustomKeyboardType.numeric,
              onKeyPressed: (v) {
                controller.otpController.text += v;
              },
              onEnterPressed: () {
                controller.completeStep(OnboardingStep.otp);
                controller.goToStep(OnboardingStep.personalDetails);
                Get.to(() => OnboardingWrapper());
              },
              onBackspacePressed: () {
                controller.otpController.text = controller.otpController.text
                    .substring(0, controller.otpController.text.length - 1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
