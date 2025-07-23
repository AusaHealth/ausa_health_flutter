import 'package:ausa/features/vitals_history/model/vital_reading.dart';

enum GlucoseMeasurementType { fasting, postMeal, random, beforeMeal, bedtime }

class BloodGlucoseReading extends VitalReading {
  final double glucoseLevel; // mg/dL
  final GlucoseMeasurementType measurementType;

  BloodGlucoseReading({
    required super.id,
    required super.timestamp,
    required super.status,
    required this.glucoseLevel,
    required this.measurementType,
    super.notes,
  }) : super(type: VitalType.bloodGlucose);

  factory BloodGlucoseReading.fromJson(Map<String, dynamic> json) {
    return BloodGlucoseReading(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      status: VitalStatus.values[json['status']],
      glucoseLevel: json['glucoseLevel'].toDouble(),
      measurementType: GlucoseMeasurementType.values[json['measurementType']],
      notes: json['notes'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type.index,
      'status': status.index,
      'glucoseLevel': glucoseLevel,
      'measurementType': measurementType.index,
      'notes': notes,
    };
  }

  @override
  String get displayValue => glucoseLevel.toStringAsFixed(0);

  @override
  String get unit => 'mg/dL';

  String get measurementTypeDisplay {
    switch (measurementType) {
      case GlucoseMeasurementType.fasting:
        return 'Fasting';
      case GlucoseMeasurementType.postMeal:
        return 'Post-meal';
      case GlucoseMeasurementType.random:
        return 'Random';
      case GlucoseMeasurementType.beforeMeal:
        return 'Before meal';
      case GlucoseMeasurementType.bedtime:
        return 'Bedtime';
    }
  }
}
