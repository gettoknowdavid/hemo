// Need to provide the optional SnapshotOptions argument to
// the fromCloud function.
// ignore_for_file: avoid_unused_constructor_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hemo/_shared/services/models/blood_group.dart';
import 'package:hemo/_shared/services/models/gender.dart';
import 'package:hemo/_shared/utils/enum_utils.dart';

final class HProfile with EquatableMixin {
  const HProfile({
    required this.name,
    required this.phoneNumber,
    required this.bloodGroup,
    required this.country,
    required this.city,
    this.dateOfBirth,
    this.age,
    this.gender,
    this.iWantToDonate = false,
    this.bio,
    this.photoURL,
  });

  factory HProfile.empty() => const HProfile(
    name: '',
    phoneNumber: '',
    bloodGroup: BloodGroup.unknown,
    country: '',
    city: '',
  );

  factory HProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) throw Exception('Document does not exist');

    return HProfile(
      name: data['name'] as String? ?? '',
      phoneNumber: data['phone_number'] as String? ?? '',
      bloodGroup: $enumDecode($BloodGroupMap, data['blood_group']),
      country: data['country'] as String? ?? '',
      city: data['city'] as String? ?? '',
      dateOfBirth: data['date_of_birth'] as DateTime?,
      age: data['age'] as int?,
      gender: $enumDecode($GenderMap, data['gender']),
      iWantToDonate: data['i_want_to_donate'] as bool? ?? false,
      bio: data['bio'] as String?,
      photoURL: data['photo_url'] as String?,
    );
  }

  final String name;
  final String phoneNumber;
  final BloodGroup bloodGroup;
  final String country;
  final String city;
  final DateTime? dateOfBirth;
  final int? age;
  final Gender? gender;
  final bool iWantToDonate;
  final String? bio;
  final String? photoURL;

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'phone_number': phoneNumber,
    'blood_group': bloodGroup.name,
    'country': country,
    'city': city,
    if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
    if (age != null) 'age': age,
    if (gender != null) 'gender': gender?.name,
    'i_want_to_donate': iWantToDonate,
    if (bio != null) 'bio': bio,
    if (photoURL != null) 'photo_url': photoURL,
  };

  @override
  List<Object?> get props => [
    name,
    phoneNumber,
    bloodGroup,
    country,
    city,
    dateOfBirth,
    age,
    gender,
    iWantToDonate,
    bio,
    photoURL,
  ];
}
