import 'package:books_log/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadUserProfile(UserProfile userProfile) async {
    await _firestore
        .collection('users')
        .doc(userProfile.uid)
        .set(userProfile.toJson());
  }

  Future<Map<String, dynamic>?> getuserProfile(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(uid).get();
    return snapshot.data();
  }
}
