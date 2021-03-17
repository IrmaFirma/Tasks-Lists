import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'auth_service.dart';
import 'firebase_auth_service.dart';

enum AuthServiceType { firebase, mock }

class AuthServiceAdapter implements AuthService {
  AuthServiceAdapter({@required AuthServiceType initialAuthServiceType})
      : authServiceTypeNotifier =
            ValueNotifier<AuthServiceType>(initialAuthServiceType) {
    _setup();
  }

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  // Value notifier used to switch between [FirebaseAuthService] and [MockAuthService]
  final ValueNotifier<AuthServiceType> authServiceTypeNotifier;

  AuthServiceType get authServiceType => authServiceTypeNotifier.value;

  AuthService get authService => _firebaseAuthService;


  StreamSubscription<User> _firebaseAuthSubscription;

  void _setup() {
    // Observable<User>.merge was considered here, but we need more fine grained control to ensure
    // that only events from the currently active service are processed
    _firebaseAuthSubscription =
        _firebaseAuthService.onAuthStateChanged.listen((User user) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.add(user);
      }
    }, onError: (dynamic error) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.addError(error);
      }
    });
  }

  @override
  void dispose() {
    _firebaseAuthSubscription?.cancel();
    _onAuthStateChangedController?.close();
    authServiceTypeNotifier.dispose();
  }

  final StreamController<User> _onAuthStateChangedController =
      StreamController<User>.broadcast();

  @override
  Stream<User> get onAuthStateChanged =>
      _onAuthStateChangedController.stream;

  User get currentUser => authService.currentUser;

  @override
  Future<User> createUserWithEmailAndPassword(
          String email, String password) =>
      authService.createUserWithEmailAndPassword(email, password);

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) =>
      authService.signInWithEmailAndPassword(email, password);

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      authService.sendPasswordResetEmail(email);

  @override
  Future<User> signInWithGoogle() => authService.signInWithGoogle();

  @override
  Future<void> signOut() => authService.signOut();
}
