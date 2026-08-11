import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:markmymovie/core/constants/tmdb_constants.dart';
import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/data/models/movie_card_model.dart';
import 'package:markmymovie/data/models/movie_model.dart';

/// Result of resolving a TMDB id from a stored IMDb id via /find.
class TmdbLookupResult {
  final String tmdbId;
  final String mediaType; // 'movie' or 'tv'
  TmdbLookupResult({required this.tmdbId, required this.mediaType});
}

class TmdbService {
  static const String _baseUrl = TmdbConstants.baseUrl;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer ${TmdbConstants.readAccessToken}',
        'accept': 'application/json',
      };

  /// Search movies & TV shows in one call.
  Future<List<MovieCardModel>> searchMovies(String query, IsarService service) async {
    final url = Uri.parse('$_baseUrl/search/multi').replace(queryParameters: {
      'query': query,
      'include_adult': 'false',
      'language': 'en-US',
      'page': '1',
    });

    final response = await http.get(url, headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch search results');
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final List results = data['results'] ?? [];

    return results
        .cast<Map<String, dynamic>>()
        .where((item) => item['media_type'] == 'movie' || item['media_type'] == 'tv')
        .map((item) => MovieCardModel.fromJson(item))
        .toList();
  }

  /// Fetch full movie/show details (with cast, watch providers, videos)
  /// using TMDB's own numeric id — the id returned from search results.
  Future<MovieModel> fetchMovieDetails(String tmdbId, {String mediaType = 'movie'}) async {
    final path = mediaType == 'tv' ? 'tv' : 'movie';
    final detailUrl = Uri.parse('$_baseUrl/$path/$tmdbId').replace(queryParameters: {
      'append_to_response': 'credits,videos,watch/providers,external_ids',
      'language': 'en-US',
    });

    final response = await http.get(detailUrl, headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch movie details');
    }

    final data = json.decode(response.body);
    return MovieModel.fromTmdbJson(data, mediaType: path);
  }

  /// Resolve a TMDB id + media type from a stored IMDb id. Needed for movies
  /// that were saved before TMDB numeric ids were tracked, or that were
  /// synced down from the backend (which only stores imdb_id).
  Future<TmdbLookupResult?> resolveTmdbIdFromImdbId(String imdbId) async {
    if (imdbId.isEmpty) return null;

    final url = Uri.parse('$_baseUrl/find/$imdbId').replace(queryParameters: {
      'external_source': 'imdb_id',
    });

    final response = await http.get(url, headers: _headers);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body);
    final movieResults = data['movie_results'] as List? ?? [];
    if (movieResults.isNotEmpty) {
      return TmdbLookupResult(tmdbId: movieResults.first['id'].toString(), mediaType: 'movie');
    }
    final tvResults = data['tv_results'] as List? ?? [];
    if (tvResults.isNotEmpty) {
      return TmdbLookupResult(tmdbId: tvResults.first['id'].toString(), mediaType: 'tv');
    }
    return null;
  }

  /// Fetch cast / watch-providers / trailer for a movie already saved
  /// locally, keyed only by its imdb_id. Returns a MovieModel whose extra
  /// (transient) fields — cast, watchProviders, trailer — can be merged
  /// into the locally-loaded MovieModel. Returns null if the title can't
  /// be resolved on TMDB (e.g. no network, or not found).
  Future<MovieModel?> fetchExtrasForImdbId(String imdbId) async {
    final lookup = await resolveTmdbIdFromImdbId(imdbId);
    if (lookup == null) return null;
    return fetchMovieDetails(lookup.tmdbId, mediaType: lookup.mediaType);
  }
}
