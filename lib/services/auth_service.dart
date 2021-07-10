import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get onAuthStateChanged => _firebaseAuth.idTokenChanges();

  String getCurrentUID() {
    return _firebaseAuth.currentUser!.uid;
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String name, String profilePhoto) async {
    final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await currentUser.user!.updateDisplayName(name);
    await currentUser.user!.updatePhotoURL(profilePhoto);
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
