import 'package:ausa/features/profile/page/input_model.dart';

class FamilyModel {
  String shortName;
  String fullName;
  String relationship;
  String phone;
  String email;
  String address;

  FamilyModel({
    this.shortName = '',
    this.fullName = '',
    this.relationship = '',
    this.phone = '',
    this.email = '',
    this.address = '',
  });

  FamilyModel copyWith({
    String? shortName,
    String? fullName,
    String? relationship,
    String? phone,
    String? email,
    String? address,
  }) {
    return FamilyModel(
      shortName: shortName ?? this.shortName,
      fullName: fullName ?? this.fullName,
      relationship: relationship ?? this.relationship,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  void updateFromInputs(List<InputModel> inputs) {
    shortName = _getValue(inputs, 'shortName');
    fullName = _getValue(inputs, 'fullName');
    relationship = _getValue(inputs, 'relationship');
    phone = _getValue(inputs, 'phone');
    email = _getValue(inputs, 'email');
    address = _getValue(inputs, 'address');
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
