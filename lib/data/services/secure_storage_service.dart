import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:markmymovie/core/constants/auth_constants.dart';
import 'package:markmymovie/data/models/user_model.dart';

/// Encrypted local storage for persisting the authenticated user session.
///
/// Uses [FlutterSecureStorage] which is backed by Android Keystore /
/// iOS Keychain, so the data survives app restarts but is wiped on
/// app uninstall.
class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService instance = SecureStorageService._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Saves [user] to secure storage.
  Future<void> saveUser(UserModel user) async {
    await _storage.write(
      key: AuthConstants.userStorageKey,
      value: user.toJsonString(),
    );
  }

  /// Reads and deserialises the stored [UserModel], or returns `null`.
  Future<UserModel?> getUser() async {
    final jsonString = await _storage.read(key: AuthConstants.userStorageKey);
    if (jsonString == null) return null;
    return UserModel.fromJsonString(jsonString);
  }

  /// Removes the stored user from secure storage.
  Future<void> deleteUser() async {
    await _storage.delete(key: AuthConstants.userStorageKey);
  }

  /// Whether a user is currently stored.
  Future<bool> hasUser() async {
    final user = await getUser();
    return user != null;
  }
}
