import 'package:flutter/material.dart';

class HealthActivity {
  final String id;
  final String title;
  final String? subtitle;
  final HealthActivityType type;
  final String? targetRange;
  final String? dosage;
  final String? description;
  final String? condition;
  final bool isCompleted;
  final DateTime? completedAt;
  final Map<String, dynamic>? metadata;
  final String? ctaText;
  final IconData? ctaIcon;

  const HealthActivity({
    required this.id,
    required this.title,
    this.subtitle,
    required this.type,
    this.targetRange,
    this.dosage,
    this.description,
    this.condition,
    this.isCompleted = false,
    this.completedAt,
    this.metadata,
    this.ctaText,
    this.ctaIcon,
  });

  HealthActivity copyWith({
    String? id,
    String? title,
    String? subtitle,
    HealthActivityType? type,
    String? targetRange,
    String? dosage,
    String? description,
    String? condition,
    bool? isCompleted,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
    String? ctaText,
    IconData? ctaIcon,
  }) {
    return HealthActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      targetRange: targetRange ?? this.targetRange,
      dosage: dosage ?? this.dosage,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
      ctaText: ctaText ?? this.ctaText,
      ctaIcon: ctaIcon ?? this.ctaIcon,
    );
  }

  factory HealthActivity.fromJson(Map<String, dynamic> json) {
    return HealthActivity(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      type: HealthActivityType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      targetRange: json['targetRange'] as String?,
      dosage: json['dosage'] as String?,
      description: json['description'] as String?,
      condition: json['condition'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt:
          json['completedAt'] != null
              ? DateTime.parse(json['completedAt'] as String)
              : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      ctaText: json['ctaText'] as String?,
      // ctaIcon:
      // json['ctaIcon'] != null
      //     ? IconData(json['ctaIcon'] as int, fontFamily: 'MaterialIcons')
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'type': type.toString().split('.').last,
      'targetRange': targetRange,
      'dosage': dosage,
      'description': description,
      'condition': condition,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'metadata': metadata,
      'ctaText': ctaText,
      'ctaIcon': ctaIcon?.codePoint,
    };
  }
}

enum HealthActivityType {
  bloodPressureCheck,
  bloodSugarCheck,
  medication,
  exercise,
  meal,
  vitals,
  other,
}
