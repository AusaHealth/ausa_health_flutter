import 'package:ausa/features/profile/page/input_model.dart';

class UserModel {
  String name;
  String email;
  String address;
  DateTime dateOfBirth;
  String gender;
  String height;
  String weight;
  String phone;

  UserModel({
    required this.name,
    required this.email,
    required this.address,
    required this.dateOfBirth,
    required this.gender,
    required this.height,
    required this.weight,
    required this.phone,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? address,
    DateTime? dateOfBirth,
    String? gender,
    String? height,
    String? weight,
    String? phone,
    String? zip,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      phone: phone ?? this.phone,
    );
  }

  void updateFromInputs(List<InputModel> inputs) {
    final nameValue = _getValue(inputs, 'name');
    if (nameValue.isNotEmpty) name = nameValue;

    final emailValue = _getValue(inputs, 'email');
    if (emailValue.isNotEmpty) email = emailValue;

    final addressValue = _getValue(inputs, 'address');
    if (addressValue.isNotEmpty) address = addressValue;

    final dobValue =
        inputs
            .firstWhere(
              (e) => e.name == 'birthday',
              orElse:
                  () => InputModel(
                    name: 'birthday',
                    label: '',
                    inputType: InputTypeEnum.text,
                  ),
            )
            .value;

    if (dobValue is DateTime) {
      dateOfBirth = dobValue;
    } else if (dobValue is String && dobValue.isNotEmpty) {
      dateOfBirth = DateTime.parse(dobValue);
    }
    // If dobValue is empty or null, keep previous dateOfBirth

    final genderValue = _getValue(inputs, 'gender');
    if (genderValue.isNotEmpty) gender = genderValue;

    final heightValue = _getValue(inputs, 'height');
    if (heightValue.isNotEmpty) height = heightValue;

    final weightValue = _getValue(inputs, 'weight');
    if (weightValue.isNotEmpty) weight = weightValue;

    final phoneValue = _getValue(inputs, 'phone');
    if (phoneValue.isNotEmpty) phone = phoneValue;
  }

  static String _getValue(List<InputModel> inputs, String name) {
    return inputs
            .firstWhere(
              (e) => e.name == name,
              orElse:
                  () => InputModel(
                    name: name,
                    label: '',
                    inputType: InputTypeEnum.text,
                  ),
            )
            .value
            ?.toString() ??
        '';
  }
}
