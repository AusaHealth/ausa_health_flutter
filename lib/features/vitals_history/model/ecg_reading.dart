import 'vital_reading.dart';

enum ECGRhythm {
  normal,
  atrialFibrillation,
  atrialFlutter,
  bradycardia,
  tachycardia,
  prematureVentricularContractions,
  unknown,
}

class ECGReading extends VitalReading {
  final int heartRate; // BPM
  final ECGRhythm rhythm;
  final double? qtInterval; // milliseconds
  final double? prInterval; // milliseconds
  final double? qrsWidth; // milliseconds
  final List<double>? rawData; // ECG waveform data points
  final int duration; // Recording duration in seconds

  ECGReading({
    required super.id,
    required super.timestamp,
    required super.status,
    required this.heartRate,
    required this.rhythm,
    required this.duration,
    this.qtInterval,
    this.prInterval,
    this.qrsWidth,
    this.rawData,
    super.notes,
  }) : super(type: VitalType.ecg);

  factory ECGReading.fromJson(Map<String, dynamic> json) {
    return ECGReading(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      status: VitalStatus.values[json['status']],
      heartRate: json['heartRate'],
      rhythm: ECGRhythm.values[json['rhythm']],
      duration: json['duration'],
      qtInterval: json['qtInterval']?.toDouble(),
      prInterval: json['prInterval']?.toDouble(),
      qrsWidth: json['qrsWidth']?.toDouble(),
      rawData: json['rawData']?.cast<double>(),
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
      'heartRate': heartRate,
      'rhythm': rhythm.index,
      'duration': duration,
      'qtInterval': qtInterval,
      'prInterval': prInterval,
      'qrsWidth': qrsWidth,
      'rawData': rawData,
      'notes': notes,
    };
  }

  @override
  String get displayValue => '$heartRate BPM';

  @override
  String get unit => 'BPM';

  String get rhythmDisplay {
    switch (rhythm) {
      case ECGRhythm.normal:
        return 'Normal Sinus Rhythm';
      case ECGRhythm.atrialFibrillation:
        return 'Atrial Fibrillation';
      case ECGRhythm.atrialFlutter:
        return 'Atrial Flutter';
      case ECGRhythm.bradycardia:
        return 'Bradycardia';
      case ECGRhythm.tachycardia:
        return 'Tachycardia';
      case ECGRhythm.prematureVentricularContractions:
        return 'PVCs';
      case ECGRhythm.unknown:
        return 'Unknown Rhythm';
    }
  }

  String get durationDisplay => '${duration}s recording';
}
