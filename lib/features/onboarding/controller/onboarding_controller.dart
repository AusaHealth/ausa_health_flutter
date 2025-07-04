import 'package:get/get.dart';

/// Enum representing each onboarding step.
enum OnboardingStep { language, wifi, phone, otp, terms }

/// Controller to manage onboarding state and navigation.
class OnboardingController extends GetxController {
  var currentStep = OnboardingStep.language.obs;
  var completedSteps = <OnboardingStep>{}.obs;

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
}
