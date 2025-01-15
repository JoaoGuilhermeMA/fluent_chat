import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadFile(File file, String remotePath) async {
    try {
      // Upload do arquivo
      await _firebaseStorage.ref(remotePath).putFile(file);
    } catch (e) {
      print('Erro no upload: $e');
    }
  }

  Future<String?> downloadFile(String storagePath) async {
    try {
      return await _firebaseStorage.ref(storagePath).getDownloadURL();
    } catch (e) {
      print('Erro ao obter URL: $e');
    }
    return null;
  }

  Future<void> deleteFile(String storagePath) async {
    try {
      await _firebaseStorage.ref(storagePath).delete();
    } catch (e) {
      print('Erro ao deletar arquivo: $e');
    }
  }
}
