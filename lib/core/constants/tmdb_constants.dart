class TmdbConstants {
  TmdbConstants._();

  /// TMDB API v4 read-access token (bearer auth).
  static const String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOTBjNTlmOTdiNDI3YTFlYzUzNGU5NTRkNGJjNzBlMiIsIm5iZiI6MTc0MTUzOTMzMy4yODYsInN1YiI6IjY3Y2RjODA1YWQ0ODZiNDNlYmUyZGEyMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o_fj0E0lGjHmklg2fqXFGc36GcwgKjL7Ug8cXqJT0PA';

  static const String baseUrl = 'https://api.themoviedb.org/3';

  static const String imageBase = 'https://image.tmdb.org/t/p';
  static const String posterImageBase = '$imageBase/w500';
  static const String backdropImageBase = '$imageBase/w780';
  static const String profileImageBase = '$imageBase/w185';
  static const String logoImageBase = '$imageBase/w92';

  /// Default region used for watch-provider (OTT) lookups.
  static const String defaultWatchRegion = 'IN';
}
