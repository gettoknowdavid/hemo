import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_features/auth/_models/h_user.dart';
import 'package:hemo/_shared/services/csc/csc.dart';
import 'package:hemo/_shared/services/models/blood_group.dart';
import 'package:hemo/_shared/services/models/gender.dart';
import 'package:hemo/_shared/services/models/h_scope.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:logging/logging.dart';

final class ProfileSetupManager implements Disposable {
  ProfileSetupManager({
    required HUserProxy user,
    required FirebaseFirestore store,
  }) : _user = user,
       _store = store;

  final HUserProxy _user;
  final FirebaseFirestore _store;

  final _log = Logger('PROFILE_SETUP_MANAGER');

  final name = ValueNotifier<String>('');
  final phoneNumber = ValueNotifier<String>('');
  final bloodGroup = ValueNotifier<BloodGroup?>(null);
  final country = ValueNotifier<Country?>(null);
  final province = ValueNotifier<Province?>(null);
  final city = ValueNotifier<City?>(null);

  final dateOfBirth = ValueNotifier<DateTime?>(null);
  final age = ValueNotifier<int?>(null);
  final gender = ValueNotifier<Gender?>(null);
  final iWantToDonate = ValueNotifier<bool?>(false);
  final bio = ValueNotifier<String?>(null);
  final image = ValueNotifier<File?>(null);

  void onNameChanged(String input) => name.value = input;

  void onBloodChanged(BloodGroup? input) => bloodGroup.value = input;

  void onCountryChanged(Country? input) {
    if (input == null) return;
    if (input == country.value) return;
    country.value = input;
    province.value = null; // Clear the state
    city.value = null; // Clear the city
  }

  void onProvinceChanged(Province? input) {
    if (input == null) return;
    if (input == province.value) return;
    province.value = input;
    city.value = null; // Clear the city
  }

  void onCityChanged(City? input) {
    if (input == null) return;
    if (input == city.value) return;
    city.value = input;
  }

  void onPhoneNumberChanged(PhoneNumber input) {
    final completePhoneNumber = input.phoneNumber;
    if (completePhoneNumber == null || completePhoneNumber.isEmpty) return;
    phoneNumber.value = completePhoneNumber;
  }

  void onDateOfBirthChanged(DateTime? input) {
    dateOfBirth.value = input;
    age.value = input == null ? null : DateTime.now().year - input.year;
  }

  void onGenderChanged(Gender? input) => gender.value = input;

  void onIWantToDonateChanged(bool? input) => iWantToDonate.value = input;

  void onBioChanged(String? input) => bio.value = input;

  void onImageChanged(File? input) => image.value = input;

  void printState() {
    _log.info('''
      name: ${name.value},
      phoneNumber: ${phoneNumber.value},
      bloodGroup: ${bloodGroup.value},
      country: ${country.value},
      province: ${province.value},
      city: ${city.value},
      ###########################################
      dateOfBirth: ${dateOfBirth.value},
      age: ${age.value},
      gender: ${gender.value},
      iWantToDonate: ${iWantToDonate.value},
      bio: ${bio.value},
      ###########################################
      image: ${image.value},
      ''');
    _log.info('IS VALID ::: $isValid');
  }

  late final ValueListenable<bool> isValid = name.combineLatest6(
    phoneNumber,
    bloodGroup,
    country,
    province,
    city,
    (name, phoneNumber, bloodGroup, country, province, city) =>
        name.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        bloodGroup != null &&
        country != null &&
        province != null &&
        city != null,
  );

  late final Command<void, bool> submit = .createAsyncNoParam(
    () async {
      final userUid = _user.uid;
      final userRef = _store.collection('users').doc(userUid);

      final profileRef = userRef.collection('profiles').doc(userUid);
      await profileRef.set({
        'name': name.value,
        'phone_number': phoneNumber.value,
        'blood_group': bloodGroup.value!.name,
        'country': country.value!.name,
        'province': province.value!.name,
        'city': city.value!.name,
        if (dateOfBirth.value != null) 'date_of_birth': dateOfBirth.value,
        if (age.value != null) 'age': age.value,
        if (gender.value != null) 'gender': gender.value!.name,
        'i_want_to_donate': iWantToDonate.value,
        if (bio.value != null) 'bio': bio.value,
        if (image.value != null) 'photo_url': image.value!.path,
      });

      await userRef.update({
        'name': name.value,
        'phone_number': phoneNumber.value,
        'blood_group': bloodGroup.value!.name,
        'country': country.value!.name,
        'profile_complete': true,
      });

      if (di.hasScope(HScope.authenticated)) {
        await di.dropScope(HScope.authenticated);
      }

      di.pushNewScope(scopeName: HScope.authenticated);
      _user.update(profileComplete: true);
      di.registerSingleton<HUserProxy>(_user);

      return true;
    },
    initialValue: false,
  );

  @override
  FutureOr<dynamic> onDispose() {
    name.dispose();
    phoneNumber.dispose();
    bloodGroup.dispose();
    country.dispose();
    province.dispose();
    city.dispose();
    dateOfBirth.dispose();
    age.dispose();
    gender.dispose();
    iWantToDonate.dispose();
    bio.dispose();
    image.dispose();

    submit.dispose();
  }
}
