import 'package:ausa/features/profile/page/input_model.dart';

class UserModel {
  String id;
  String name;
  String email;
  String address;
  DateTime? dateOfBirth; // Make it nullable
  String gender;
  String height;
  String weight;
  String phone;
  String? diagnosis;
  List<FamilyModel> familyMembers;
  List<DoctorModel> doctors;
  List<TimeSlotModel> timeSlots;

  UserModel({
    this.id = '',
    this.name = '',
    this.email = '',
    this.address = '',
    this.dateOfBirth, // Remove default value
    this.gender = '',
    this.height = '',
    this.weight = '',
    this.phone = '',
    this.diagnosis = '',
    this.familyMembers = const [],
    this.doctors = const [],
    this.timeSlots = const [],
  });
}

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
    final shortNameValue = _getValue(inputs, 'shortName');
    if (shortNameValue.isNotEmpty) shortName = shortNameValue;

    final fullNameValue = _getValue(inputs, 'fullName');
    if (fullNameValue.isNotEmpty) fullName = fullNameValue;

    final relationshipValue = _getValue(inputs, 'relationship');
    if (relationshipValue.isNotEmpty) relationship = relationshipValue;

    final emailValue = _getValue(inputs, 'email');
    if (emailValue.isNotEmpty) email = emailValue;

    final addressValue = _getValue(inputs, 'address');
    if (addressValue.isNotEmpty) address = addressValue;

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

class DoctorModel {
  String id;
  String name;
  String phone;
  String email;
  String address;

  DoctorModel({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.id = '',
  });

  DoctorModel copyWith({
    String? shortName,
    String? fullName,
    String? relationship,
    String? phone,
    String? email,
    String? address,
  }) {
    return DoctorModel(
      id: id,
      name: name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }
}

class TimeSlotModel {
  DateTime startTime;
  DateTime endTime;

  TimeSlotModel({required this.startTime, required this.endTime});
}
