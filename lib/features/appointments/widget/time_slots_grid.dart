import 'package:ausa/constants/constants.dart';
import 'package:ausa/constants/typography.dart';
import 'package:ausa/features/appointments/model/time_slot.dart';
import 'package:ausa/common/widget/buttons.dart';
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
    final availableSlots = timeSlots.where((slot) => slot.isAvailable).toList();

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.xl5,
        right: AppSpacing.xl5,
        top: AppSpacing.xl4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Time Slot', style: AppTypography.body()),

          const SizedBox(height: 24),

          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: availableSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = availableSlots[index];
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

    return AusaButton(
      text: timeSlot.formattedTime,
      backgroundColor: isSelected ? AppColors.black : AppColors.primary25,
      borderColor: AppColors.primary25,
      textColor: isSelected ? AppColors.white : AppColors.primary700,
      variant: isSelected ? ButtonVariant.primary : ButtonVariant.secondary,
      onPressed: () => onTimeSlotSelected(timeSlot),
    );
  }
}
