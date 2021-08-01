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

  Stream<QuerySnapshot> myBooksStream(String uid) async* {
    yield* _firestore
        .collection('user')
        .doc(uid)
        .collection('books')
        .orderBy('dateAdded', descending: true)
        .snapshots();
  }

  Future<void> uploadToReadingList(Book book, String uid) async {
    await _firestore
        .collection('user')
        .doc(uid)
        .collection('readingList')
        .add(book.toJson());
  }

  Stream<QuerySnapshot> readingListStream(String uid) async* {
    yield* _firestore
        .collection('user')
        .doc(uid)
        .collection('readingList')
        .orderBy('dateAdded', descending: false)
        .snapshots();
  }

  Future<void> removeFromReadingList(String uid, String documentId) async {
    await _firestore
        .collection('user')
        .doc(uid)
        .collection('readingList')
        .doc(documentId)
        .delete();
  }

  Future<void> removeFromMyBooks(String uid, String documentId) async {
    await _firestore
        .collection('user')
        .doc(uid)
        .collection('books')
        .doc(documentId)
        .delete();
  }

  Future<void> updateBookReview(
      String uid, String documentId, String review) async {
    await _firestore
        .collection('user')
        .doc('uid')
        .collection('books')
        .doc(documentId)
        .update({'review': review});
  }
}
