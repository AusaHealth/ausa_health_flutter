enum InputTypeEnum { text, number, dateTime, date, selector }

class InputModel {
  final String name;
  final String label;
  final InputTypeEnum inputType;
  final List<dynamic>? inputSource; // For selector types
  dynamic value;
  final String? key; // New field for special recognition

  InputModel({
    required this.name,
    required this.label,
    required this.inputType,
    this.inputSource,
    this.value,
    this.key,
  });

  InputModel copyWith({
    String? name,
    String? label,
    InputTypeEnum? inputType,
    List<dynamic>? inputSource,
    dynamic value,
    String? key,
  }) {
    return InputModel(
      name: name ?? this.name,
      label: label ?? this.label,
      inputType: inputType ?? this.inputType,
      inputSource: inputSource ?? this.inputSource,
      value: value ?? this.value,
      key: key ?? this.key,
    );
  }
}
