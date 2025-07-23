import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/otp_input_widget.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/helpers.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
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
      width: DesignScaleManager.scaleValue(132),
      height: DesignScaleManager.scaleValue(132),
      textStyle: AppTypography.headline(
        weight: AppTypographyWeight.medium,
        color: AppColors.bodyTextColor,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl3),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(AppRadius.xl3),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(color: Colors.white),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.xl6,
            right: AppSpacing.xl,
            top: AppSpacing.xl,
            bottom: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.lg),
                child: Text(
                  'Phone Number',
                  style: AppTypography.headline(
                    weight: AppTypographyWeight.semibold,
                  ),
                ),
              ),
              AusaButton(
                textColor: AppColors.primary500,
                borderColor: Colors.transparent,
                leadingIcon: Icon(Icons.apps, color: Color(0xFF3CB2FF)),
                variant: ButtonVariant.secondary,
                onPressed: () {
                  Get.to(() => PhoneNumberInputModal());
                },
                text: 'Choose another number',
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return Text(
                  'Enter code sent to ${Helpers.formatPhoneNumber(controller.phoneNumber.value)}',
                  style: AppTypography.callout(
                    weight: AppTypographyWeight.medium,
                    color: AppColors.bodyTextColor,
                  ),
                );
              }),

              SizedBox(height: AppSpacing.xl2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
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
                        onTap: () {
                          Get.to(() => OtpVerificationView());
                        },
                        onChanged: (value) {
                          controller.handleOtpInputChange(value);
                        },
                        onCompleted: (pin) {},
                        showVisibilityToggle: true,
                        onToggleVisibility: controller.toggleOtpVisibility,
                        isObscured: controller.obscureOtp.value,
                        visibilityIconColor: AppColors.primary500,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        length: 6,
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl3),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 6,
                  ),
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
            ],
          ),
        ),
        const Spacer(),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl3,
            vertical: AppSpacing.xl4,
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AusaButton(
                  trailingIcon: Icon(Icons.arrow_forward, color: Colors.white),
                  size: ButtonSize.lg,
                  onPressed: () {
                    controller.completeStep(OnboardingStep.otp);
                    controller.goToStep(OnboardingStep.personalDetails);
                  },
                  text: 'Proceed',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
