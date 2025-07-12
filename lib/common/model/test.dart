class Test {
  final TestType type;
  final String name;
  final String description;
  final String image;
  final String? result;
  bool isDone;
  final TestInstructionType instructionType;
  final String? videoInstructionSourcePath;
  final String? instruction;
  final List<TestInstruction>? instructions;
  final List<TestCategory>? categories;
  final int? estimatedDurationSeconds;
  final bool hasPrerequisites;
  final bool usesAR;
  final String? selectedCategory;
  final bool isSelected;
  final int? order;

  Test({
    required this.type,
    required this.name,
    required this.description,
    required this.image,
    this.result,
    this.isDone = false,
    this.instructionType = TestInstructionType.video,
    this.videoInstructionSourcePath,
    this.instruction,
    this.instructions,
    this.categories,
    this.estimatedDurationSeconds,
    this.hasPrerequisites = false,
    this.usesAR = false,
    this.selectedCategory,
    this.isSelected = false,
    this.order,
  });

  Test copyWith({
    TestType? type,
    String? name,
    String? description,
    String? image,
    String? result,
    bool? isDone,
    TestInstructionType? instructionType,
    String? videoInstructionSourcePath,
    String? instruction,
    List<TestInstruction>? instructions,
    List<TestCategory>? categories,
    int? estimatedDurationSeconds,
    bool? hasPrerequisites,
    bool? usesAR,
    String? selectedCategory,
    bool? isSelected,
    int? order,
  }) {
    return Test(
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      result: result ?? this.result,
      isDone: isDone ?? this.isDone,
      instructionType: instructionType ?? this.instructionType,
      videoInstructionSourcePath:
          videoInstructionSourcePath ?? this.videoInstructionSourcePath,
      instruction: instruction ?? this.instruction,
      instructions: instructions ?? this.instructions,
      categories: categories ?? this.categories,
      estimatedDurationSeconds:
          estimatedDurationSeconds ?? this.estimatedDurationSeconds,
      hasPrerequisites: hasPrerequisites ?? this.hasPrerequisites,
      usesAR: usesAR ?? this.usesAR,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isSelected: isSelected ?? this.isSelected,
      order: order ?? this.order,
    );
  }

  bool get hasCategories => categories != null && categories!.isNotEmpty;
}

class TestInstruction {
  final String title;
  final String content;
  final String image;

  TestInstruction({
    required this.title,
    required this.content,
    required this.image,
  });
}

class TestCategory {
  final String id;
  final String name;
  final String description;
  final String? icon;
  final Map<String, dynamic>? metadata;

  TestCategory({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    this.metadata,
  });

  TestCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    Map<String, dynamic>? metadata,
  }) {
    return TestCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum TestInstructionType { video, text }

enum TestType {
  bloodPressure,
  bloodOxygen,
  bloodGlucose,
  bodyTemperature,
  ecg,
  bodySound,
  ent,
  // Legacy types for backward compatibility
  heartSignal,
  bloodSaturation,
  bodyImage,
}
