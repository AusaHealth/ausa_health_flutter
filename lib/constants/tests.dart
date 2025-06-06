import 'package:ausa/common/model/test.dart';

Map<TestType, Test> tests = {
  TestType.bloodPressure: Test(type: TestType.bloodPressure, name: 'Blood Pressure', description: 'Blood Pressure', image: 'assets/images/test_ins.png', instruction: "Place your finger at the indicated spot.", instructionType: TestInstructionType.text, instructions: [TestInstruction(title: 'Blood Pressure', content: "Place your finger at the indicated spot.", image: 'assets/images/test_ins.png')]),
  TestType.heartSignal: Test(type: TestType.heartSignal, name: 'Heart Signal', description: 'Heart Signal', image: 'assets/images/test_ins.png', instruction: "Place your finger at the indicated spot.", instructionType: TestInstructionType.text, instructions: [TestInstruction(title: 'Heart Signal', content: "Place your finger at the indicated spot.", image: 'assets/images/test_ins.png')]),
  TestType.bloodSaturation: Test(type: TestType.bloodSaturation, name: 'Blood Saturation', description: 'Blood Saturation', image: 'assets/images/test_image.png'),
  TestType.bodyTemperature: Test(type: TestType.bodyTemperature, name: 'Body Temperature', description: 'Body Temperature', image: 'assets/images/test_image.png'),
  TestType.bodyImage: Test(type: TestType.bodyImage, name: 'Body Image', description: 'Body Image', image: 'assets/images/test_image.png'),
  TestType.bodySound: Test(type: TestType.bodySound, name: 'Body Sound', description: 'Body Sound', image: 'assets/images/test_image.png'),
  TestType.bloodGlucose: Test(type: TestType.bloodGlucose, name: 'Blood Glucose', description: 'Blood Glucose', image: 'assets/images/test_image.png'),
};

