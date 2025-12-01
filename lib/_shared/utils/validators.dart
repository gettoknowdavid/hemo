import 'dart:io';

import 'package:hemo/_shared/services/models/blood_group.dart';

final class HValidators {
  const HValidators._();

  static String? name(String? input) {
    if (input == null || input.isEmpty) return 'Name is required';
    return null;
  }

  static String? required(String? input, [String? fieldName]) {
    if (input == null || input.isEmpty) {
      if (fieldName == null) return 'This field is required';
      return '$fieldName is required';
    }
    return null;
  }

  static String? maxLengthExceeded(String? input) {
    if (input == null) return null;
    if (input.length > 255) return 'Maximum length (255) exceeded';
    return null;
  }

  static String? bloodGroup(BloodGroup? input) {
    if (input == null || input.isUnknown) return 'Blood Group is required';
    return null;
  }

  static String? email(String? input) {
    if (input == null || input.isEmpty) return 'Email is required';

    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(input)) return 'Invalid email address';
    return null;
  }

  static String? phoneNumber(String? input) {
    if (input == null || input.isEmpty) return 'Mobile Number is required';
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

  static String? imageFile(File? input) {
    if (input == null) return null;
    if (!input.existsSync()) return 'File not found';
    if (input.lengthSync() > 5 * 1024 * 1024) return 'File size exceeds 5 MB';
    return null;
  }
}
