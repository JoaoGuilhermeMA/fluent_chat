import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password);

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password);

  Future<void> resetPassword(String email);

  Future<void> signOut();

  String? getCurrentUserEmail();

  Future<void> signInAnonymously();
}
