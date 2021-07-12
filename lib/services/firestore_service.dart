import 'package:books_log/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadBook(Book book, String uid) async {
    await _firestore
        .collection('user')
        .doc(uid)
        .collection('books')
        .add(book.toJson());
  }
}
