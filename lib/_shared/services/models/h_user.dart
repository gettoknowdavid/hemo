// Need to provide the optional SnapshotOptions argument to
// the fromCloud function.
// ignore_for_file: avoid_unused_constructor_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hemo/_shared/services/models/blood_group.dart';
import 'package:hemo/_shared/services/models/user_type.dart';
import 'package:hemo/_shared/utils/enum_utils.dart';

final class HUser with EquatableMixin {
  const HUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.userType,
    this.bloodGroup = BloodGroup.unknown,
    this.isDonorEligible = false,
    this.photoURL,
  });

  factory HUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) throw Exception('Document does not exist');
    return HUser(
      uid: data['uid'] as String? ?? snapshot.id,
      name: data['name'] as String? ?? 'Unknown User',
      email: data['email'] as String? ?? '',
      userType: $enumDecode($UserTypeEnumMap, data['user_type']),
      bloodGroup: $enumDecode($BloodGroupMap, data['blood_group']),
      isDonorEligible: data['is_donor_eligible'] as bool? ?? false,
      photoURL: data['photo_url'] as String?,
    );
  }

  final String uid;
  final String name;
  final String email;
  final UserType userType;
  final BloodGroup bloodGroup;
  final bool isDonorEligible;
  final String? photoURL;

  Map<String, dynamic> toFirstore() => {
    'uid': uid,
    'name': name,
    'email': email,
    'user_type': userType.name,
    'blood_group': bloodGroup.name,
    'is_donor_eligible': isDonorEligible,
    if (photoURL != null) 'photo_url': photoURL,
  };

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    userType,
    bloodGroup,
    isDonorEligible,
    photoURL,
  ];
}
