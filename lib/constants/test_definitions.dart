import 'package:ausa/common/model/test.dart';

class TestDefinitions {
  /// Central registry of all available tests in the app.
  static final Map<TestType, Test> allTests = {
    // -------------------- BLOOD PRESSURE -------------------------------------------------------
    TestType.bloodPressure: Test(
      type: TestType.bloodPressure,
      group: 'Blood Pressure',
      name: 'Blood Pressure',
      description: 'Measure systolic and diastolic blood pressure',
      image: 'assets/products/bp.png',
      prerequisites: [
        'Connect the cuff properly to the monitor.',
        'Sit comfortably with your back supported and feet flat on the floor.',
      ],
      arUsage: ARUsageType.instructionsOnly,
      startBehavior: TestStartBehavior.manual,
      estimatedDurationSeconds: 60,
      order: 1,
      instruction: 'Place your arm in the cuff and remain still.',
      instructions: [
        TestInstruction(
          stepNumber: 1,
          title: 'Preparation',
          content:
              'Sit comfortably with your back supported and feet flat on the floor.',
          image: 'assets/products/bp.png',
        ),
        TestInstruction(
          stepNumber: 2,
          title: 'Positioning',
          content: 'Place your arm in the cuff at heart level.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 3,
          title: 'Measurement',
          content: 'Remain still and quiet during the measurement.',
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    // -------------------- BLOOD OXYGEN ---------------------------------------------------------
    TestType.bloodOxygen: Test(
      type: TestType.bloodOxygen,
      group: 'Blood Oxygen',
      name: 'Blood Oxygen',
      description: 'Measure blood oxygen saturation and pulse rate',
      image: 'assets/products/51.png',
      prerequisites: ['Ensure your finger is clean and warm.'],
      arUsage: ARUsageType.none,
      startBehavior: TestStartBehavior.autoOnSensorDetection,
      estimatedDurationSeconds: 30,
      order: 2,
      instruction: 'Place your finger in the sensor and remain still.',
      instructions: [
        TestInstruction(
          stepNumber: 1,
          title: 'Preparation',
          content: 'Remove any nail polish and warm your hands.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 2,
          title: 'Positioning',
          content: 'Place your finger completely in the sensor.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 3,
          title: 'Measurement',
          content: 'Keep your finger still until the reading is complete.',
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    // -------------------- BLOOD GLUCOSE (FASTING) ---------------------------------------------
    TestType.bloodGlucoseFasting: Test(
      type: TestType.bloodGlucoseFasting,
      group: 'Blood Glucose',
      name: 'Blood Glucose – Fasting',
      description: 'Measure fasting blood glucose levels',
      image: 'assets/products/51.png',
      arUsage: ARUsageType.none,
      startBehavior: TestStartBehavior.autoOnSensorDetection,
      estimatedDurationSeconds: 45,
      order: 3,
      instruction: 'Insert test strip and apply blood sample.',
      instructions: [
        TestInstruction(
          stepNumber: 1,
          title: 'Preparation',
          content: 'Wash your hands thoroughly with soap and water.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 2,
          title: 'Test Strip',
          content: 'Insert a test strip into the meter.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 3,
          title: 'Blood Sample',
          content: 'Prick your finger and apply blood to the test strip.',
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    // -------------------- BLOOD GLUCOSE (POST MEAL) -------------------------------------------
    TestType.bloodGlucosePostMeal: Test(
      type: TestType.bloodGlucosePostMeal,
      group: 'Blood Glucose',
      name: 'Blood Glucose – Post-Meal',
      description: 'Measure blood glucose 2 hours after eating',
      image: 'assets/products/51.png',
      arUsage: ARUsageType.none,
      startBehavior: TestStartBehavior.autoOnSensorDetection,
      estimatedDurationSeconds: 45,
      order: 4,
      instruction: 'Insert test strip and apply blood sample.',
      instructions: [
        TestInstruction(
          stepNumber: 1,
          title: 'Preparation',
          content: 'Wash your hands thoroughly with soap and water.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 2,
          title: 'Test Strip',
          content: 'Insert a test strip into the meter.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 3,
          title: 'Blood Sample',
          content: 'Prick your finger and apply blood to the test strip.',
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    // -------------------- BODY TEMPERATURE ----------------------------------------------------
    TestType.bodyTemperature: Test(
      type: TestType.bodyTemperature,
      group: 'Body Temperature',
      name: 'Body Temperature',
      description: 'Measure core body temperature',
      image: 'assets/products/51.png',
      arUsage: ARUsageType.duringTestOnly,
      startBehavior: TestStartBehavior.manual,
      estimatedDurationSeconds: 15,
      order: 5,
      instruction: 'Insert thermometer and wait for reading.',
      instructions: [
        TestInstruction(
          stepNumber: 1,
          title: 'Preparation',
          content: 'Ensure the thermometer is clean and ready.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 2,
          title: 'Positioning',
          content: 'Place the thermometer in your ear or under your tongue.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 3,
          title: 'Reading',
          content: 'Wait for the beep and read the temperature.',
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    // -------------------- ECG 2-LEAD ----------------------------------------------------------
    TestType.ecg2Lead: Test(
      type: TestType.ecg2Lead,
      group: 'ECG',
      name: 'ECG – 2-Lead',
      description: 'Record electrical activity of the heart (2-lead)',
      image: 'assets/products/ecg.png',
      arUsage: ARUsageType.none,
      startBehavior: TestStartBehavior.manual,
      estimatedDurationSeconds: 60,
      order: 6,
      instruction: 'Place electrodes on your chest and remain still.',
      instructions: [
        TestInstruction(
          stepNumber: 1,
          title: 'Preparation',
          content: 'Remove any metal objects from your chest area.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 2,
          title: 'Electrodes',
          content: 'Attach electrodes to your chest as instructed.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 3,
          title: 'Recording',
          content: 'Lie still and breathe normally during recording.',
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    // -------------------- ECG 6-LEAD (AR) -----------------------------------------------------
    TestType.ecg6Lead: Test(
      type: TestType.ecg6Lead,
      group: 'ECG',
      name: 'ECG – 6-Lead',
      description: 'Record electrical activity of the heart (6-lead)',
      image: 'assets/products/ecg.png',
      arUsage: ARUsageType.both,
      startBehavior: TestStartBehavior.manual,
      estimatedDurationSeconds: 120,
      order: 7,
      instruction: 'Place electrodes on your chest and remain still.',
      instructions: [
        TestInstruction(
          stepNumber: 1,
          title: 'Preparation',
          content: 'Remove any metal objects from your chest area.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 2,
          title: 'Electrodes',
          content: 'Attach electrodes to your chest as instructed.',
          image: 'assets/images/test_ins.png',
        ),
        TestInstruction(
          stepNumber: 3,
          title: 'Recording',
          content: 'Lie still and breathe normally during recording.',
          image: 'assets/images/test_ins.png',
        ),
      ],
    ),

    // -------------------- BODY SOUNDS ---------------------------------------------------------
    TestType.bodySoundHeart: Test(
      type: TestType.bodySoundHeart,
      group: 'Body Sounds',
      name: 'Heart Sounds',
      description: 'Listen to heart sounds',
      image: 'assets/products/51.png',
      arUsage: ARUsageType.both,
      startBehavior: TestStartBehavior.manual,
      estimatedDurationSeconds: 60,
      order: 8,
      instruction: 'Place stethoscope on your body and breathe normally.',
      instructions: _bodySoundInstructions,
    ),
    TestType.bodySoundLungs: Test(
      type: TestType.bodySoundLungs,
      group: 'Body Sounds',
      name: 'Lung Sounds',
      description: 'Listen to lung sounds',
      image: 'assets/products/51.png',
      arUsage: ARUsageType.both,
      startBehavior: TestStartBehavior.manual,
      estimatedDurationSeconds: 90,
      order: 9,
      instruction: 'Place stethoscope on your body and breathe normally.',
      instructions: _bodySoundInstructions,
    ),
    TestType.bodySoundStomach: Test(
      type: TestType.bodySoundStomach,
      group: 'Body Sounds',
      name: 'Stomach Sounds',
      description: 'Listen to stomach sounds',
      image: 'assets/products/51.png',
      arUsage: ARUsageType.both,
      startBehavior: TestStartBehavior.manual,
      estimatedDurationSeconds: 30,
      order: 10,
      instruction: 'Place stethoscope on your body and breathe normally.',
      instructions: _bodySoundInstructions,
    ),
    TestType.bodySoundBowel: Test(
      type: TestType.bodySoundBowel,
      group: 'Body Sounds',
      name: 'Bowel Sounds',
      description: 'Listen to bowel sounds',
      image: 'assets/products/51.png',
      arUsage: ARUsageType.both,
      startBehavior: TestStartBehavior.manual,
      estimatedDurationSeconds: 60,
      order: 11,
      instruction: 'Place stethoscope on your body and breathe normally.',
      instructions: _bodySoundInstructions,
    ),

    // -------------------- ENT -----------------------------------------------------------------
    TestType.entEar: Test(
      type: TestType.entEar,
      group: 'ENT',
      name: 'Ear Examination',
      description: 'Examine ear canal and eardrum',
      image: 'assets/products/51.png',
      arUsage: ARUsageType.duringTestOnly,
      startBehavior: TestStartBehavior.manual,
      estimatedDurationSeconds: 60,
      order: 12,
      instruction: 'Position the otoscope and follow the examination steps.',
      instructions: _entInstructions,
    ),
    TestType.entNose: Test(
      type: TestType.entNose,
      group: 'ENT',
      name: 'Nose Examination',
      description: 'Examine nasal passages',
      image: 'assets/products/51.png',
      arUsage: ARUsageType.duringTestOnly,
      startBehavior: TestStartBehavior.manual,
      estimatedDurationSeconds: 90,
      order: 13,
      instruction: 'Position the otoscope and follow the examination steps.',
      instructions: _entInstructions,
    ),
    TestType.entThroat: Test(
      type: TestType.entThroat,
      group: 'ENT',
      name: 'Throat Examination',
      description: 'Examine throat and tonsils',
      image: 'assets/products/51.png',
      arUsage: ARUsageType.duringTestOnly,
      startBehavior: TestStartBehavior.manual,
      estimatedDurationSeconds: 90,
      order: 14,
      instruction: 'Position the otoscope and follow the examination steps.',
      instructions: _entInstructions,
    ),
  };

  // --------------------------------------------------------------------------------------------
  /// Generic instruction templates reused by several tests
  static final List<TestInstruction> _bodySoundInstructions = [
    TestInstruction(
      stepNumber: 1,
      title: 'Preparation',
      content: "Ensure you're in a quiet environment.",
      image: 'assets/images/test_ins.png',
    ),
    TestInstruction(
      stepNumber: 2,
      title: 'Positioning',
      content: 'Place the stethoscope on the specified body area.',
      image: 'assets/images/test_ins.png',
    ),
    TestInstruction(
      stepNumber: 3,
      title: 'Listening',
      content: 'Breathe normally and remain still during recording.',
      image: 'assets/images/test_ins.png',
    ),
  ];

  static final List<TestInstruction> _entInstructions = [
    TestInstruction(
      stepNumber: 1,
      title: 'Preparation',
      content: 'Ensure the examination area is well-lit.',
      image: 'assets/images/test_ins.png',
    ),
    TestInstruction(
      stepNumber: 2,
      title: 'Positioning',
      content: 'Position yourself comfortably for examination.',
      image: 'assets/images/test_ins.png',
    ),
    TestInstruction(
      stepNumber: 3,
      title: 'Examination',
      content: "Follow the examiner's instructions during the procedure.",
      image: 'assets/images/test_ins.png',
    ),
  ];

  // --------------------------------------------------------------------------------------------
  static List<Test> get availableTests {
    final list = allTests.values.toList();
    list.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    return list;
  }

  static bool _isLegacyTest(TestType type) {
    return [
      TestType.heartSignal,
      TestType.bloodSaturation,
      TestType.bodyImage,
    ].contains(type);
  }

  static Test? getTestByType(TestType type) => allTests[type];

  static int getEstimatedDuration(TestType type, {String? category}) {
    // category is kept for backward-compatibility only and is currently ignored because
    // duration is embedded directly in the Test object. In the future, sub-type-specific
    // durations can be looked up here using the selectedSubTypeIds.
    return allTests[type]?.estimatedDurationSeconds ?? 60;
  }

  static List<Test> testsForGroup(String groupId) {
    final grp =
        allTests.values.where((t) => _slug(t.group) == groupId).toList();
    // filter out variant types that are excluded from selection list but still present in map
    return grp;
  }

  static String _slug(String text) => text.toLowerCase().replaceAll(' ', '_');
}
