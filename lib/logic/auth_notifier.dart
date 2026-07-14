import 'package:flutter/foundation.dart';
import 'package:markmymovie/data/models/user_model.dart';
import 'package:markmymovie/data/repositories/auth_repository.dart';
import 'package:markmymovie/data/services/auth_service.dart';

/// Authentication status enum.
enum AuthStatus {
  /// Initial state — checking stored session.
  unknown,

  /// User is authenticated and a valid [UserModel] is loaded.
  authenticated,

  /// No session found — user must log in.
  unauthenticated,

  /// A sign-in operation is in progress.
  loading,

  /// An error occurred during sign-in.
  error,
}

/// [ChangeNotifier] that manages authentication state throughout the app.
///
/// Usage:
/// ```dart
/// final notifier = AuthNotifier();
/// await notifier.checkSession();   // on app start
/// await notifier.login();          // on button press
/// await notifier.logout();         // from settings
/// ```
class AuthNotifier extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;
  UserModel? _user;
  String? _errorMessage;

  final _repo = AuthRepository.instance;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // ── Session check on app startup ──────────────────────────────────────────

  /// Checks secure storage for an existing session.
  ///
  /// Called once from [SplashScreen] during app initialisation.
  Future<void> checkSession() async {
    _setStatus(AuthStatus.unknown);
    try {
      final storedUser = await _repo.getStoredUser();
      if (storedUser != null) {
        _user = storedUser;
        _setStatus(AuthStatus.authenticated);
      } else {
        _setStatus(AuthStatus.unauthenticated);
      }
    } catch (_) {
      _setStatus(AuthStatus.unauthenticated);
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────────

  /// Triggers the Google Sign-In flow and communicates with the backend.
  ///
  /// Returns `true` on success, `false` on failure (error message is set).
  Future<bool> login() async {
    _clearError();
    _setStatus(AuthStatus.loading);
    try {
      final user = await _repo.loginWithGoogle();
      _user = user;
      _setStatus(AuthStatus.authenticated);
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.userMessage;
      _setStatus(AuthStatus.error);
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _setStatus(AuthStatus.error);
      return false;
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  /// Signs out the user and clears all session data.
  Future<void> logout() async {
    try {
      await _repo.logout();
    } catch (_) {
      // Best-effort logout
    } finally {
      _user = null;
      _setStatus(AuthStatus.unauthenticated);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Returns the stored [UserModel] without changing auth state.
  ///
  /// Convenience for screens that just need to read the current user
  /// without triggering a full session check.
  Future<UserModel?> getStoredUser() => _repo.getStoredUser();

  /// Clears the error state — call after showing the error to the user.
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _setStatus(AuthStatus.unauthenticated);
    }
  }
}
