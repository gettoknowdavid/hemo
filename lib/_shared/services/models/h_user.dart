// Need to provide the optional SnapshotOptions argument to
// the fromCloud function.
// ignore_for_file: avoid_unused_constructor_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hemo/_shared/services/models/blood_group.dart';
import 'package:hemo/_shared/services/models/user_type.dart';
import 'package:hemo/_shared/utils/enum_utils.dart';

final class HUser with EquatableMixin {
  const HUser({
    required this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.userType = UserType.recipient,
    this.bloodGroup = BloodGroup.unknown,
    this.canDonate = false,
    this.photoURL,
    this.emailVerified = false,
    this.profileComplete = false,
  });

  factory HUser.empty() => const HUser(uid: '', name: '', email: '');

  factory HUser.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return HUser(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      emailVerified: firebaseUser.emailVerified,
      phoneNumber: firebaseUser.phoneNumber,
    );
  }

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
      phoneNumber: data['phone_number'] as String?,
      userType: $enumDecode($UserTypeEnumMap, data['user_type']),
      bloodGroup: $enumDecode($BloodGroupMap, data['blood_group']),
      canDonate: data['can_donate'] as bool? ?? false,
      photoURL: data['photo_url'] as String?,
      emailVerified: data['email_verified'] as bool? ?? false,
      profileComplete: data['profile_complete'] as bool? ?? false,
    );
  }

  final String uid;
  final String name;
  final String email;
  final String? phoneNumber;
  final UserType userType;
  final BloodGroup bloodGroup;
  final bool canDonate;
  final String? photoURL;
  final bool emailVerified;
  final bool profileComplete;

  Map<String, dynamic> toFirestore() => {
    'uid': uid,
    'name': name,
    'email': email,
    if (phoneNumber != null) 'phone_number': phoneNumber,
    'user_type': userType.name,
    'blood_group': bloodGroup.name,
    'can_donate': canDonate,
    'email_verified': emailVerified,
    'profile_complete': profileComplete,
    if (photoURL != null) 'photo_url': photoURL,
  };

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    phoneNumber,
    userType,
    bloodGroup,
    canDonate,
    photoURL,
    emailVerified,
    profileComplete,
  ];

  /// Creates a new HUser instance with updated fields.
  HUser copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    UserType? userType,
    BloodGroup? bloodGroup,
    bool? canDonate,
    String? photoURL,
    bool? emailVerified,
    bool? profileComplete,
  }) {
    return HUser(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      canDonate: canDonate ?? this.canDonate,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      profileComplete: profileComplete ?? this.profileComplete,
    );
  }
}
