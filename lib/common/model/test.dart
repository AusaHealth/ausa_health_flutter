/// Enums -----------------------------------------------------------------------------------------

/// More granular control of when / how Augmented-Reality assets are shown
enum ARUsageType { none, instructionsOnly, duringTestOnly, both }

/// Determines how the user proceeds from the READY state into the RUNNING state of a test
enum TestStartBehavior {
  manual, // User manually presses a button
  autoOnSensorDetection, // Hardware triggers start as soon as a signal is detected
  autoAfterInstructions, // Starts automatically after the last instruction step is completed
}

/// Defines if (and how) the user must choose between multiple sub-tests
enum TestSelectionType {
  none,
  single, // User must pick exactly one
  multiple, // User may pick one or more
}

/// High-level / canonical identifiers for every test we support
/// KEEP THIS LIST ALPHABETICALLY SORTED FOR EASY DIFFING
enum TestType {
  bloodPressure,
  bloodOxygen,
  bloodGlucoseFasting,
  bloodGlucosePostMeal,
  bodyTemperature,
  ecg2Lead,
  ecg6Lead,
  bodySoundHeart,
  bodySoundLungs,
  bodySoundStomach,
  bodySoundBowel,
  entEar,
  entNose,
  entThroat,
  // Legacy interim values
  ecg,
  bloodGlucose,
  bodySound,
  ent,
  heartSignal,
  bloodSaturation,
  bodyImage,
}

/// ----------------------------------------------------------------------------------------------
/// Core data classes -----------------------------------------------------------------------------

class TestInstruction {
  final String title;
  final String content;
  final String image;
  final bool isCompleted;
  final int stepNumber;

  const TestInstruction({
    required this.title,
    required this.content,
    required this.image,
    this.isCompleted = false,
    required this.stepNumber,
  });

  TestInstruction copyWith({
    String? title,
    String? content,
    String? image,
    bool? isCompleted,
    int? stepNumber,
  }) {
    return TestInstruction(
      title: title ?? this.title,
      content: content ?? this.content,
      image: image ?? this.image,
      isCompleted: isCompleted ?? this.isCompleted,
      stepNumber: stepNumber ?? this.stepNumber,
    );
  }
}

/// An optional sub-variant of a test (e.g. "6-Lead" ECG)
class TestSubType {
  final String id;
  final String name;
  final String description;
  final String? icon;
  final Map<String, dynamic>? metadata;

  const TestSubType({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    this.metadata,
  });

  TestSubType copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    Map<String, dynamic>? metadata,
  }) {
    return TestSubType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      metadata: metadata ?? this.metadata,
    );
  }
}

class Test {
  // Identity ------------------------------------------------------------------------------------
  final TestType type;
  final String group; // e.g. "Blood Glucose", "ECG", "Body Sounds", "ENT"

  // Presentation --------------------------------------------------------------------------------
  final String name;
  final String description;
  final String image;

  // Execution Details ---------------------------------------------------------------------------
  final List<String>
  prerequisites; // Text blocks shown before the test can start
  final ARUsageType arUsage;
  final TestStartBehavior startBehavior;

  // Instructions --------------------------------------------------------------------------------
  final List<TestInstruction> instructions;
  final String? instruction;

  // Sub-variants --------------------------------------------------------------------------------
  final List<TestSubType>? subTypes; // null or empty => no selection required
  final TestSelectionType selectionType;
  final List<String>
  selectedSubTypeIds; // Keeps track of chosen variants (empty if none)

  // Runtime -------------------------------------------------------------------------------------
  String? result;
  bool isDone;
  bool isSelected; // Whether user picked this test in the selection grid
  final bool
  isGroupPlaceholder; // true for placeholder items that will be replaced by concrete tests later

  // Misc ----------------------------------------------------------------------------------------
  final int? estimatedDurationSeconds;
  final int? order;

  // ---------------------------------------------------------------------------------------------
  Test({
    // Required
    required this.type,
    required this.group,
    required this.name,
    required this.description,
    required this.image,

    // Optional but strongly recommended
    this.prerequisites = const [],
    this.arUsage = ARUsageType.none,
    this.startBehavior = TestStartBehavior.manual,

    this.instructions = const [],
    this.instruction,

    this.subTypes,
    this.selectionType = TestSelectionType.none,
    this.selectedSubTypeIds = const [],

    this.result,
    this.isDone = false,
    this.isSelected = false,
    this.isGroupPlaceholder = false,

    this.estimatedDurationSeconds,
    this.order,
  });

  // Convenience ---------------------------------------------------------------------------------
  bool get hasPrerequisites => prerequisites.isNotEmpty;
  bool get hasSubTypes => subTypes != null && subTypes!.isNotEmpty;
  bool get isMultiSelect => selectionType == TestSelectionType.multiple;

  // Copy helper ---------------------------------------------------------------------------------
  Test copyWith({
    TestType? type,
    String? group,
    String? name,
    String? description,
    String? image,
    List<String>? prerequisites,
    ARUsageType? arUsage,
    TestStartBehavior? startBehavior,
    List<TestInstruction>? instructions,
    List<TestSubType>? subTypes,
    TestSelectionType? selectionType,
    List<String>? selectedSubTypeIds,
    String? result,
    bool? isDone,
    bool? isSelected,
    bool? isGroupPlaceholder,
    int? estimatedDurationSeconds,
    int? order,
    String? instruction,
  }) {
    return Test(
      type: type ?? this.type,
      group: group ?? this.group,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      prerequisites: prerequisites ?? List<String>.from(this.prerequisites),
      arUsage: arUsage ?? this.arUsage,
      startBehavior: startBehavior ?? this.startBehavior,
      instructions:
          instructions ?? List<TestInstruction>.from(this.instructions),
      subTypes: subTypes ?? this.subTypes,
      selectionType: selectionType ?? this.selectionType,
      selectedSubTypeIds:
          selectedSubTypeIds ?? List<String>.from(this.selectedSubTypeIds),
      result: result ?? this.result,
      isDone: isDone ?? this.isDone,
      isSelected: isSelected ?? this.isSelected,
      isGroupPlaceholder: isGroupPlaceholder ?? this.isGroupPlaceholder,
      estimatedDurationSeconds:
          estimatedDurationSeconds ?? this.estimatedDurationSeconds,
      order: order ?? this.order,
      instruction: instruction ?? this.instruction,
    );
  }

  // Convenience helper to fetch first selected sub-type (or null)
  String? get firstSelectedSubTypeId =>
      selectedSubTypeIds.isNotEmpty ? selectedSubTypeIds.first : null;
}
