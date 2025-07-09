import 'package:ausa/common/model/test.dart';

enum TestResultStatus { normal, abnormal, pending, error }

class TestResultParameter {
  final String name;
  final String value;
  final String unit;
  final TestResultStatus status;
  final String? normalRange;
  final bool isAbnormal;

  TestResultParameter({
    required this.name,
    required this.value,
    required this.unit,
    this.status = TestResultStatus.normal,
    this.normalRange,
    this.isAbnormal = false,
  });

  TestResultParameter copyWith({
    String? name,
    String? value,
    String? unit,
    TestResultStatus? status,
    String? normalRange,
    bool? isAbnormal,
  }) {
    return TestResultParameter(
      name: name ?? this.name,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      normalRange: normalRange ?? this.normalRange,
      isAbnormal: isAbnormal ?? this.isAbnormal,
    );
  }
}

class TestResult {
  final String id;
  final TestType testType;
  final String testName;
  final DateTime completedAt;
  final List<TestResultParameter> parameters;
  final TestResultStatus overallStatus;
  final String? notes;
  final String? category;

  TestResult({
    required this.id,
    required this.testType,
    required this.testName,
    required this.completedAt,
    required this.parameters,
    this.overallStatus = TestResultStatus.normal,
    this.notes,
    this.category,
  });

  bool get hasAbnormalValues => parameters.any((p) => p.isAbnormal);

  List<TestResultParameter> get abnormalParameters =>
      parameters.where((p) => p.isAbnormal).toList();

  List<TestResultParameter> get normalParameters =>
      parameters.where((p) => !p.isAbnormal).toList();

  TestResult copyWith({
    String? id,
    TestType? testType,
    String? testName,
    DateTime? completedAt,
    List<TestResultParameter>? parameters,
    TestResultStatus? overallStatus,
    String? notes,
    String? category,
  }) {
    return TestResult(
      id: id ?? this.id,
      testType: testType ?? this.testType,
      testName: testName ?? this.testName,
      completedAt: completedAt ?? this.completedAt,
      parameters: parameters ?? this.parameters,
      overallStatus: overallStatus ?? this.overallStatus,
      notes: notes ?? this.notes,
      category: category ?? this.category,
    );
  }
}

// Factory methods for creating specific test results
class TestResultFactory {
  static TestResult createBloodPressureResult({
    required String id,
    required DateTime completedAt,
    required int systolic,
    required int diastolic,
    required int pulse,
    required int meanArterialPressure,
    String? category,
  }) {
    final parameters = [
      TestResultParameter(
        name: 'BP Systolic',
        value: systolic.toString(),
        unit: 'mmHg',
        isAbnormal: systolic > 140 || systolic < 90,
        normalRange: '90-140',
      ),
      TestResultParameter(
        name: 'BP Diastolic',
        value: diastolic.toString(),
        unit: 'mmHg',
        isAbnormal: diastolic > 90 || diastolic < 60,
        normalRange: '60-90',
      ),
      TestResultParameter(
        name: 'Pulse Pressure',
        value: pulse.toString(),
        unit: 'mmHg',
        isAbnormal: pulse > 60 || pulse < 30,
        normalRange: '30-60',
      ),
      TestResultParameter(
        name: 'Mean Arterial Pressure',
        value: meanArterialPressure.toString(),
        unit: 'mmHg',
        isAbnormal: meanArterialPressure > 105 || meanArterialPressure < 70,
        normalRange: '70-105',
      ),
    ];

    return TestResult(
      id: id,
      testType: TestType.bloodPressure,
      testName: 'Blood Pressure',
      completedAt: completedAt,
      parameters: parameters,
      overallStatus:
          parameters.any((p) => p.isAbnormal)
              ? TestResultStatus.abnormal
              : TestResultStatus.normal,
      category: category,
    );
  }

  static TestResult createBloodGlucoseResult({
    required String id,
    required DateTime completedAt,
    required double glucose,
    required int heartRate,
    required String category,
  }) {
    final bool isFasting = category.toLowerCase() == 'fasting';
    final double normalMin = isFasting ? 70.0 : 70.0;
    final double normalMax = isFasting ? 100.0 : 140.0;

    final parameters = [
      TestResultParameter(
        name: isFasting ? 'Fasting reading' : 'Post-meal reading',
        value: glucose.toString(),
        unit: 'mg/DL',
        isAbnormal: glucose > normalMax || glucose < normalMin,
        normalRange: '${normalMin.toInt()}-${normalMax.toInt()}',
      ),
      TestResultParameter(
        name: 'Heart Rate',
        value: heartRate.toString(),
        unit: 'BPM',
        isAbnormal: heartRate > 100 || heartRate < 60,
        normalRange: '60-100',
      ),
    ];

    return TestResult(
      id: id,
      testType: TestType.bloodGlucose,
      testName: 'Blood Glucose',
      completedAt: completedAt,
      parameters: parameters,
      overallStatus:
          parameters.any((p) => p.isAbnormal)
              ? TestResultStatus.abnormal
              : TestResultStatus.normal,
      category: category,
    );
  }

  static TestResult createBloodOxygenResult({
    required String id,
    required DateTime completedAt,
    required int oxygenSaturation,
    required int pulseRate,
    required int pulsePressure,
    required int meanArterialPressure,
    String? category,
  }) {
    final parameters = [
      TestResultParameter(
        name: 'O2 Saturation',
        value: oxygenSaturation.toString(),
        unit: '%',
        isAbnormal: oxygenSaturation < 95,
        normalRange: '95-100',
      ),
      TestResultParameter(
        name: 'Pulse Rate',
        value: pulseRate.toString(),
        unit: 'BPM',
        isAbnormal: pulseRate > 100 || pulseRate < 60,
        normalRange: '60-100',
      ),
      TestResultParameter(
        name: 'Pulse Pressure',
        value: pulsePressure.toString(),
        unit: 'mmHg',
        isAbnormal: pulsePressure > 60 || pulsePressure < 30,
        normalRange: '30-60',
      ),
      TestResultParameter(
        name: 'Mean Arterial Pressure',
        value: meanArterialPressure.toString(),
        unit: 'mmHg',
        isAbnormal: meanArterialPressure > 105 || meanArterialPressure < 70,
        normalRange: '70-105',
      ),
    ];

    return TestResult(
      id: id,
      testType: TestType.bloodSaturation,
      testName: 'Blood Oxygen',
      completedAt: completedAt,
      parameters: parameters,
      overallStatus:
          parameters.any((p) => p.isAbnormal)
              ? TestResultStatus.abnormal
              : TestResultStatus.normal,
      category: category,
    );
  }

  static TestResult createEcgResult({
    required String id,
    required DateTime completedAt,
    required int heartRate,
    required String rhythm,
    required String category,
  }) {
    final isLeadType = category.contains('lead');
    final leads = category == '6_lead' ? 6 : 12;

    final parameters = [
      TestResultParameter(
        name: 'Heart Rate',
        value: heartRate.toString(),
        unit: 'BPM',
        isAbnormal: heartRate > 100 || heartRate < 60,
        normalRange: '60-100',
      ),
      TestResultParameter(
        name: 'Rhythm',
        value: rhythm,
        unit: '',
        isAbnormal: rhythm.toLowerCase() != 'normal',
      ),
      if (isLeadType)
        TestResultParameter(
          name: 'Lead Configuration',
          value: '$leads-Lead',
          unit: '',
          isAbnormal: false,
        ),
      TestResultParameter(
        name: 'Overall Assessment',
        value: 'Normal ECG',
        unit: '',
        isAbnormal: false,
      ),
    ];

    return TestResult(
      id: id,
      testType: TestType.ecg,
      testName: 'ECG',
      completedAt: completedAt,
      parameters: parameters,
      overallStatus:
          parameters.any((p) => p.isAbnormal)
              ? TestResultStatus.abnormal
              : TestResultStatus.normal,
      category: category,
    );
  }

  static TestResult createBodySoundResult({
    required String id,
    required DateTime completedAt,
    required String soundQuality,
    required String category,
  }) {
    String categoryName;
    String soundType;
    switch (category) {
      case 'heart':
        categoryName = 'Heart';
        soundType = 'Heart Sounds';
        break;
      case 'lungs':
        categoryName = 'Lungs';
        soundType = 'Lung Sounds';
        break;
      case 'stomach':
        categoryName = 'Stomach';
        soundType = 'Stomach Sounds';
        break;
      case 'bowel':
        categoryName = 'Bowel';
        soundType = 'Bowel Sounds';
        break;
      default:
        categoryName = 'Body';
        soundType = 'Body Sounds';
    }

    final parameters = [
      TestResultParameter(
        name: soundType,
        value: soundQuality,
        unit: '',
        isAbnormal: soundQuality.toLowerCase() != 'normal',
      ),
      TestResultParameter(
        name: 'Examination Area',
        value: categoryName,
        unit: '',
        isAbnormal: false,
      ),
      TestResultParameter(
        name: 'Overall Assessment',
        value: 'Normal ${soundType.toLowerCase()}',
        unit: '',
        isAbnormal: false,
      ),
    ];

    return TestResult(
      id: id,
      testType: TestType.bodySound,
      testName: 'Body Sounds',
      completedAt: completedAt,
      parameters: parameters,
      overallStatus:
          parameters.any((p) => p.isAbnormal)
              ? TestResultStatus.abnormal
              : TestResultStatus.normal,
      category: category,
    );
  }

  static TestResult createEntResult({
    required String id,
    required DateTime completedAt,
    required String findings,
    required String category,
  }) {
    String categoryName;
    String examinationType;
    switch (category) {
      case 'ear':
        categoryName = 'Ear';
        examinationType = 'Otoscopic Examination';
        break;
      case 'nose':
        categoryName = 'Nose';
        examinationType = 'Rhinoscopic Examination';
        break;
      case 'throat':
        categoryName = 'Throat';
        examinationType = 'Pharyngoscopic Examination';
        break;
      default:
        categoryName = 'ENT';
        examinationType = 'ENT Examination';
    }

    final parameters = [
      TestResultParameter(
        name: examinationType,
        value: findings,
        unit: '',
        isAbnormal: findings.toLowerCase() != 'normal',
      ),
      TestResultParameter(
        name: 'Examination Area',
        value: categoryName,
        unit: '',
        isAbnormal: false,
      ),
      TestResultParameter(
        name: 'Overall Assessment',
        value: 'Normal ${categoryName.toLowerCase()} examination',
        unit: '',
        isAbnormal: false,
      ),
    ];

    return TestResult(
      id: id,
      testType: TestType.ent,
      testName: 'ENT',
      completedAt: completedAt,
      parameters: parameters,
      overallStatus:
          parameters.any((p) => p.isAbnormal)
              ? TestResultStatus.abnormal
              : TestResultStatus.normal,
      category: category,
    );
  }

  static TestResult createBodyTemperatureResult({
    required String id,
    required DateTime completedAt,
    required double temperature,
    String? category,
  }) {
    final parameters = [
      TestResultParameter(
        name: 'Body Temperature',
        value: temperature.toStringAsFixed(1),
        unit: '°F',
        isAbnormal: temperature > 100.4 || temperature < 97.0,
        normalRange: '97.0-100.4',
      ),
      TestResultParameter(
        name: 'Temperature Status',
        value:
            temperature > 100.4
                ? 'Fever'
                : temperature < 97.0
                ? 'Hypothermia'
                : 'Normal',
        unit: '',
        isAbnormal: temperature > 100.4 || temperature < 97.0,
      ),
    ];

    return TestResult(
      id: id,
      testType: TestType.bodyTemperature,
      testName: 'Body Temperature',
      completedAt: completedAt,
      parameters: parameters,
      overallStatus:
          parameters.any((p) => p.isAbnormal)
              ? TestResultStatus.abnormal
              : TestResultStatus.normal,
      category: category,
    );
  }
}
