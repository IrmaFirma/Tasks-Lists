import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/services/auth_service.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});

  final AuthService auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _register(Future<User> Function() registerMethod) async {
    try {
      isLoading.value = true;
      return await registerMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    return await _register(auth.signInWithGoogle);
  }
}
