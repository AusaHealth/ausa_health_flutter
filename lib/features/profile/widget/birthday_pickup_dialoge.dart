import 'package:ausa/common/widget/buttons.dart';
import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/design_scale.dart';
import 'package:ausa/constants/icons.dart';
import 'package:ausa/constants/radius.dart';
import 'package:ausa/constants/spacing.dart';
import 'package:ausa/constants/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BirthdayPickerDialouge extends StatefulWidget {
  final DateTime? initialDate;
  final void Function(DateTime) onDone;

  const BirthdayPickerDialouge({
    super.key,
    this.initialDate,
    required this.onDone,
  });

  @override
  State<BirthdayPickerDialouge> createState() => _BirthdayPickerDialougeState();
}

class _BirthdayPickerDialougeState extends State<BirthdayPickerDialouge> {
  int step = 0; // 0: Year, 1: Month, 2: Day
  int? selectedMonth;
  int? selectedDay;
  int? selectedYear;
  int? selectedRangeStart;
  int? selectedRangeEnd;
  final int minYear = 1901;
  final int maxYear = DateTime.now().year;
  late DateTime currentMonth;

  // Validation message
  String? validationMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      selectedYear = widget.initialDate!.year;
      selectedMonth = widget.initialDate!.month;
      selectedDay = widget.initialDate!.day;
      currentMonth = DateTime(selectedYear!, selectedMonth!, 1);
      step = 0;
    } else {
      selectedYear = null;
      selectedMonth = null;
      selectedDay = null;
      // Do not set _currentMonth, keep it uninitialized until a year/month is picked
    }
  }

  void goToStep(int s) {
    setState(() {
      if (s == 1 && selectedYear == null) {
        validationMessage = 'Please select Year first';
        return;
      }
      if (s == 2 && selectedMonth == null) {
        validationMessage = 'Please select month first';
        return;
      }
      validationMessage = null;
      step = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl3),
      ),
      height: DesignScaleManager.scaleValue(1084),
      width: DesignScaleManager.scaleValue(1136),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl6,
        vertical: AppSpacing.xl4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Select Date',
                style: AppTypography.body(
                  weight: AppTypographyWeight.regular,
                  color: AppColors.blackColor,
                ),
              ),
              Spacer(),
              AusaButton(
                leadingIcon: SvgPicture.asset(
                  height: DesignScaleManager.scaleValue(24),
                  width: DesignScaleManager.scaleValue(24),
                  AusaIcons.gift01,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary500,
                    BlendMode.srcIn,
                  ),
                ),
                size: ButtonSize.s,
                variant: ButtonVariant.tertiary,
                text: selectedDateString ?? 'Birthday',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),

          SizedBox(height: AppSpacing.xl2),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _stepButtonTab(
                selectedYear != null ? '${selectedYear}' : 'Select Year',
                selectedYear != null
                    ? AusaIcons.chevronDown
                    : AusaIcons.chevronUp,

                step == 0,
                () => goToStep(0),
              ),
              SizedBox(width: AppSpacing.xl),
              _stepButtonTab(
                selectedMonth != null
                    ? '${fullMonthNames[selectedMonth! - 1]}'
                    : 'Select Month',
                selectedMonth != null
                    ? AusaIcons.chevronDown
                    : AusaIcons.chevronUp,

                step == 1,
                () => goToStep(1),
              ),
              SizedBox(width: AppSpacing.xl),
              _stepButtonTab(
                selectedDay != null ? '${selectedDay}' : 'Select Date',
                selectedDay != null
                    ? AusaIcons.chevronDown
                    : AusaIcons.chevronUp,

                step == 2,
                () => goToStep(2),
              ),
            ],
          ),

          if (selectedRangeStart != null) ...[
            SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: DesignScaleManager.scaleValue(84),
                  height: DesignScaleManager.scaleValue(84),
                  decoration: BoxDecoration(
                    color: Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(AppRadius.xl3),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      goToStep(0);
                      setState(() {
                        selectedRangeStart = null;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: SvgPicture.asset(
                        AusaIcons.chevronLeft,
                        height: DesignScaleManager.scaleValue(32),
                        width: DesignScaleManager.scaleValue(32),
                        colorFilter: ColorFilter.mode(
                          AppColors.blackColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Container(
                  height: DesignScaleManager.scaleValue(84),
                  decoration: BoxDecoration(
                    color: Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(AppRadius.xl3),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      goToStep(0);
                      setState(() {
                        selectedRangeStart = null;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                      child: Text(
                        selectedRangeStart != null
                            ? '${selectedRangeStart} - ${selectedRangeEnd}'
                            : '1901 - 1910',
                        style: AppTypography.callout(
                          weight: AppTypographyWeight.medium,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Step content
          SizedBox(height: AppSpacing.xl),
          if (validationMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                validationMessage!,
                style: AppTypography.body(
                  color: Colors.red,
                  weight: AppTypographyWeight.medium,
                ),
              ),
            ),
          if (step == 0)
            selectedRangeStart == null ? _yearRangeGrid() : _yearGridInRange(),
          if (step == 1) _monthGrid(),
          if (step == 2)
            Column(
              children: [
                if (selectedYear != null && selectedMonth != null)
                  DayGridSelector(
                    year: selectedYear!,
                    month: selectedMonth!,
                    selectedDay: selectedDay,
                    onDaySelected: (day) {
                      setState(() {
                        selectedDay = day;
                      });
                    },
                  ),
              ],
            ),

          // Action buttons
          // Spacer(),
          Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AusaButton(
                size: ButtonSize.lg,
                borderColor: AppColors.primary500,
                variant: ButtonVariant.secondary,
                text: 'Cancel',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(width: AppSpacing.md),
              AusaButton(
                size: ButtonSize.lg,
                text: 'Done',
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepButtonTab(
    String label,
    String icon,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: AppTypography.body(
                weight: AppTypographyWeight.regular,
                color: selected ? Colors.white : AppColors.blackColor,
              ),
            ),
            SizedBox(width: AppSpacing.mdLarge),
            SvgPicture.asset(
              icon,
              height: DesignScaleManager.scaleValue(24),
              width: DesignScaleManager.scaleValue(24),
              colorFilter: ColorFilter.mode(
                selected ? Colors.white : AppColors.blackColor,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                  selectedRangeEnd = range[1];
                  // Do not change step here
                });
              },
              child: Container(
                width: DesignScaleManager.scaleValue(294),
                height: DesignScaleManager.scaleValue(84),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Color(0xffF0F9FF),
                  borderRadius: BorderRadius.circular(AppRadius.xl3),
                ),
                child: Text(
                  '${range[0]} - ${range[1]}',
                  style: AppTypography.callout(
                    weight: AppTypographyWeight.regular,
                    color: isSelected ? Colors.white : AppColors.primary600,
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
              step = 1;
              selectedRangeStart = null;
              validationMessage = null; // Clear validation after year selection
            });
          },
          child: Container(
            width: DesignScaleManager.scaleValue(294),
            height: DesignScaleManager.scaleValue(84),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Color(0xffF0F9FF),
              borderRadius: BorderRadius.circular(AppRadius.xl3),
            ),
            child: Text(
              y.toString(),
              style: AppTypography.callout(
                weight: AppTypographyWeight.regular,
                color: isSelected ? Colors.white : AppColors.primary600,
              ),
            ),
          ),
        );
      }),
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
    // 5 columns: 5 * 132 + 4 * spacing
    final double itemWidth = DesignScaleManager.scaleValue(132);
    final double spacing = AppSpacing.xl2;
    final int columns = 5;
    final double totalWidth = columns * itemWidth + (columns - 1) * spacing;

    return Center(
      child: SizedBox(
        width: totalWidth,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: AppSpacing.lg,
          children: List.generate(12, (i) {
            final isSelected = selectedMonth == i + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedMonth = i + 1;
                  step = 2;
                  currentMonth = DateTime(
                    selectedYear ?? DateTime.now().year,
                    i + 1,
                    1,
                  );
                  validationMessage =
                      null; // Clear validation after month selection
                });
              },
              child: Container(
                width: itemWidth,
                height: DesignScaleManager.scaleValue(84),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Color(0xffF0F9FF),
                  borderRadius: BorderRadius.circular(AppRadius.xl3),
                ),
                child: Text(
                  months[i],
                  style: AppTypography.callout(
                    weight: AppTypographyWeight.regular,
                    color: isSelected ? Colors.white : Color(0xff155EEF),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
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

  final List<String> fullMonthNames = [
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

  String? get selectedFullMonthName {
    if (selectedMonth != null) {
      return fullMonthNames[selectedMonth! - 1];
    }
    return null;
  }
}

class DayGridSelector extends StatelessWidget {
  final int year;
  final int month;
  final int? selectedDay;
  final void Function(int day) onDaySelected;

  const DayGridSelector({
    super.key,
    required this.year,
    required this.month,
    this.selectedDay,
    required this.onDaySelected,
  });

  int _daysInMonth(int year, int month) {
    if (month == 12) {
      return DateTime(year + 1, 1, 0).day;
    }
    return DateTime(year, month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    final int daysCount = _daysInMonth(year, month);
    final int firstWeekday =
        DateTime(year, month, 1).weekday; // 1 (Mon) - 7 (Sun)
    final int totalGridCount = daysCount + (firstWeekday - 1);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map(
              (d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: AppTypography.callout(
                      weight: AppTypographyWeight.regular,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xl2),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 14,
            crossAxisSpacing: 6,

            childAspectRatio: 1.9,
            // mainAxisExtent: 30,
          ),
          itemCount: totalGridCount,
          itemBuilder: (context, index) {
            if (index < firstWeekday - 1) {
              return const SizedBox.shrink();
            }
            final day = index - (firstWeekday - 2);
            final isSelected = day == selectedDay;
            return GestureDetector(
              onTap: () => onDaySelected(day),
              child: Container(
                height: DesignScaleManager.scaleValue(70),
                width: DesignScaleManager.scaleValue(70),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.black : Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  day.toString(),
                  style: AppTypography.callout(
                    weight:
                        isSelected
                            ? AppTypographyWeight.medium
                            : AppTypographyWeight.regular,
                    color: isSelected ? Colors.white : AppColors.blackColor,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
