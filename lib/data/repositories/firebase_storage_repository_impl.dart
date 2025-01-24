import 'dart:io';

import 'package:fluent_chat/data/service/firebase_storage_service.dart';
import 'package:fluent_chat/domain/repositories/firebase_storage_repository.dart';

class FirebaseStorageRepositoryImpl extends FirebaseStorageRepository {
  FirebaseStorageService _firebaseStorageService;

  FirebaseStorageRepositoryImpl(this._firebaseStorageService);

  @override
  Future<void> deleteFile(String storagePath) async {
    _firebaseStorageService.deleteFile(storagePath);
  }

  @override
  Future<String?> downloadFile(String storagePath) {
    return _firebaseStorageService.downloadFile(storagePath);
  }

  @override
  Future<void> uploadFile(File file, String remotePath) async {
    _firebaseStorageService.uploadFile(file, remotePath);
  }
}
