import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:markmymovie/core/constants/auth_constants.dart';
import 'package:markmymovie/data/models/user_model.dart';
import 'package:markmymovie/data/services/auth_service.dart';

/// Handles all HTTP communication with the Watchstash auth backend.
class AuthApiService {
  AuthApiService._();

  static final AuthApiService instance = AuthApiService._();

  /// Sends the Google [idToken] to the backend and returns a [UserModel]
  /// on success.
  ///
  /// ```
  /// POST /api/auth/google_login.php
  /// { "id_token": "<Google ID Token>" }
  /// ```
  ///
  /// Expected success response:
  /// ```json
  /// {
  ///   "statusCode": 200,
  ///   "message": "Login Successful",
  ///   "body": { ... UserModel fields ... }
  /// }
  /// ```
  Future<UserModel> googleLogin(String idToken) async {
    try {
      print('[AuthApiService] Sending POST request to backend...');
      print('[AuthApiService] Endpoint: ${AuthConstants.googleLoginEndpoint}');
      
      final response = await http
          .post(
            Uri.parse(AuthConstants.googleLoginEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'id_token': idToken}),
          )
          .timeout(const Duration(seconds: 20));

      print('[AuthApiService] HTTP Response Status Code: ${response.statusCode}');
      print('[AuthApiService] HTTP Response Raw Body: ${response.body}');

      final body = _parseBody(response.body);

      if (response.statusCode == 200) {
        final statusCode = body['statusCode'];
        if (statusCode == 200 || statusCode == '200') {
          final userJson = body['body'] as Map<String, dynamic>;
          print('[AuthApiService] Successful parsing of user: ${userJson['name']} (${userJson['email']})');
          return UserModel.fromJson(userJson);
        }
        print('[AuthApiService] Backend logically failed. statusCode inside JSON: $statusCode. Message: ${body['message']}');
        throw AuthException(
          AuthErrorType.serverUnavailable,
          'Server returned status: $statusCode — ${body['message']}',
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print('[AuthApiService] Backend returned unauthorized status code: ${response.statusCode}');
        throw AuthException(
          AuthErrorType.invalidAccount,
          'Account not authorised (HTTP ${response.statusCode})',
        );
      } else if (response.statusCode >= 500) {
        print('[AuthApiService] Backend server error status code: ${response.statusCode}');
        throw AuthException(
          AuthErrorType.serverUnavailable,
          'Server error (HTTP ${response.statusCode})',
        );
      } else {
        print('[AuthApiService] Backend returned unexpected status code: ${response.statusCode}');
        throw AuthException(
          AuthErrorType.unexpected,
          'Unexpected HTTP ${response.statusCode}: ${response.body}',
        );
      }
    } on AuthException {
      rethrow;
    } on SocketException catch (e) {
      print('[AuthApiService] SocketException (Network issues/offline): $e');
      throw AuthException(
        AuthErrorType.noInternet,
        'No internet connection.',
      );
    } on HttpException catch (e) {
      print('[AuthApiService] HttpException: $e');
      throw AuthException(
        AuthErrorType.serverUnavailable,
        'Could not reach the server.',
      );
    } catch (e, stackTrace) {
      print('[AuthApiService] Unexpected error during API call: $e');
      print(stackTrace);
      throw AuthException(
        AuthErrorType.unexpected,
        'Unexpected error during login: ${e.toString()}',
      );
    }
  }

  Map<String, dynamic> _parseBody(String rawBody) {
    try {
      return jsonDecode(rawBody) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}
