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

  String get uid => _target.uid;

  String get name => _target.name;

  String get email => _target.email;

  UserType get userType => _target.userType;

  BloodGroup get bloodGroup => _target.bloodGroup;

  bool get canDonate => _target.canDonate;

  String? get photoURL => _target.photoURL;
}
