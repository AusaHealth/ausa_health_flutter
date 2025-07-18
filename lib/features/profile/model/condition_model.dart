class ConditionModel {
  final String diagonedWith;
  final BloodPressure bloodPressure;
  final BloodSugar bloodSugar;
  final BodyTemperature bodyTemperature;
  final HeartRate heartRate;

  ConditionModel({
    required this.diagonedWith,
    required this.bloodPressure,
    required this.bloodSugar,
    required this.bodyTemperature,
    required this.heartRate,
  });

  ConditionModel copyWith({
    String? diagonedWith,
    BloodPressure? bloodPressure,
    BloodSugar? bloodSugar,
    BodyTemperature? bodyTemperature,
    HeartRate? heartRate,
  }) {
    return ConditionModel(
      diagonedWith: diagonedWith ?? this.diagonedWith,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      bloodSugar: bloodSugar ?? this.bloodSugar,
      bodyTemperature: bodyTemperature ?? this.bodyTemperature,
      heartRate: heartRate ?? this.heartRate,
    );
  }
}

class BloodPressure {
  final String systolic;
  final String diastolic;

  BloodPressure({required this.systolic, required this.diastolic});
}

class BloodSugar {
  final String fasting;
  final String postPrandial;

  BloodSugar({required this.fasting, required this.postPrandial});
}

class BodyTemperature {
  final String temperatureF;
  final String temperatureC;
  BodyTemperature({required this.temperatureF, required this.temperatureC});
}

class HeartRate {
  final String heartRate;

  HeartRate({required this.heartRate});
}
