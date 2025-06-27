import 'package:ausa/constants/color.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/appointments/model/time_slot.dart';
import 'package:flutter/material.dart';

class TimeSlotsGrid extends StatelessWidget {
  final List<TimeSlot> timeSlots;
  final TimeSlot? selectedTimeSlot;
  final Function(TimeSlot) onTimeSlotSelected;

  const TimeSlotsGrid({
    super.key,
    required this.timeSlots,
    this.selectedTimeSlot,
    required this.onTimeSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Time Slot',
            style: AppTypography.headline(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = timeSlots[index];
                return _buildTimeSlotButton(timeSlot);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotButton(TimeSlot timeSlot) {
    final isSelected = selectedTimeSlot?.id == timeSlot.id;
    final isAvailable = timeSlot.isAvailable;

    return GestureDetector(
      onTap: isAvailable ? () => onTimeSlotSelected(timeSlot) : null,
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF1B1B3B)
                  : isAvailable
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF1B1B3B)
                    : isAvailable
                    ? AppColors.primaryColor.withOpacity(0.3)
                    : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            timeSlot.formattedTime,
            style: AppTypography.body(
              color:
                  isSelected
                      ? Colors.white
                      : isAvailable
                      ? AppColors.primaryColor
                      : Colors.grey[400],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
