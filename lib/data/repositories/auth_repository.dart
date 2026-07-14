import 'package:markmymovie/core/constants/auth_constants.dart';
import 'package:markmymovie/data/models/user_model.dart';
import 'package:markmymovie/data/services/auth_api_service.dart';
import 'package:markmymovie/data/services/auth_service.dart';
import 'package:markmymovie/data/services/secure_storage_service.dart';

/// Orchestrates the full authentication flow:
///
/// 1. [loginWithGoogle] — triggers Google Sign-In → gets ID token →
///    sends to backend → saves user → returns [UserModel].
/// 2. [logout] — signs out of Google + clears stored session.
/// 3. [getStoredUser] — restores session from secure storage.
/// 4. [isLoggedIn] — quick bool check for routing decisions.
class AuthRepository {
  AuthRepository._();

  static final AuthRepository instance = AuthRepository._();

  final _authService = AuthService.instance;
  final _apiService = AuthApiService.instance;
  final _storage = SecureStorageService.instance;

  /// Performs the full Google Sign-In → backend → persist flow.
  ///
  /// Throws [AuthException] on any failure.
  Future<UserModel> loginWithGoogle() async {
    try {
      print('[AuthRepository] [STEP 1/4] Starting Google Sign-In interactive picker...');
      final googleAccount = await _authService.signIn();
      print('[AuthRepository] [STEP 1/4] Success: User is ${googleAccount.email}');

      print('[AuthRepository] [STEP 2/4] Retrieving Google ID token...');
      final idToken = await _authService.getIdToken(googleAccount);
      print('[AuthRepository] [STEP 2/4] Success: ID Token retrieved (length: ${idToken.length})');

      print('[AuthRepository] [STEP 3/4] Sending ID token to backend at ${AuthConstants.googleLoginEndpoint}...');
      final user = await _apiService.googleLogin(idToken);
      print('[AuthRepository] [STEP 3/4] Success: Backend authenticated user: ${user.name} (email: ${user.email})');

      print('[AuthRepository] [STEP 4/4] Saving user session locally...');
      await _storage.saveUser(user);
      print('[AuthRepository] [STEP 4/4] Success: Session saved. Login complete!');

      return user;
    } on AuthException catch (e) {
      print('[AuthRepository] [ERROR] AuthException occurred:');
      print('  Type: ${e.type}');
      print('  Message: ${e.message}');
      print('  UserMessage: ${e.userMessage}');
      rethrow;
    } catch (e, stackTrace) {
      print('[AuthRepository] [ERROR] Unexpected exception during login flow: $e');
      print(stackTrace);
      rethrow;
    }
  }

  /// Signs out the user — clears Google session and local storage.
  Future<void> logout() async {
    await Future.wait([
      _authService.signOut(),
      _storage.deleteUser(),
    ]);
  }

  /// Returns the stored [UserModel] or `null` if not authenticated.
  Future<UserModel?> getStoredUser() => _storage.getUser();

  /// Returns `true` if a valid user session is stored locally.
  Future<bool> isLoggedIn() => _storage.hasUser();
}
