import 'dart:math';

import 'package:markmymovie/core/constants/tmdb_constants.dart';
import 'package:markmymovie/data/models/cast_member_model.dart';
import 'package:markmymovie/data/models/watch_provider_model.dart';

class MovieModel {
  String id; // unique 12-character alphanumeric ID
  int? serverMovieId;

  late String title;
  late String originalTitle;
  late String plotOverview;

  late String type; // "movie" or "show"
  late int year;

  late String imdbId;
  late String tmdbType; // TMDB media type: "movie" or "tv"

  late List<String> genreNames;

  late double userRating;
  late String poster;
  late String originalLanguage;

  String? trailer;
  String? trailerThumbnail;
  late String folderId;
  DateTime modifiedTime = DateTime.now();
  bool isWatch = false;

  // ── Transient (not persisted) — fetched live from TMDB each time the
  // detail screen opens, never written to local storage or the backend. ──
  List<CastMember> cast = const [];
  WatchProviderResult? watchProviders;

  /// TMDB's own numeric id — needed to fetch credits/watch-providers/videos.
  /// Populated when the movie came from a TMDB search or lookup; empty for
  /// movies loaded purely from local storage until resolved via /find.
  String tmdbId = '';

  MovieModel({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.plotOverview,
    required this.type,
    required this.year,
    required this.imdbId,
    required this.tmdbType,
    required this.genreNames,
    required this.userRating,
    required this.poster,
    required this.originalLanguage,
    required this.folderId,
    required this.isWatch,
    required this.modifiedTime,
    this.trailer,
    this.trailerThumbnail,
  });

  /// Parses a TMDB `/movie/{id}` or `/tv/{id}` details response, optionally
  /// with `append_to_response=credits,videos,watch/providers,external_ids`.
  factory MovieModel.fromTmdbJson(
    Map<String, dynamic> json, {
    required String mediaType, // 'movie' or 'tv'
  }) {
    final isTv = mediaType == 'tv';
    final title = isTv ? (json['name'] as String? ?? '') : (json['title'] as String? ?? '');
    final originalTitle = isTv
        ? (json['original_name'] as String? ?? title)
        : (json['original_title'] as String? ?? title);
    final dateStr = isTv ? json['first_air_date'] as String? : json['release_date'] as String?;
    final posterPath = json['poster_path'] as String?;
    final genres = json['genres'] as List<dynamic>?;
    final externalIds = json['external_ids'] as Map<String, dynamic>?;

    final model = MovieModel(
      id: generateRandomId(),
      title: title,
      originalTitle: originalTitle,
      plotOverview: json['overview'] as String? ?? '',
      type: mediaType,
      year: (dateStr != null && dateStr.length >= 4) ? int.tryParse(dateStr.substring(0, 4)) ?? 0 : 0,
      imdbId: externalIds?['imdb_id'] as String? ?? '',
      tmdbType: mediaType,
      genreNames: genres?.map((g) => (g['name'] as String?) ?? '').where((n) => n.isNotEmpty).toList() ?? [],
      userRating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      poster: (posterPath != null && posterPath.isNotEmpty)
          ? '${TmdbConstants.posterImageBase}$posterPath'
          : '',
      originalLanguage: json['original_language'] as String? ?? '',
      folderId: '',
      isWatch: false,
      modifiedTime: DateTime.now(),
    );
    model.tmdbId = (json['id'] ?? '').toString();

    final videos = (json['videos'] as Map<String, dynamic>?)?['results'] as List<dynamic>?;
    if (videos != null) {
      final trailerVideo = videos.cast<Map<String, dynamic>>().firstWhere(
            (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
            orElse: () => videos.isNotEmpty ? videos.first as Map<String, dynamic> : {},
          );
      final key = trailerVideo['key'] as String?;
      if (key != null && key.isNotEmpty && trailerVideo['site'] == 'YouTube') {
        model.trailer = 'https://www.youtube.com/watch?v=$key';
        model.trailerThumbnail = 'https://img.youtube.com/vi/$key/hqdefault.jpg';
      }
    }

    final creditsCast = (json['credits'] as Map<String, dynamic>?)?['cast'] as List<dynamic>?;
    if (creditsCast != null) {
      model.cast = creditsCast
          .take(20)
          .map((c) => CastMember.fromJson(c as Map<String, dynamic>))
          .toList();
    }

    final watchProvidersResults =
        (json['watch/providers'] as Map<String, dynamic>?)?['results'] as Map<String, dynamic>?;
    final regionData = watchProvidersResults?[TmdbConstants.defaultWatchRegion] as Map<String, dynamic>?;
    model.watchProviders = WatchProviderResult.fromRegionJson(regionData);

    return model;
  }

  static String generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        12, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }


  // ✅ Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'plot_overview': plotOverview,
      'type': type,
      'year': year,
      'imdb_id': imdbId,
      'tmdb_type': tmdbType,
      'genre_names': genreNames,
      'user_rating': userRating,
      'poster': poster,
      'original_language': originalLanguage,
      'trailer': trailer,
      'trailer_thumbnail': trailerThumbnail,
      'folder_id': folderId,
      'is_watch': isWatch,
    };
  }
}
