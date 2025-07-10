import 'package:flutter/material.dart';

class BirthdayPickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final void Function(DateTime) onDone;

  const BirthdayPickerDialog({
    super.key,
    this.initialDate,
    required this.onDone,
  });

  @override
  State<BirthdayPickerDialog> createState() => _BirthdayPickerDialogState();
}

class _BirthdayPickerDialogState extends State<BirthdayPickerDialog> {
  int step = 0; // 0: Month, 1: Day, 2: Year
  int? selectedMonth;
  int? selectedDay;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      selectedMonth = widget.initialDate!.month;
      selectedDay = widget.initialDate!.day;
      selectedYear = widget.initialDate!.year;
      step = 0;
    }
  }

  void goToStep(int s) => setState(() => step = s);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      backgroundColor: Colors.white,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Date',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                if (selectedDateString != null)
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.cake, color: Colors.blue),
                    label: Text(
                      selectedDateString!,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // Stepper
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _stepButton('Select Month', step == 0, () => goToStep(0)),
                const SizedBox(width: 8),
                _stepButton('Select Date', step == 1, () => goToStep(1)),
                const SizedBox(width: 8),
                _stepButton(
                  'Select Year',
                  step == 2 || step == 3,
                  () => goToStep(2),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Step content
            if (step == 0) _monthGrid(),
            if (step == 1) _calendarView(),
            if (step == 2) _yearRangeGrid(),
            if (step == 3) _yearGridInRange(),
            const SizedBox(height: 32),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 18,
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      (selectedMonth != null &&
                              selectedDay != null &&
                              selectedYear != null)
                          ? () {
                            widget.onDone(
                              DateTime(
                                selectedYear!,
                                selectedMonth!,
                                selectedDay!,
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 18,
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepButton(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _monthGrid() {
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: List.generate(12, (i) {
        final isSelected = selectedMonth == i + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedMonth = i + 1;
              // If year is already selected, go to calendar, else go to year range
              if (selectedYear != null) {
                step = 1; // Go to calendar
              } else {
                step = 2; // Go to year range
              }
            });
          },
          child: Container(
            width: 64,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              months[i],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _calendarView() {
    if (selectedMonth == null || selectedYear == null) {
      return Center(child: Text('Please select month and year'));
    }
    final daysInMonth = DateUtils.getDaysInMonth(selectedYear!, selectedMonth!);
    final firstDay = DateTime(selectedYear!, selectedMonth!, 1).weekday;
    final List<Widget> dayWidgets = [];
    for (int i = 1; i < firstDay; i++) {
      dayWidgets.add(Container(width: 40, height: 40));
    }
    for (int d = 1; d <= daysInMonth; d++) {
      final isSelected = selectedDay == d;
      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDay = d;
              // Optionally, go to year step here
            });
          },
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              d.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            7,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                ['S', 'M', 'T', 'W', 'T', 'F', 'S'][i],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 0, runSpacing: 0, children: dayWidgets),
      ],
    );
  }

  int? selectedRangeStart;
  final int minYear = 1901;
  final int maxYear =
      DateTime.now().year + 3; // or whatever upper bound you want

  List<List<int>> get yearRanges {
    List<List<int>> ranges = [];
    for (int y = minYear; y <= maxYear; y += 10) {
      int end = (y + 9 > maxYear) ? maxYear : y + 9;
      ranges.add([y, end]);
    }
    return ranges;
  }

  Widget _yearRangeGrid() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children:
          yearRanges.map((range) {
            final isSelected = selectedRangeStart == range[0];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedRangeStart = range[0];
                  step = 3; // Go to year selection in range
                });
              },
              child: Container(
                width: 160,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      isSelected ? Colors.blue : Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${range[0]} - ${range[1]}',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _yearGridInRange() {
    if (selectedRangeStart == null) return SizedBox.shrink();
    int start = selectedRangeStart!;
    int end = (start + 9 > maxYear) ? maxYear : start + 9;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: List.generate(end - start + 1, (i) {
        int y = start + i;
        final isSelected = selectedYear == y;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedYear = y;
              // If month is already selected, go to calendar, else go to month selection
              if (selectedMonth != null) {
                step = 1; // Go to calendar
              } else {
                step = 0; // Go to month selection
              }
            });
          },
          child: Container(
            width: 80,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              y.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }

  String? get selectedDateString {
    if (selectedMonth != null && selectedDay != null) {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      String yearStr = selectedYear != null ? ', $selectedYear' : '';
      return '${months[selectedMonth! - 1]} $selectedDay$yearStr';
    }
    return null;
  }
}
