import 'package:flutter/foundation.dart';
import 'package:hemo/_shared/services/remote/firebase_auth_service.dart';
import 'package:hemo/_shared/services/remote/firebase_firestore_service.dart';

final class ProfileManager extends ChangeNotifier {
  ProfileManager({
    required FirebaseFirestoreService store,
    required FirebaseAuthService auth,
  }) : _store = store,
       _auth = auth;

  final FirebaseFirestoreService _store;
  final FirebaseAuthService _auth;
}
