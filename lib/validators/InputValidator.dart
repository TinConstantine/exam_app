class InputValidator {
  static String? isValidEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email or phone number';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final phoneRegex = RegExp(r'^\d{10,}$');

    if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
      return 'Please enter gmail or phone number.';
    }
    return null;
  }
}
