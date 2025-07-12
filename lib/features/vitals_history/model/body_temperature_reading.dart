import 'vital_reading.dart';

enum TemperatureMeasurementLocation {
  oral,
  axillary,
  rectal,
  tympanic,
  temporal,
}

enum TemperatureUnit { celsius, fahrenheit }

class BodyTemperatureReading extends VitalReading {
  final double temperature;
  final TemperatureMeasurementLocation measurementLocation;
  final TemperatureUnit temperatureUnit;

  BodyTemperatureReading({
    required super.id,
    required super.timestamp,
    required super.status,
    required this.temperature,
    required this.measurementLocation,
    this.temperatureUnit = TemperatureUnit.celsius,
    super.notes,
  }) : super(type: VitalType.bodyTemperature);

  factory BodyTemperatureReading.fromJson(Map<String, dynamic> json) {
    return BodyTemperatureReading(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      status: VitalStatus.values[json['status']],
      temperature: json['temperature'].toDouble(),
      measurementLocation:
          TemperatureMeasurementLocation.values[json['measurementLocation']],
      temperatureUnit: TemperatureUnit.values[json['temperatureUnit'] ?? 0],
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
      'temperature': temperature,
      'measurementLocation': measurementLocation.index,
      'temperatureUnit': temperatureUnit.index,
      'notes': notes,
    };
  }

  @override
  String get displayValue => temperature.toStringAsFixed(1);

  @override
  String get unit => temperatureUnit == TemperatureUnit.celsius ? '°C' : '°F';

  String get locationDisplay {
    switch (measurementLocation) {
      case TemperatureMeasurementLocation.oral:
        return 'Oral';
      case TemperatureMeasurementLocation.axillary:
        return 'Axillary';
      case TemperatureMeasurementLocation.rectal:
        return 'Rectal';
      case TemperatureMeasurementLocation.tympanic:
        return 'Tympanic';
      case TemperatureMeasurementLocation.temporal:
        return 'Temporal';
    }
  }

  // Helper method to convert between units
  double convertToFahrenheit() {
    if (temperatureUnit == TemperatureUnit.fahrenheit) return temperature;
    return (temperature * 9 / 5) + 32;
  }

  double convertToCelsius() {
    if (temperatureUnit == TemperatureUnit.celsius) return temperature;
    return (temperature - 32) * 5 / 9;
  }
}
