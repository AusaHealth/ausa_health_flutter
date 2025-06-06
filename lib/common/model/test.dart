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


  Test({required this.type, required this.name, required this.description, required this.image, this.result, this.isDone = false, this.instructionType = TestInstructionType.video, this.videoInstructionSourcePath, this.instruction, this.instructions});
}

class TestInstruction {
  final String title;
  final String content;
  final String image;

  TestInstruction({required this.title, required this.content, required this.image});
}

enum TestInstructionType {
  video,
  text,
}

enum TestType {
  bloodPressure,
  heartSignal,
  bloodSaturation,
  bodyTemperature,
  bodyImage,
  bloodGlucose,
  bodySound,
}
