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
    return Container(
      padding: const EdgeInsets.all(24),
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

    return AusaButton(
      text: timeSlot.formattedTime,
      variant: isSelected ? ButtonVariant.primary : ButtonVariant.secondary,
      onPressed:
          timeSlot.isAvailable ? () => onTimeSlotSelected(timeSlot) : null,
      isDisabled: !timeSlot.isAvailable,
    );
  }
}
