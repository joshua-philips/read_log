import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfilePhoto(File image) async {
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    TaskSnapshot taskSnapshot =
        _storage.ref().child(imageFileName).putFile(image).snapshot;

    return await taskSnapshot.ref.getDownloadURL();
  }
}
