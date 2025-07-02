class Appointment {
  final String id;
  final DateTime dateTime;
  final String doctorName;
  final String doctorType;
  final String symptoms;
  final AppointmentStatus status;
  final String? doctorImageUrl;

  Appointment({
    required this.id,
    required this.dateTime,
    required this.doctorName,
    required this.doctorType,
    required this.symptoms,
    required this.status,
    this.doctorImageUrl,
  });

  // Serialization methods
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'doctorName': doctorName,
      'doctorType': doctorType,
      'symptoms': symptoms,
      'status': status.name,
      'doctorImageUrl': doctorImageUrl,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      doctorName: json['doctorName'] as String,
      doctorType: json['doctorType'] as String,
      symptoms: json['symptoms'] as String,
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      doctorImageUrl: json['doctorImageUrl'] as String?,
    );
  }

  // Copy method for updates
  Appointment copyWith({
    String? id,
    DateTime? dateTime,
    String? doctorName,
    String? doctorType,
    String? symptoms,
    AppointmentStatus? status,
    String? doctorImageUrl,
  }) {
    return Appointment(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      doctorName: doctorName ?? this.doctorName,
      doctorType: doctorType ?? this.doctorType,
      symptoms: symptoms ?? this.symptoms,
      status: status ?? this.status,
      doctorImageUrl: doctorImageUrl ?? this.doctorImageUrl,
    );
  }

  // Validation
  bool get isValid {
    return id.isNotEmpty &&
        doctorName.isNotEmpty &&
        doctorType.isNotEmpty &&
        symptoms.trim().isNotEmpty;
  }

  String get formattedDate {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${_getDayName(dateTime.weekday)}, ${months[dateTime.month - 1]} ${dateTime.day}';
  }

  String get formattedTime {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Appointment &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Appointment{id: $id, dateTime: $dateTime, doctorName: $doctorName, symptoms: $symptoms}';
  }
}

enum AppointmentStatus { confirmed, pending, cancelled }
