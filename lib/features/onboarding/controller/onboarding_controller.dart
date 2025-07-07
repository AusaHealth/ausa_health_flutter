import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Enum representing each onboarding step.
enum OnboardingStep { language, wifi, phone, otp, terms }

/// Controller to manage onboarding state and navigation.
class OnboardingController extends GetxController {
  var currentStep = OnboardingStep.language.obs;
  var completedSteps = <OnboardingStep>{}.obs;

  final phoneController = TextEditingController().obs;

  // OTP Verification properties
  final otpController = TextEditingController();
  final otpFocusNode = FocusNode();
  var obscureOtp = false.obs;
  var otpSeconds = 59.obs;

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
}
