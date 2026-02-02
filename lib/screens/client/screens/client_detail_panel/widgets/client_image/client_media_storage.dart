import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class ClientMediaStorage {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadBytes({
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final ref = _storage.ref().child(path);
    await ref.putData(
      bytes,
      SettableMetadata(contentType: contentType),
    );
    return ref.getDownloadURL();
  }

  Future<void> deletePath(String path) async {
    if (path.trim().isEmpty) return;
    await _storage.ref().child(path).delete();
  }
}
