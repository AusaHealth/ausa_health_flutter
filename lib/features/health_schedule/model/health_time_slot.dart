import 'package:ausa/features/health_schedule/model/health_activity.dart';

class HealthTimeSlot {
  final String id;
  final String title;
  final TimeSlotType type;
  final TimeOfDay timeOfDay;
  final MealTiming? mealTiming;
  final List<HealthActivity> activities;
  final bool isActive;

  const HealthTimeSlot({
    required this.id,
    required this.title,
    required this.type,
    required this.timeOfDay,
    this.mealTiming,
    required this.activities,
    this.isActive = true,
  });

  HealthTimeSlot copyWith({
    String? id,
    String? title,
    TimeSlotType? type,
    TimeOfDay? timeOfDay,
    MealTiming? mealTiming,
    List<HealthActivity>? activities,
    bool? isActive,
  }) {
    return HealthTimeSlot(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      mealTiming: mealTiming ?? this.mealTiming,
      activities: activities ?? this.activities,
      isActive: isActive ?? this.isActive,
    );
  }

  factory HealthTimeSlot.fromJson(Map<String, dynamic> json) {
    return HealthTimeSlot(
      id: json['id'] as String,
      title: json['title'] as String,
      type: TimeSlotType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      timeOfDay: TimeOfDay.values.firstWhere(
        (e) => e.toString().split('.').last == json['timeOfDay'],
      ),
      mealTiming:
          json['mealTiming'] != null
              ? MealTiming.values.firstWhere(
                (e) => e.toString().split('.').last == json['mealTiming'],
              )
              : null,
      activities:
          (json['activities'] as List<dynamic>)
              .map(
                (activityJson) => HealthActivity.fromJson(
                  activityJson as Map<String, dynamic>,
                ),
              )
              .toList(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.toString().split('.').last,
      'timeOfDay': timeOfDay.toString().split('.').last,
      'mealTiming': mealTiming?.toString().split('.').last,
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'isActive': isActive,
    };
  }
}

enum TimeSlotType { beforeMeal, afterMeal, general }

enum TimeOfDay { morning, midDay, afternoon, evening }

enum MealTiming {
  beforeBreakfast,
  afterBreakfast,
  beforeLunch,
  afterLunch,
  beforeDinner,
  afterDinner,
}
