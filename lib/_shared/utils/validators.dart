final class HValidators {
  const HValidators._();

  static String? name(String? input) {
    if (input == null || input.isEmpty) return 'Name is required';
    return null;
  }

  static String? email(String? input) {
    if (input == null || input.isEmpty) return 'Email is required';

    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(input)) return 'Invalid email address';
    return null;
  }

  static String? signInPassword(String? input) {
    if (input == null || input.isEmpty) return 'Password is required';
    return null;
  }

  static String? signUpPassword(String? input) {
    if (input == null || input.isEmpty) return 'Password is required';
    if (input.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
