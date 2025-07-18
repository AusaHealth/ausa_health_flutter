import 'package:ausa/common/model/test.dart';

class TestPrerequisiteCheck {
  final TestType testType;
  final String testName;
  final String imagePath;
  final String title;
  final String question;
  final String description;
  final String primaryButtonText;
  final String secondaryButtonText;
  final bool
  primaryButtonMeansCanProceed; // true if primary button means proceed, false if secondary

  TestPrerequisiteCheck({
    required this.testType,
    required this.testName,
    required this.imagePath,
    required this.title,
    required this.question,
    required this.description,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.primaryButtonMeansCanProceed,
  });
}

// Factory for creating test-specific prerequisite checks
class TestPrerequisitesFactory {
  static TestPrerequisiteCheck? getPrerequisiteCheckForTest(TestType testType) {
    switch (testType) {
      case TestType.bloodGlucose:
        return TestPrerequisiteCheck(
          testType: TestType.bloodGlucose,
          testName: 'Blood Glucose',
          imagePath: 'assets/images/dialog/bg.png',
          title: 'Blood Glucose',
          question:
              'Have you had anything to eat or drink (other than water) in the past few hours?',
          description:
              'It helps us get the most accurate results for your Blood Glucose test.',
          primaryButtonText: 'Yes',
          secondaryButtonText: 'No',
          primaryButtonMeansCanProceed: false, // If they ate, they should wait
        );

      case TestType.bloodOxygen:
        return TestPrerequisiteCheck(
          testType: TestType.bloodOxygen,
          testName: 'Blood Oxygen',
          imagePath: 'assets/images/dialog/bo_pre.png',
          title: 'Blood Oxygen',
          question:
              'Make sure that you don\'t have dark nail polish on the finger being tested.',
          description:
              'It helps us get the most accurate results for your Blood Oxygen test.',
          primaryButtonText: 'Okay',
          secondaryButtonText: 'Take later',
          primaryButtonMeansCanProceed: true, // Okay means proceed
        );

      case TestType.bloodPressure:
        return TestPrerequisiteCheck(
          testType: TestType.bloodPressure,
          testName: 'Blood Pressure',
          imagePath: 'assets/images/dialog/bp_pre.png',
          title: 'Blood Pressure',
          question:
              'Have you had caffeine, nicotine, or exercised in the past 30 minutes?',
          description:
              'Please wait 30 minutes after any of these for the most accurate results.',
          primaryButtonText: 'No, proceed',
          secondaryButtonText: 'Remind later',
          primaryButtonMeansCanProceed:
              true, // "No, proceed" means they can proceed
        );

      default:
        return null; // No prerequisite check for other tests
    }
  }

  static bool testHasPrerequisiteCheck(TestType testType) {
    return getPrerequisiteCheckForTest(testType) != null;
  }
}
