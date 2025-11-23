import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hemo/_features/profile/_models/h_profile.dart';
import 'package:hemo/_shared/services/models/h_user.dart';

final class FirebaseFirestoreService {
  const FirebaseFirestoreService(FirebaseFirestore store) : _store = store;

  final FirebaseFirestore _store;

  Future<void> createUser(HUser user) async {
    await _store.collection('users').doc(user.uid).set(user.toFirestore());
  }

  Future<void> updateUser(HUser user) async {
    await _store.collection('users').doc(user.uid).update(user.toFirestore());
  }

  Future<HUser> getUser(String uid) async {
    final doc = await _store.collection('users').doc(uid).get();
    return HUser.fromFirestore(doc, null);
  }

  Future<void> createUserProfile(String userUid, HProfile profile) async {
    final userRef = _store.collection('users').doc(userUid);
    final profileRef = userRef.collection('profiles').doc(userUid);
    await profileRef.set(profile.toFirestore());
  }

  Future<void> updateUserProfile(String userUid, HProfile profile) async {
    final userRef = _store.collection('users').doc(userUid);
    final profileRef = userRef.collection('profiles').doc(userUid);
    await profileRef.update(profile.toFirestore());
  }
}
