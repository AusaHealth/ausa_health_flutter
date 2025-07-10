import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:ausa/features/onboarding/view/phone_input_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

class PhoneNumberWidget extends StatefulWidget {
  const PhoneNumberWidget({super.key});

  @override
  State<PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppTypography.body(
            color: AppColors.bodyTextLightColor,
          ).copyWith(fontWeight: FontWeight.w600, fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Your phone number is required for verification',
          style: AppTypography.callout(
            color: AppColors.bodyTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20),
        Obx(() {
          return GestureDetector(
            onTap: () {
              Get.to(() => PhoneNumberInputModal());
            },
            child: Container(
              height: 120,
              width: 500,
              padding: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white),
              ),
              alignment: Alignment.centerLeft,
              child:
                  controller.phoneController.value.text.isEmpty
                      ? Text(
                        controller.phoneController.value.text.isEmpty
                            ? '+1 (000)-000 0000'
                            : controller.phoneController.value.text,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                      : Text(
                        controller.phoneController.value.text,
                        style: AppTypography.body(
                          color: AppColors.bodyTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
            ),
          );
        }),
        SizedBox(height: 20),
        Expanded(child: SizedBox()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PrimaryButton(
                borderRadius: 60,
                onPressed: () {
                  controller.completeStep(OnboardingStep.phone);
                  controller.goToStep(OnboardingStep.otp);
                },
                text: 'SEND OTP',
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}

class PhoneInputField extends StatelessWidget {
  final String countryCode;
  final TextEditingController controller;
  final String? errorText;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  const PhoneInputField({
    Key? key,
    this.countryCode = '+1',
    required this.controller,
    this.errorText,
    this.onChanged,
    this.focusNode,
  }) : super(key: key);

  String _formatNumber(String input) {
    // Remove all non-digit characters
    final digits = input.replaceAll(RegExp(r'\D'), '');
    String formatted = '';
    if (digits.length >= 1) {
      formatted += '(';
      formatted += digits.substring(0, digits.length >= 3 ? 3 : digits.length);
    }
    if (digits.length >= 4) {
      formatted += ')';
      formatted += '-';
      formatted += digits.substring(3, digits.length >= 6 ? 6 : digits.length);
    }
    if (digits.length >= 7) {
      formatted += ' ';
      formatted += digits.substring(
        6,
        digits.length >= 10 ? 10 : digits.length,
      );
    }
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(40),
        // boxShadow: [
        //   BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        // ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Row(
        children: [
          Text(
            countryCode,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: TextStyle(
                fontSize: 24,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '(000)-000 0000',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
                isCollapsed: true,
                errorText: errorText,
              ),
              onChanged: (value) {
                // Optionally format as user types
                if (onChanged != null) onChanged!(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
