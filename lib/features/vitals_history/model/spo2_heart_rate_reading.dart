import 'package:ausa/features/vitals_history/model/vital_reading.dart';

class SpO2HeartRateReading extends VitalReading {
  final double oxygenSaturation; // SpO2 percentage
  final int heartRate; // BPM

  SpO2HeartRateReading({
    required super.id,
    required super.timestamp,
    required super.status,
    required this.oxygenSaturation,
    required this.heartRate,
    super.notes,
  }) : super(type: VitalType.spO2HeartRate);

  factory SpO2HeartRateReading.fromJson(Map<String, dynamic> json) {
    return SpO2HeartRateReading(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      status: VitalStatus.values[json['status']],
      oxygenSaturation: json['oxygenSaturation'].toDouble(),
      heartRate: json['heartRate'],
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
      'oxygenSaturation': oxygenSaturation,
      'heartRate': heartRate,
      'notes': notes,
    };
  }

  @override
  String get displayValue => '${oxygenSaturation.toStringAsFixed(1)}% SpO2';

  @override
  String get unit => '%';
}
