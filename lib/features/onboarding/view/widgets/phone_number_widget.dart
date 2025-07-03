import 'package:ausa/common/widget/custom_text_field.dart';
import 'package:ausa/features/onboarding/controller/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:ausa/common/widget/phone_input_field.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class PhoneNumberWidget extends StatefulWidget {
  const PhoneNumberWidget({super.key});

  @override
  State<PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final phoneFocus = FocusNode();
    String phoneError = '';

    final controller = Get.find<OnboardingController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        const Text(
          'Phone Number',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your phone number is required for verification',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 140,
          width: 500,
          child: PhoneInputField(
            controller: phoneController,
            focusNode: phoneFocus,
            errorText: phoneError.isNotEmpty ? phoneError : null,
            onChanged: (value) {
              if (value.isEmpty) {
                phoneError = 'Phone number is required';
              } else if (value.length != 10) {
                phoneError = 'Phone number must be 10 digits';
              } else {
                phoneError = '';
              }
            },
          ),
        ),
        SizedBox(height: 20),
        Expanded(child: SizedBox()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  // controller.completeStep(OnboardingStep.phone);
                  controller.goToStep(OnboardingStep.otp);
                },
                child: Text('SEND OTP'),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}
