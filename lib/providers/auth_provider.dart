import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoggedIn = false;
  ZUser? _currentUser;
  bool _isLoading = true;

  bool get isLoggedIn => _isLoggedIn;
  ZUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _authService.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser != null) {
        // Try to load existing profile or create one
        ZUser? profile =
            await _firestoreService.getUserProfile(firebaseUser.uid);
        if (profile == null) {
          final displayName = firebaseUser.displayName ?? 'User';
          final email = firebaseUser.email ?? '';
          final parts = displayName.split(' ');
          final initials =
              parts.map((p) => p.isNotEmpty ? p[0] : '').take(2).join();
          profile = ZUser(
            id: firebaseUser.uid,
            name: displayName,
            email: email,
            phone: '',
            avatarInitials: initials.isEmpty && email.isNotEmpty
                ? email[0].toUpperCase()
                : initials.isNotEmpty
                    ? initials
                    : '?',
          );
          await _firestoreService.saveUserProfile(firebaseUser.uid, profile);
        }
        _currentUser = profile;
        _isLoggedIn = true;
      } else {
        _currentUser = null;
        _isLoggedIn = false;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<String?> login(String email, String password) async {
    try {
      await _authService.signInWithEmail(email, password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      await _authService.signUpWithEmail(email, password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthError(e);
    } catch (e) {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
