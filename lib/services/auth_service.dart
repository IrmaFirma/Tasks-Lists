import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


abstract class AuthService {
  User get currentUser;

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> createUserWithEmailAndPassword(
      String email, String password);

  Future<void> sendPasswordResetEmail(String email);

  Future<User> signInWithGoogle();

  Future<void> signOut();

  Stream<User> get onAuthStateChanged;

  void dispose();
}
