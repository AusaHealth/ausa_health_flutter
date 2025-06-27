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

  String get formattedTime {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  static List<TimeSlot> generateDummySlots(DateTime selectedDate) {
    final List<TimeSlot> slots = [];
    final timeSlots = [
      '10:00 AM',
      '10:30 AM',
      '11:00 AM',
      '11:30 AM',
      '12:00 PM',
      '12:30 PM',
      '1:00 PM',
      '1:30 PM',
      '2:00 PM',
      '2:30 PM',
      '3:00 PM',
      '3:30 PM',
    ];

    for (int i = 0; i < timeSlots.length; i++) {
      final timeParts = timeSlots[i].split(' ');
      final hourMinute = timeParts[0].split(':');
      int hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      final period = timeParts[1];

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      final slotDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );

      slots.add(
        TimeSlot(
          id: 'slot_$i',
          dateTime: slotDateTime,
          isAvailable: i != 4, // Make 12:00 PM unavailable as example
          doctorId: 'doctor_1',
        ),
      );
    }

    return slots;
  }
}
