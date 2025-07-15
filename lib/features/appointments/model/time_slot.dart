class TimeSlot {
  final String id;
  final DateTime dateTime;
  final bool isAvailable;
  final String? doctorId;

  TimeSlot({
    required this.id,
    required this.dateTime,
    required this.isAvailable,
    this.doctorId,
  });

  // Serialization methods
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'isAvailable': isAvailable,
      'doctorId': doctorId,
    };
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      isAvailable: json['isAvailable'] as bool,
      doctorId: json['doctorId'] as String?,
    );
  }

  // Copy method for updates
  TimeSlot copyWith({
    String? id,
    DateTime? dateTime,
    bool? isAvailable,
    String? doctorId,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      isAvailable: isAvailable ?? this.isAvailable,
      doctorId: doctorId ?? this.doctorId,
    );
  }

  // Validation
  bool get isValid {
    return id.isNotEmpty &&
        dateTime.isAfter(DateTime.now().subtract(Duration(days: 1)));
  }

  String get formattedTime {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  String get formattedDate {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String get formattedDateTime {
    return '$formattedDate at $formattedTime';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlot && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TimeSlot{id: $id, dateTime: $dateTime, isAvailable: $isAvailable}';
  }
}
