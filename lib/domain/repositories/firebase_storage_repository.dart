import 'dart:io';

abstract class FirebaseStorageRepository {
  Future<void> uploadFile(File file, String remotePath);
  Future<String?> downloadFile(String storagePath);
  Future<void> deleteFile(String storagePath);
}
