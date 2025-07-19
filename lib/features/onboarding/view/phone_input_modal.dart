import 'dart:ui';
import 'package:ausa/common/custom_keyboard.dart';
import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/common/widget/close_button_widget.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/helpers.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/onboarding/view/onboarding_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneNumberInputModal extends StatefulWidget {
  const PhoneNumberInputModal({super.key});

  @override
  State<PhoneNumberInputModal> createState() => _PhoneNumberInputModalState();
}

class _PhoneNumberInputModalState extends State<PhoneNumberInputModal> {
  final controller = Get.find<OnboardingController>();
  bool isPhoneNumberValid = false;

  String _formatPhoneNumber(String value) {
    if (value.isEmpty) return '';

    // Remove all non-digit characters
    value = value.replaceAll(RegExp(r'\D'), '');

    // Limit to 10 digits
    if (value.length > 10) {
      value = value.substring(0, 10);
    }

    // Format the number
    if (value.length >= 7) {
      return '(${value.substring(0, 3)}) ${value.substring(3, 6)}-${value.substring(6)}';
    } else if (value.length >= 4) {
      return '(${value.substring(0, 3)}) ${value.substring(3)}';
    } else if (value.length >= 1) {
      return '(${value}';
    }

    return value;
  }

  void validatePhoneNumber(String value) {
    // Remove all formatting to get just the digits
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    setState(() {
      // Valid if exactly 10 digits
      isPhoneNumberValid = digitsOnly.length == 10;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            top: DesignScaleManager.scaleValue(128),
            left: DesignScaleManager.scaleValue(48),
            right: DesignScaleManager.scaleValue(48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: AppSpacing.xl6),
                  child: Text(
                    'Phone Number',
                    style: AppTypography.body(
                      weight: AppTypographyWeight.regular,
                      color: AppColors.white,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.mdLarge),
                AnimatedContainer(
                  height: DesignScaleManager.scaleValue(304),
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: AppSpacing.xl3),
                  padding: EdgeInsets.all(AppSpacing.xl3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(AppRadius.xl3),
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: AppSpacing.xl3),
                    child: TextField(
                      readOnly: true, // Use custom keyboard instead
                      controller: controller.phoneController,
                      style: AppTypography.body(
                        weight: AppTypographyWeight.regular,
                        color: AppColors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixText: '+1 ',
                        prefixStyle: AppTypography.body(
                          weight: AppTypographyWeight.regular,
                          color: AppColors.black,
                        ),
                        hintText: '+1 (000) 000-0000',
                        hintStyle: AppTypography.body(
                          weight: AppTypographyWeight.regular,
                          color: AppColors.hintTextColor,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isPhoneNumberValid)
            Positioned(
              top: DesignScaleManager.scaleValue(560),
              left: DesignScaleManager.scaleValue(140),
              right: DesignScaleManager.scaleValue(48),
              child: Text(
                isPhoneNumberValid ? 'Verified' : 'Invalid phone number',
                style: AppTypography.body(
                  color: isPhoneNumberValid ? Colors.green : Colors.red,
                  weight: AppTypographyWeight.medium,
                ),
              ),
            ),
          Positioned(
            top: DesignScaleManager.scaleValue(580),
            left: DesignScaleManager.scaleValue(32),
            right: DesignScaleManager.scaleValue(48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AusaButton(
                  size: ButtonSize.md,
                  onPressed:
                      isPhoneNumberValid
                          ? () {
                            Get.offAll(() => OnboardingWrapper());
                            controller.completeStep(OnboardingStep.phone);
                            controller.goToStep(OnboardingStep.otp);
                            controller.startOtpTimer();
                          }
                          : null,
                  text: 'Send OTP',
                ),
              ],
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
                // Get current value without formatting
                final currentValue = controller.phoneController.text.replaceAll(
                  RegExp(r'\D'),
                  '',
                );

                // Only proceed if we haven't reached 10 digits
                if (currentValue.length < 10) {
                  final newValue = currentValue + v;
                  final formatted = _formatPhoneNumber(newValue);
                  controller.phoneController.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(
                      offset: formatted.length,
                    ),
                  );
                  validatePhoneNumber(formatted);
                }
              },
              onBackspacePressed: () {
                if (controller.phoneController.text.isNotEmpty) {
                  // Get current value without formatting
                  var currentValue = controller.phoneController.text.replaceAll(
                    RegExp(r'\D'),
                    '',
                  );
                  if (currentValue.isNotEmpty) {
                    currentValue = currentValue.substring(
                      0,
                      currentValue.length - 1,
                    );
                    final formatted = _formatPhoneNumber(currentValue);
                    controller.phoneController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(
                        offset: formatted.length,
                      ),
                    );
                    validatePhoneNumber(formatted);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
