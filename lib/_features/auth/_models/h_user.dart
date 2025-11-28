import 'package:flutter/foundation.dart';
import 'package:hemo/_shared/services/models/blood_group.dart';
import 'package:hemo/_shared/services/models/h_user.dart';
import 'package:hemo/_shared/services/models/user_type.dart';

final class HUserProxy extends ChangeNotifier {
  HUserProxy(HUser target) : _target = target;
  HUser _target;

  HUser get target => _target;

  set target(HUser value) {
    _target = target;
    notifyListeners();
  }

  static HUserProxy empty = HUserProxy(HUser.empty());

  /// Updates specific fields of the user and notifies listeners.
  void update({
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
    // Use the copyWith method on the target HUser to create an updated instance
    _target = _target.copyWith(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      userType: userType,
      bloodGroup: bloodGroup,
      canDonate: canDonate,
      photoURL: photoURL,
      emailVerified: emailVerified,
      profileComplete: profileComplete,
    );
    // Notify all listeners that the proxy's data has changed
    notifyListeners();
  }

  String get uid => _target.uid;

  String get name => _target.name;

  String get email => _target.email;

  String? get phoneNumber => _target.phoneNumber;

  UserType get userType => _target.userType;

  BloodGroup get bloodGroup => _target.bloodGroup;

  bool get canDonate => _target.canDonate;

  String? get photoURL => _target.photoURL;

  bool get emailVerified => _target.emailVerified;

  bool get profileComplete => _target.profileComplete;
}
