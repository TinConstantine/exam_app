class CommonValidator {
  static bool isValidEmail(String? value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(value!);
  }

  static bool isValidPhoneNumber(String? value) {
    final phoneRegex = RegExp(r'^\d{10,}$');
    return phoneRegex.hasMatch(value!);
  }
}
