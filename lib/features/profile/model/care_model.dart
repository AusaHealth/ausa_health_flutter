class CareModel {
  final String careProviderName;
  final String phone;
  final String email;
  final String address;
  final String nextAvailability;

  CareModel({
    required this.careProviderName,
    required this.phone,
    required this.email,
    required this.address,
    required this.nextAvailability,
  });
  CareModel copyWith({
    String? careProviderName,
    String? phone,
    String? email,
    String? address,
    String? nextAvailability,
  }) {
    return CareModel(
      careProviderName: careProviderName ?? this.careProviderName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      nextAvailability: nextAvailability ?? this.nextAvailability,
    );
  }
}
