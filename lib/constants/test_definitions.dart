import 'package:ausa/common/model/test.dart';

class TestDefinitions {
  static final Map<TestType, Test> allTests = {
    TestType.bloodPressure: Test(
      type: TestType.bloodPressure,
      name: 'Blood Pressure',
      description: 'Measure systolic and diastolic blood pressure',
      image: 'assets/products/bp.png',
      instruction: "Place your arm in the cuff and remain still.",
      instructionType: TestInstructionType.text,
      hasPrerequisites: true,
      usesAR: true,
      estimatedDurationSeconds: 60,
      order: 1,
      instructions: [
        TestInstruction(
          title: 'Preparation',
          content:
              "Sit comfortably with your back supported and feet flat on the floor.",
          image: 'assets/products/bp.png',
        ),
        TestInstruction(
          title: 'Positioning',
          content: "Place your arm in the cuff at heart level.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Measurement',
          content: "Remain still and quiet during the measurement.",
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    TestType.bloodOxygen: Test(
      type: TestType.bloodOxygen,
      name: 'Blood Oxygen',
      description: 'Measure blood oxygen saturation and pulse rate',
      image: 'assets/products/51.png',
      instruction: "Place your finger in the sensor and remain still.",
      instructionType: TestInstructionType.text,
      hasPrerequisites: true,
      estimatedDurationSeconds: 30,
      order: 2,
      instructions: [
        TestInstruction(
          title: 'Preparation',
          content: "Remove any nail polish and warm your hands.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Positioning',
          content: "Place your finger completely in the sensor.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Measurement',
          content: "Keep your finger still until the reading is complete.",
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    TestType.bloodGlucose: Test(
      type: TestType.bloodGlucose,
      name: 'Blood Glucose',
      description: 'Measure blood glucose levels',
      image: 'assets/products/51.png',
      instruction: "Insert test strip and apply blood sample.",
      instructionType: TestInstructionType.text,
      hasPrerequisites: false,
      estimatedDurationSeconds: 45,
      order: 3,
      categories: [
        TestCategory(
          id: 'fasting',
          name: 'Fasting',
          description: 'Test after fasting for 8+ hours',
          icon: '🌅',
          metadata: {'fastingHours': 8},
        ),
        TestCategory(
          id: 'post_meal',
          name: 'Post Meal',
          description: 'Test 2 hours after eating',
          icon: '🍽️',
          metadata: {'postMealHours': 2},
        ),
      ],
      instructions: [
        TestInstruction(
          title: 'Preparation',
          content: "Wash your hands thoroughly with soap and water.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Test Strip',
          content: "Insert a test strip into the meter.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Blood Sample',
          content: "Prick your finger and apply blood to the test strip.",
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    TestType.bodyTemperature: Test(
      type: TestType.bodyTemperature,
      name: 'Body Temperature',
      description: 'Measure core body temperature',
      image: 'assets/products/51.png',
      instruction: "Insert thermometer and wait for reading.",
      instructionType: TestInstructionType.text,
      hasPrerequisites: false,
      estimatedDurationSeconds: 15,
      order: 4,
      instructions: [
        TestInstruction(
          title: 'Preparation',
          content: "Ensure the thermometer is clean and ready.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Positioning',
          content: "Place the thermometer in your ear or under your tongue.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Reading',
          content: "Wait for the beep and read the temperature.",
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    TestType.ecg: Test(
      type: TestType.ecg,
      name: 'ECG',
      description: 'Record electrical activity of the heart',
      image: 'assets/products/ecg.png',
      instruction: "Place electrodes on your chest and remain still.",
      instructionType: TestInstructionType.text,
      hasPrerequisites: false,
      usesAR: false,
      estimatedDurationSeconds: 120,
      order: 5,
      categories: [
        TestCategory(
          id: '6_lead',
          name: '6-Lead',
          description: 'Standard 6-lead ECG recording',
          icon: '💓',
          metadata: {'leads': 6, 'duration': 60, 'usesAR': false},
        ),
        TestCategory(
          id: '12_lead',
          name: '12-Lead',
          description: 'Comprehensive 12-lead ECG recording',
          icon: '❤️',
          metadata: {'leads': 12, 'duration': 120, 'usesAR': true},
        ),
      ],
      instructions: [
        TestInstruction(
          title: 'Preparation',
          content: "Remove any metal objects from your chest area.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Electrodes',
          content: "Attach electrodes to your chest as instructed.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Recording',
          content: "Lie still and breathe normally during recording.",
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    TestType.bodySound: Test(
      type: TestType.bodySound,
      name: 'Body Sounds',
      description: 'Listen to heart, lung, and other body sounds',
      image: 'assets/products/51.png',
      instruction: "Place stethoscope on your body and breathe normally.",
      instructionType: TestInstructionType.text,
      hasPrerequisites: false,
      estimatedDurationSeconds: 180,
      order: 6,
      categories: [
        TestCategory(
          id: 'heart',
          name: 'Heart',
          description: 'Listen to heart sounds',
          icon: '💗',
          metadata: {
            'positions': ['apex', 'base'],
            'duration': 60,
          },
        ),
        TestCategory(
          id: 'lungs',
          name: 'Lungs',
          description: 'Listen to lung sounds',
          icon: '🫁',
          metadata: {
            'positions': ['anterior', 'posterior'],
            'duration': 90,
          },
        ),
        TestCategory(
          id: 'stomach',
          name: 'Stomach',
          description: 'Listen to stomach sounds',
          icon: '🫃',
          metadata: {
            'positions': ['abdomen'],
            'duration': 30,
          },
        ),
        TestCategory(
          id: 'bowel',
          name: 'Bowel',
          description: 'Listen to bowel sounds',
          icon: '🫄',
          metadata: {
            'positions': ['lower_abdomen'],
            'duration': 60,
          },
        ),
      ],
      instructions: [
        TestInstruction(
          title: 'Preparation',
          content: "Ensure you're in a quiet environment.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Positioning',
          content: "Place the stethoscope on the specified body area.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Listening',
          content: "Breathe normally and remain still during recording.",
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    TestType.ent: Test(
      type: TestType.ent,
      name: 'ENT',
      description: 'Examine ear, nose, and throat',
      image: 'assets/products/51.png',
      instruction: "Position the otoscope and follow the examination steps.",
      instructionType: TestInstructionType.text,
      hasPrerequisites: false,
      estimatedDurationSeconds: 240,
      order: 7,
      categories: [
        TestCategory(
          id: 'ear',
          name: 'Ear',
          description: 'Examine ear canal and eardrum',
          icon: '👂',
          metadata: {'examination': 'otoscopic', 'duration': 60},
        ),
        TestCategory(
          id: 'nose',
          name: 'Nose',
          description: 'Examine nasal passages',
          icon: '👃',
          metadata: {'examination': 'rhinoscopic', 'duration': 90},
        ),
        TestCategory(
          id: 'throat',
          name: 'Throat',
          description: 'Examine throat and tonsils',
          icon: '👄',
          metadata: {'examination': 'pharyngoscopic', 'duration': 90},
        ),
      ],
      instructions: [
        TestInstruction(
          title: 'Preparation',
          content: "Ensure the examination area is well-lit.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Positioning',
          content: "Position yourself comfortably for examination.",
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          title: 'Examination',
          content: "Follow the examiner's instructions during the procedure.",
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),
  };

  static List<Test> get availableTests =>
      allTests.values.where((test) => !_isLegacyTest(test.type)).toList()
        ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

  static bool _isLegacyTest(TestType type) {
    return [
      TestType.heartSignal,
      TestType.bloodSaturation,
      TestType.bodyImage,
    ].contains(type);
  }

  static Test? getTestByType(TestType type) {
    return allTests[type];
  }

  static List<Test> getTestsByCategory(String category) {
    return allTests.values
        .where(
          (test) => test.categories?.any((cat) => cat.id == category) ?? false,
        )
        .toList();
  }

  static List<TestCategory> getAllCategories() {
    final categories = <TestCategory>[];
    for (final test in allTests.values) {
      if (test.categories != null) {
        categories.addAll(test.categories!);
      }
    }
    return categories;
  }

  static List<TestCategory> getCategoriesForTest(TestType type) {
    final test = allTests[type];
    return test?.categories ?? [];
  }

  static bool testHasCategories(TestType type) {
    final test = allTests[type];
    return test?.hasCategories ?? false;
  }

  static int getEstimatedDuration(TestType type, {String? category}) {
    final test = allTests[type];
    if (test == null) return 60;

    if (category != null && test.categories != null) {
      final testCategory = test.categories!.firstWhere(
        (cat) => cat.id == category,
        orElse: () => test.categories!.first,
      );
      final categoryDuration = testCategory.metadata?['duration'];
      if (categoryDuration is int) {
        return categoryDuration;
      }
    }

    return test.estimatedDurationSeconds ?? 60;
  }
}
