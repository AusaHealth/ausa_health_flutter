import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Enum representing each onboarding step.
enum OnboardingStep { language, wifi, phone, otp, personalDetails, terms }

/// Controller to manage onboarding state and navigation.
class OnboardingController extends GetxController {
  var currentStep = OnboardingStep.language.obs;
  var completedSteps = <OnboardingStep>{}.obs;

  final TextEditingController phoneController = TextEditingController();

  RxString phoneNumber = ''.obs;

  // OTP Verification properties
  final otpController = TextEditingController();

  final otpFocusNode = FocusNode();
  var obscureOtp = false.obs;
  var otpSeconds = 59.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to controller changes and update reactive variable
    phoneController.addListener(() {
      phoneNumber.value = phoneController.value.text;
    });
  }

  void updatePhoneNumber(String number) {
    phoneController.text = number;
    phoneNumber.value = number; // This will trigger Obx
  }

  /// Mark a step as completed.
  void completeStep(OnboardingStep step) {
    completedSteps.add(step);
  }

  /// Go to a specific step.
  void goToStep(OnboardingStep step) {
    currentStep.value = step;
  }

  /// Advance to the next step and mark the current as completed.
  void nextStep() {
    int nextIndex = OnboardingStep.values.indexOf(currentStep.value) + 1;
    if (nextIndex < OnboardingStep.values.length) {
      completedSteps.add(currentStep.value);
      currentStep.value = OnboardingStep.values[nextIndex];
    }
  }

  /// Reset onboarding progress.
  void reset() {
    currentStep.value = OnboardingStep.language;
    completedSteps.clear();
  }

  void completeAndGoToNextStep() {
    completeStep(currentStep.value);
    nextStep();
  }

  // OTP Verification methods
  void startOtpTimer() {
    otpSeconds.value = 59;
    Future.doWhile(() async {
      if (otpSeconds.value == 0) return false;
      await Future.delayed(const Duration(seconds: 1));
      if (otpSeconds.value > 0) otpSeconds.value--;
      return otpSeconds.value > 0;
    });
  }

  void toggleOtpVisibility() {
    obscureOtp.value = !obscureOtp.value;
  }

  void handleOtpInputChange(String value) {
    // Pinput handles focus automatically
    log('otpValue: $value');
  }

  String get otpValue => otpController.text;

  bool get isOtpValid => otpValue.length == 6;

  void clearOtp() {
    otpController.clear();
  }

  @override
  void onClose() {
    // Dispose OTP controller and focus node
    otpController.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }

  // personal Details controller

  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final nickNameController = TextEditingController().obs;
  final emailIdController = TextEditingController().obs;
  final birthDateController = TextEditingController().obs;
  final ageController = TextEditingController().obs;
  final heightController = TextEditingController().obs;
  final weightController = TextEditingController().obs;
  final genderController = TextEditingController().obs;

  // void setupKeyboardListeners(void Function() onFocusChange) {
  //   shortNameFocus.addListener(() => _handleFocusChange(onFocusChange));
  //   fullNameFocus.addListener(() => _handleFocusChange(onFocusChange));
  //   relationshipFocus.addListener(() => _handleFocusChange(onFocusChange));
  //   phoneFocus.addListener(() => _handleFocusChange(onFocusChange));
  //   emailFocus.addListener(() => _handleFocusChange(onFocusChange));
  //   addressFocus.addListener(() => _handleFocusChange(onFocusChange));
  // }

  // // Call this in dispose of EditContactPage
  // void removeKeyboardListeners(void Function() onFocusChange) {
  //   shortNameFocus.removeListener(() => _handleFocusChange(onFocusChange));
  //   fullNameFocus.removeListener(() => _handleFocusChange(onFocusChange));
  //   relationshipFocus.removeListener(() => _handleFocusChange(onFocusChange));
  //   phoneFocus.removeListener(() => _handleFocusChange(onFocusChange));
  //   emailFocus.removeListener(() => _handleFocusChange(onFocusChange));
  //   addressFocus.removeListener(() => _handleFocusChange(onFocusChange));
  // }

  // void _handleFocusChange(void Function() onFocusChange) {
  //   if (shortNameFocus.hasFocus) {
  //     keyboardType.value = VirtualKeyboardType.Alphanumeric;
  //     _lastFocusedField = 'shortName';
  //   } else if (emailFocus.hasFocus) {
  //     keyboardType.value = VirtualKeyboardType.Alphanumeric;
  //     _lastFocusedField = 'email';
  //   } else if (addressFocus.hasFocus) {
  //     keyboardType.value = VirtualKeyboardType.Alphanumeric;
  //     _lastFocusedField = 'address';
  //   } else if (fullNameFocus.hasFocus) {
  //     keyboardType.value = VirtualKeyboardType.Alphanumeric;
  //     _lastFocusedField = 'fullName';
  //   }
  //   if (relationshipFocus.hasFocus) {
  //     keyboardType.value = VirtualKeyboardType.Alphanumeric;
  //     _lastFocusedField = 'relationship';
  //   }
  //   if (phoneFocus.hasFocus) {
  //     keyboardType.value = VirtualKeyboardType.Numeric;
  //     _lastFocusedField = 'phone';
  //   }

  //   onFocusChange();
  // }

  // TextEditingController get currentController {
  //   switch (_lastFocusedField) {
  //     case 'shortName':
  //       return shortNameController;
  //     case 'fullName':
  //       return fullNameController;
  //     case 'relationship':
  //       return relationshipController;
  //     case 'phone':
  //       return phoneController;
  //     case 'email':
  //       return emailController;
  //     case 'address':
  //       return addressController;
  //     default:
  //       return addressController;
  //   }
  // }

  // // Get the current keyboard type (reactive)
  // VirtualKeyboardType get currentKeyboardType => keyboardType.value;
}
