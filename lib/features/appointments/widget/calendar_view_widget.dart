import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';

class CalendarViewWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final VoidCallback onBackToWeekView;

  const CalendarViewWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onBackToWeekView,
  });

  @override
  State<CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with back to week view
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Date',
                style: AppTypography.headline(fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: widget.onBackToWeekView,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_view_week,
                        size: 16,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Back to week view',
                        style: AppTypography.callout(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _previousMonth,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.chevron_left, color: Colors.black87),
                ),
              ),
              Text(
                _getMonthYearString(_currentMonth),
                style: AppTypography.title2(fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: _nextMonth,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.chevron_right, color: Colors.black87),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Weekday headers
          _buildWeekdayHeaders(),

          const SizedBox(height: 16),

          // Calendar grid
          Expanded(child: _buildCalendarGrid()),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    return Row(
      children:
          weekdays.map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: AppTypography.body(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final firstDayWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    // Add previous month's trailing days
    final previousMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    final daysInPreviousMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 0).day;

    final days = <Widget>[];

    // Previous month days
    for (int i = firstDayWeekday - 1; i > 0; i--) {
      final day = daysInPreviousMonth - i + 1;
      days.add(
        _buildDayCell(
          day,
          isCurrentMonth: false,
          date: DateTime(previousMonth.year, previousMonth.month, day),
        ),
      );
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      days.add(_buildDayCell(day, isCurrentMonth: true, date: date));
    }

    // Next month days to fill the grid
    final nextMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    int nextMonthDay = 1;
    while (days.length % 7 != 0) {
      days.add(
        _buildDayCell(
          nextMonthDay,
          isCurrentMonth: false,
          date: DateTime(nextMonth.year, nextMonth.month, nextMonthDay),
        ),
      );
      nextMonthDay++;
    }

    return GridView.count(crossAxisCount: 7, children: days);
  }

  Widget _buildDayCell(
    int day, {
    required bool isCurrentMonth,
    required DateTime date,
  }) {
    final isSelected = _isSameDay(date, widget.selectedDate);
    final isToday = _isSameDay(date, DateTime.now());
    final isPast = date.isBefore(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    return GestureDetector(
      onTap:
          isCurrentMonth && !isPast ? () => widget.onDateSelected(date) : null,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF1B1B3B)
                  : isToday
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: AppTypography.body(
              color:
                  isSelected
                      ? Colors.white
                      : !isCurrentMonth || isPast
                      ? Colors.grey[400]
                      : isToday
                      ? AppColors.primaryColor
                      : Colors.black87,
              fontWeight:
                  isSelected || isToday ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthYearString(DateTime date) {
    const months = [
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
    return '${months[date.month - 1]} ${date.year}';
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }
}
