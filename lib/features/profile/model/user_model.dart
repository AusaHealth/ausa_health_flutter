class UserModel {
  final String name;
  final String email;
  final String address;
  final DateTime dateOfBirth;
  final String gender;
  final String height;
  final String weight;
  final String phone;

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
}
