import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_chat/data/service/auth_service.dart';
import 'package:fluent_chat/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  String? getCurrentUserEmail() {
    return _authService.getCurrentUserEmail();
  }

  @override
  Future<void> resetPassword(String email) async {
    _authService.resetPassword(email);
  }

  @override
  Future<void> signInAnonymously() async {
    _authService.signInAnonymously();
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) {
    return _authService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signOut() async {
    _authService.signOut();
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) {
    return _authService.signUpWithEmailAndPassword(email, password);
  }
}
