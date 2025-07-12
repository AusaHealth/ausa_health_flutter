import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/onboarding/view/onboarding_wrapper.dart';
import 'package:ausa/features/onboarding/view/otp_verification_view.dart';
import 'package:ausa/features/onboarding/view/phone_input_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationWidget extends StatefulWidget {
  const OtpVerificationWidget({super.key});

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {
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

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl6,
        vertical: AppSpacing.xl4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Phone Number',
                style: AppTypography.bodyBold(
                  color: AppColors.bodyTextLightColor,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Get.to(() => PhoneNumberInputModal());
                },
                icon: Icon(Icons.apps, color: Color(0xFF3CB2FF)),
                label: Text(
                  'Choose another number',
                  style: AppTypography.bodyMedium(color: Color(0xFF3CB2FF)),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            return Text(
              'Enter code sent to ${controller.phoneController.value.text}',
              style: AppTypography.calloutMedium(
                color: AppColors.bodyTextColor,
              ),
            );
          }),

          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Obx(() {
                  return Pinput(
                    onTap: () {
                      Get.to(() => OtpVerificationView());
                    },
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
          const SizedBox(height: 18),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Obx(() {
                return Text(
                  'OTP expires in 0:${controller.otpSeconds.value.toString().padLeft(2, '0')} seconds',
                  style: AppTypography.body(
                    color: AppColors.bodyTextColor,
                  ).copyWith(fontWeight: FontWeight.w500),
                );
              }),
            ),
          ),
          const Spacer(),

          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AusaButton(
                  width: 180,
                  borderRadius: 60,
                  onPressed: () {
                    controller.completeStep(OnboardingStep.otp);
                    controller.goToStep(OnboardingStep.personalDetails);
                  },
                  text: 'Proceed',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
