enum VitalType {
  bloodPressure,
  spO2HeartRate,
  bloodGlucose,
  bodyTemperature,
  ecg,
}

enum VitalStatus { normal, high, low, critical }

abstract class VitalReading {
  final String id;
  final DateTime timestamp;
  final VitalType type;
  final VitalStatus status;
  final String? notes;

  VitalReading({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.status,
    this.notes,
  });

  Map<String, dynamic> toJson();
  String get displayValue;
  String get unit;
}
