class AuthConstants {
  AuthConstants._();

  static const String googleWebClientId =
      '117412405894-0ljpj1orkm96telg1msb3b2a37tgr7rj.apps.googleusercontent.com';

  static const String apiBaseUrl = 'https://tworingz.com/markmymovie';

  static const String googleLoginEndpoint =
      '$apiBaseUrl/api/google_login.php';

  static const String userStorageKey = 'mmm_auth_user';
}
