class Helpers {
  static List<String> relationshipOptions = [
    'Spouse',
    'Child',
    'Grandchild',
    'Parent',
    'Friend',
    'Other',
  ];
  static List<String> genderOptions = ['Male', 'Female', 'Other'];
  static bool isPhoneNumberValid(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length == 10;
  }

  static String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 10) return phone;
    final area = digits.substring(digits.length - 10, digits.length - 7);
    final prefix = digits.substring(digits.length - 7, digits.length - 4);
    final line = digits.substring(digits.length - 4);
    return '+1 ($area) $prefix - $line';
  }

  static String? emptyToNull(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    );
    return emailRegex.hasMatch(email);
  }
}
