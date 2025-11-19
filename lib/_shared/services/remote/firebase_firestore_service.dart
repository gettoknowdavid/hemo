import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hemo/_shared/services/models/h_user.dart';

final class FirebaseFirestoreService {
  const FirebaseFirestoreService({
    required FirebaseFirestore store,
  }) : _store = store;

  final FirebaseFirestore _store;

  Future<void> createUser(HUser user) async {
    await _store.collection('user').doc(user.uid).set(user.toFirstore());
  }

  Future<HUser> getUser(String uid) async {
    final doc = await _store.doc(uid).get();
    return HUser.fromFirestore(doc, null);
  }
}
