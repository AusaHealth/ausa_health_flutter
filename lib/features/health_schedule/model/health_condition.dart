class HealthCondition {
  final String id;
  final String name;
  final String color;
  final String? description;
  final bool isActive;

  const HealthCondition({
    required this.id,
    required this.name,
    required this.color,
    this.description,
    this.isActive = true,
  });

  HealthCondition copyWith({
    String? id,
    String? name,
    String? color,
    String? description,
    bool? isActive,
  }) {
    return HealthCondition(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }

  factory HealthCondition.fromJson(Map<String, dynamic> json) {
    return HealthCondition(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'description': description,
      'isActive': isActive,
    };
  }
}

// Pre-defined health conditions
class HealthConditions {
  static const HealthCondition hypertension = HealthCondition(
    id: 'hypertension',
    name: 'Hypertension',
    color: '#1F2937', // Dark gray
  );

  static const HealthCondition diabetes = HealthCondition(
    id: 'type_ii_diabetes',
    name: 'Type II Diabetes',
    color: '#1F2937', // Dark gray
  );

  static const HealthCondition insomnia = HealthCondition(
    id: 'insomnia',
    name: 'Insomnia',
    color: '#1F2937', // Dark gray
  );

  static const List<HealthCondition> predefined = [
    hypertension,
    diabetes,
    insomnia,
  ];
}
