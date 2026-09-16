import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:markmymovie/core/constants/auth_constants.dart';
import 'package:markmymovie/data/models/user_model.dart';

/// Result of a username availability check.
class UsernameCheck {
  final String username;

  /// False when the string itself is malformed (bad characters, wrong
  /// length, reserved word) — [reason] explains why.
  final bool valid;

  /// False when the name is well-formed but already taken.
  final bool available;
  final String? reason;

  const UsernameCheck({
    required this.username,
    required this.valid,
    required this.available,
    this.reason,
  });

  bool get usable => valid && available;

  factory UsernameCheck.fromJson(Map<String, dynamic> json) {
    return UsernameCheck(
      username: json['username']?.toString() ?? '',
      valid: json['valid'] == true,
      available: json['available'] == true,
      reason: json['reason']?.toString(),
    );
  }
}

class ProfileApiException implements Exception {
  final String message;
  const ProfileApiException(this.message);
  @override
  String toString() => message;
}

/// Talks to the profile endpoints (`/api/user/*`). Public, unauthenticated
/// reads used by the website live under `/api/public/*` and are not needed
/// by the app.
class ProfileApiService {
  ProfileApiService._();

  static final ProfileApiService instance = ProfileApiService._();

  String get _baseUrl => '${AuthConstants.apiBaseUrl}/api/user';

  static const _timeout = Duration(seconds: 20);

  /// Unwraps the backend's `{statusCode, message, body}` envelope,
  /// throwing [ProfileApiException] with the server's own message on
  /// anything that isn't a 200.
  Map<String, dynamic> _unwrap(http.Response response) {
    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ProfileApiException('Unexpected server response');
    }

    final status = decoded['statusCode'];
    final code = status is int ? status : int.tryParse(status.toString()) ?? 0;

    if (code != 200) {
      throw ProfileApiException(
        decoded['message']?.toString() ?? 'Request failed ($code)',
      );
    }
    return decoded;
  }

  Future<http.Response> _post(String path, Map<String, dynamic> body) {
    return http
        .post(
          Uri.parse('$_baseUrl/$path'),
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(_timeout);
  }

  /// The signed-in user's own profile, including private fields.
  Future<UserModel> getProfile(int userId) async {
    final decoded = _unwrap(await _post('getProfile.php', {'userId': userId}));
    return UserModel.fromJson(Map<String, dynamic>.from(decoded['body'] as Map));
  }

  /// Partial update — pass only what changed. Returns the saved profile.
  ///
  /// [profilePicture] accepts an empty string to clear the photo, so it is
  /// distinct from "not supplied"; that's why every parameter is nullable
  /// and only non-null ones are sent.
  Future<UserModel> updateProfile({
    required int userId,
    String? name,
    String? bio,
    String? profilePicture,
    String? bannerImage,
    Map<String, String>? socialLinks,
    bool? isProfilePublic,
  }) async {
    final payload = <String, dynamic>{'userId': userId};

    if (name != null) payload['name'] = name;
    if (bio != null) payload['bio'] = bio;
    if (profilePicture != null) payload['profilePicture'] = profilePicture;
    if (bannerImage != null) payload['bannerImage'] = bannerImage;
    if (socialLinks != null) payload['socialLinks'] = socialLinks;
    if (isProfilePublic != null) payload['isProfilePublic'] = isProfilePublic;

    final decoded = _unwrap(await _post('updateProfile.php', payload));
    return UserModel.fromJson(Map<String, dynamic>.from(decoded['body'] as Map));
  }

  /// Live availability check for the username editor. [userId] excludes
  /// the caller's own row so their current name doesn't read as taken.
  Future<UsernameCheck> checkUsername(String username, {int? userId}) async {
    final decoded = _unwrap(await _post('checkUsername.php', {
      'username': username,
      if (userId != null) 'userId': userId,
    }));
    return UsernameCheck.fromJson(Map<String, dynamic>.from(decoded['body'] as Map));
  }

  /// Returns the saved (normalised, lowercased) username.
  Future<String> updateUsername({
    required int userId,
    required String username,
  }) async {
    final decoded = _unwrap(await _post('updateUsername.php', {
      'userId': userId,
      'username': username,
    }));
    final body = Map<String, dynamic>.from(decoded['body'] as Map);
    return body['username']?.toString() ?? username;
  }
}
