enum InputTypeEnum {
  text,
  number,
  dateTime,
  date,
  selector,
  password,
  phoneNumber,
}

class InputModel {
  final String name;
  final String label;
  final InputTypeEnum inputType;
  final List<dynamic>? inputSource; // For selector types
  dynamic value;

  InputModel({
    required this.name,
    required this.label,
    required this.inputType,
    this.inputSource,
    this.value,
  });

  InputModel copyWith({
    String? name,
    String? label,
    InputTypeEnum? inputType,
    List<dynamic>? inputSource,
    dynamic value,
  }) {
    return InputModel(
      name: name ?? this.name,
      label: label ?? this.label,
      inputType: inputType ?? this.inputType,
      inputSource: inputSource ?? this.inputSource,
      value: value ?? this.value,
    );
  }
}
