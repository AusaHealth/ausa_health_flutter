import 'vital_reading.dart';

class BloodPressureReading extends VitalReading {
  final int systolic;
  final int diastolic;
  final int map; // Mean Arterial Pressure
  final int pulsePressure;

  BloodPressureReading({
    required super.id,
    required super.timestamp,
    required super.status,
    required this.systolic,
    required this.diastolic,
    required this.map,
    required this.pulsePressure,
    super.notes,
  }) : super(type: VitalType.bloodPressure);

  factory BloodPressureReading.fromJson(Map<String, dynamic> json) {
    return BloodPressureReading(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      status: VitalStatus.values[json['status']],
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      map: json['map'],
      pulsePressure: json['pulsePressure'],
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
      'systolic': systolic,
      'diastolic': diastolic,
      'map': map,
      'pulsePressure': pulsePressure,
      'notes': notes,
    };
  }

  @override
  String get displayValue => '$systolic/$diastolic';

  @override
  String get unit => 'mmHg';

  // Helper method to calculate MAP if not provided
  static int calculateMAP(int systolic, int diastolic) {
    return ((2 * diastolic) + systolic) ~/ 3;
  }

  // Helper method to calculate pulse pressure if not provided
  static int calculatePulsePressure(int systolic, int diastolic) {
    return systolic - diastolic;
  }
}
