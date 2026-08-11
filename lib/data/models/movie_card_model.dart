import 'package:markmymovie/core/constants/tmdb_constants.dart';

/// Lightweight search-result shape, parsed from TMDB's /search/multi response.
class MovieCardModel {
  final String tmdbId;
  final String title;
  final String year;
  final String mediaType; // 'movie' or 'tv'
  final String poster;

  MovieCardModel({
    required this.tmdbId,
    required this.title,
    required this.year,
    required this.mediaType,
    required this.poster,
  });

  factory MovieCardModel.fromJson(Map<String, dynamic> json) {
    final mediaType = json['media_type'] as String? ?? 'movie';
    final title = mediaType == 'tv'
        ? (json['name'] as String? ?? '')
        : (json['title'] as String? ?? '');
    final dateStr = mediaType == 'tv'
        ? (json['first_air_date'] as String?)
        : (json['release_date'] as String?);
    final posterPath = json['poster_path'] as String?;

    return MovieCardModel(
      tmdbId: (json['id'] ?? '').toString(),
      title: title,
      year: (dateStr != null && dateStr.length >= 4) ? dateStr.substring(0, 4) : '',
      mediaType: mediaType,
      poster: (posterPath != null && posterPath.isNotEmpty)
          ? '${TmdbConstants.posterImageBase}$posterPath'
          : '',
    );
  }
}
