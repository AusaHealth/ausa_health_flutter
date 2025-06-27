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
}

enum AppointmentStatus { confirmed, pending, cancelled }
