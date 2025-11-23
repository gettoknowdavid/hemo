import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_shared/services/models/blood_group.dart';
import 'package:hemo/_shared/services/models/gender.dart';

final class PersonalInfoFormManager {
  final name = ValueNotifier<String>('');
  final phoneNumber = ValueNotifier<String>('');
  final bloodGroup = ValueNotifier<BloodGroup>(BloodGroup.unknown);
  final country = ValueNotifier<String>('');
  final city = ValueNotifier<String>('');
  final dateOfBirth = ValueNotifier<DateTime?>(null);
  final age = ValueNotifier<int?>(null);
  final gender = ValueNotifier<Gender?>(null);
  final iWantToDonate = ValueNotifier<bool>(false);
  final bio = ValueNotifier<String?>(null);

  late final ValueListenable<bool> isValid = name.combineLatest6(
    phoneNumber,
    bloodGroup,
    country,
    city,
    bio,
    (name, phoneNumber, bloodGroup, country, city, bio) {
      final nameValid = name.isNotEmpty;
      final phoneNumberValid = phoneNumber.isNotEmpty;
      final bloodGroupValid = bloodGroup != BloodGroup.unknown;
      final countryValid = country.isNotEmpty;
      final cityValid = city.isNotEmpty;
      final bioValid = bio == null || bio.length < 250;

      return nameValid &&
          phoneNumberValid &&
          bloodGroupValid &&
          countryValid &&
          cityValid &&
          bioValid;
    },
  );
}
