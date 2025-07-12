import 'package:ausa/common/model/test.dart';
import 'package:ausa/features/tests/model/test_result.dart';

enum MediaTestType { bodySound, ent }

enum MediaTestStatus { normal, abnormal, pending }

class MediaTestReading {
  final String id;
  final DateTime timestamp;
  final MediaTestType type;
  final MediaTestStatus status;
  final String
  category; // heart, lungs, stomach, bowel for bodySound; ear, nose, throat for ent
  final String? recordingPath; // Path to the audio/video recording
  final int? duration; // Duration in seconds
  final String? notes;
  final List<MediaTestParameter> parameters;
  final String? findings; // Overall findings/assessment

  MediaTestReading({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.status,
    required this.category,
    this.recordingPath,
    this.duration,
    this.notes,
    required this.parameters,
    this.findings,
  });

  factory MediaTestReading.fromTestResult(TestResult testResult) {
    MediaTestType mediaType;
    switch (testResult.testType) {
      case TestType.bodySound:
        mediaType = MediaTestType.bodySound;
        break;
      case TestType.ent:
        mediaType = MediaTestType.ent;
        break;
      default:
        throw ArgumentError('Invalid test type for media test reading');
    }

    MediaTestStatus status =
        testResult.hasAbnormalValues
            ? MediaTestStatus.abnormal
            : MediaTestStatus.normal;

    List<MediaTestParameter> mediaParameters =
        testResult.parameters
            .map(
              (param) => MediaTestParameter(
                name: param.name,
                value: param.value,
                unit: param.unit,
                isAbnormal: param.isAbnormal,
                normalRange: param.normalRange,
              ),
            )
            .toList();

    return MediaTestReading(
      id: testResult.id,
      timestamp: testResult.completedAt,
      type: mediaType,
      status: status,
      category: testResult.category ?? 'unknown',
      parameters: mediaParameters,
      findings: testResult.notes,
    );
  }

  MediaTestReading copyWith({
    String? id,
    DateTime? timestamp,
    MediaTestType? type,
    MediaTestStatus? status,
    String? category,
    String? recordingPath,
    int? duration,
    String? notes,
    List<MediaTestParameter>? parameters,
    String? findings,
  }) {
    return MediaTestReading(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      category: category ?? this.category,
      recordingPath: recordingPath ?? this.recordingPath,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
      parameters: parameters ?? this.parameters,
      findings: findings ?? this.findings,
    );
  }

  String get displayCategory {
    switch (type) {
      case MediaTestType.bodySound:
        return _formatBodySoundCategory(category);
      case MediaTestType.ent:
        return _formatEntCategory(category);
    }
  }

  String get displayTypeName {
    switch (type) {
      case MediaTestType.bodySound:
        return 'Body Sounds';
      case MediaTestType.ent:
        return 'ENT';
    }
  }

  String get primaryValue {
    if (parameters.isNotEmpty) {
      return parameters.first.value;
    }
    return findings ?? 'Normal';
  }

  String get formattedDuration {
    if (duration == null) return '';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get hasRecording => recordingPath != null && recordingPath!.isNotEmpty;

  String _formatBodySoundCategory(String category) {
    switch (category.toLowerCase()) {
      case 'heart':
        return 'Heart';
      case 'lungs':
      case 'lung':
        return 'Lung';
      case 'stomach':
        return 'Stomach';
      case 'bowel':
        return 'Bowel';
      default:
        return category.capitalize();
    }
  }

  String _formatEntCategory(String category) {
    switch (category.toLowerCase()) {
      case 'ear':
        return 'Ear';
      case 'nose':
        return 'Nose';
      case 'throat':
        return 'Throat';
      default:
        return category.capitalize();
    }
  }
}

class MediaTestParameter {
  final String name;
  final String value;
  final String unit;
  final bool isAbnormal;
  final String? normalRange;

  MediaTestParameter({
    required this.name,
    required this.value,
    required this.unit,
    required this.isAbnormal,
    this.normalRange,
  });

  MediaTestParameter copyWith({
    String? name,
    String? value,
    String? unit,
    bool? isAbnormal,
    String? normalRange,
  }) {
    return MediaTestParameter(
      name: name ?? this.name,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      isAbnormal: isAbnormal ?? this.isAbnormal,
      normalRange: normalRange ?? this.normalRange,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
