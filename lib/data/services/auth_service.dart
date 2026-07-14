import 'package:google_sign_in/google_sign_in.dart';
import 'package:markmymovie/core/constants/auth_constants.dart';

/// Thin wrapper around the `google_sign_in` package.
///
/// Provides [signIn], [signOut], and [silentSignIn].
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: AuthConstants.googleWebClientId,
  );

  /// Triggers the interactive Google account picker.
  ///
  /// Returns the signed-in [GoogleSignInAccount] or throws an
  /// [AuthException] on failure / cancellation.
  Future<GoogleSignInAccount> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        print('[AuthService] Sign-in cancelled: user dismissed the dialog.');
        throw AuthException(
          AuthErrorType.cancelled,
          'Sign in was cancelled by the user.',
        );
      }
      return account;
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      print('[AuthService] Google Sign-In SDK error: $e');
      print(stackTrace);
      throw AuthException(
        AuthErrorType.googleFailed,
        'Google Sign-In failed: ${e.toString()}',
      );
    }
  }

  /// Attempts a silent (no-UI) sign-in to restore a previous session.
  ///
  /// Returns the account or `null` if not previously signed in.
  Future<GoogleSignInAccount?> silentSignIn() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (e) {
      print('[AuthService] Silent Sign-In failed: $e');
      return null;
    }
  }

  /// Retrieves the ID token from the current Google account.
  Future<String> getIdToken(GoogleSignInAccount account) async {
    try {
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        print('[AuthService] Error: retrieved ID token was null or empty.');
        throw AuthException(
          AuthErrorType.googleFailed,
          'Failed to obtain Google ID token. '
          'Make sure the Web Client ID is correctly configured.',
        );
      }
      return idToken;
    } on AuthException {
      rethrow;
    } catch (e, stackTrace) {
      print('[AuthService] Failed to get authentication / ID Token: $e');
      print(stackTrace);
      throw AuthException(
        AuthErrorType.googleFailed,
        'Could not retrieve Google ID token: ${e.toString()}',
      );
    }
  }

  /// Signs the user out of Google and revokes app access.
  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (_) {
      // Best-effort sign-out; ignore errors
    }
  }

  /// Whether a user is currently signed in with Google.
  Future<bool> isSignedIn() async {
    return _googleSignIn.isSignedIn();
  }
}

// ── Auth Exception ─────────────────────────────────────────────────────────

enum AuthErrorType {
  cancelled,
  noInternet,
  googleFailed,
  serverUnavailable,
  invalidAccount,
  unexpected,
}

class AuthException implements Exception {
  final AuthErrorType type;
  final String message;

  const AuthException(this.type, this.message);

  /// Returns a user-friendly message suitable for display in a Snackbar/Dialog.
  String get userMessage {
    switch (type) {
      case AuthErrorType.cancelled:
        return 'Sign in was cancelled.';
      case AuthErrorType.noInternet:
        return 'No internet connection. Please check your network and try again.';
      case AuthErrorType.googleFailed:
        return 'Google authentication failed. Please try again.';
      case AuthErrorType.serverUnavailable:
        return 'Server is currently unavailable. Please try again later.';
      case AuthErrorType.invalidAccount:
        return 'This account is not valid. Please try a different account.';
      case AuthErrorType.unexpected:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  @override
  String toString() => 'AuthException(${type.name}): $message';
}
