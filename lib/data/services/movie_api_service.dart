import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:markmymovie/core/constants/auth_constants.dart';
import 'package:markmymovie/data/models/movie_model.dart';

/// Handles HTTP requests with the movie backend API endpoints.
class MovieApiService {
  MovieApiService._();

  static final MovieApiService instance = MovieApiService._();

  String get baseUrl => '${AuthConstants.apiBaseUrl}/api/movies';

  /// Adds a movie to a folder on the backend and returns the server's movie integer ID.
  Future<int?> createMovie({
    required int userId,
    required int folderId,
    required MovieModel movie,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'folderId': folderId,
          'title': movie.title,
          'originalTitle': movie.originalTitle,
          'plotOverview': movie.plotOverview,
          'type': movie.type,
          'year': movie.year,
          'imdbId': movie.imdbId,
          'tmdbType': movie.tmdbType,
          'genreNames': movie.genreNames,
          'userRating': movie.userRating,
          'poster': movie.poster,
          'originalLanguage': movie.originalLanguage,
          'trailer': movie.trailer ?? '',
          'trailerThumbnail': movie.trailerThumbnail ?? '',
          'isWatch': movie.isWatch,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final statusCode = body['statusCode'];
        if (statusCode == 201 || statusCode == 200 || statusCode == '201' || statusCode == '200') {
          final movieData = body['body'] as Map<String, dynamic>;
          return int.tryParse(movieData['id'].toString());
        }
      }
    } catch (e) {
      print('[MovieApiService] Create Movie Error: $e');
    }
    return null;
  }

  /// Fetches all movies inside a specific folder belonging to [userId] from the backend.
  Future<List<Map<String, dynamic>>> getMovies({
    required int userId,
    required int folderId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/list.php?userId=$userId&folderId=$folderId'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final statusCode = body['statusCode'];
        if (statusCode == 200 || statusCode == '200') {
          final data = body['body'] as Map<String, dynamic>;
          final list = data['movies'] as List<dynamic>;
          return list.map((e) => e as Map<String, dynamic>).toList();
        }
      }
    } catch (e) {
      print('[MovieApiService] Get Movies Error: $e');
    }
    return [];
  }

  /// Updates an existing movie on the backend using POST method.
  Future<bool> updateMovie({
    required int userId,
    required int folderId,
    required String imdbId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      final Map<String, dynamic> payload = {
        'userId': userId,
        'folderId': folderId,
        'imdbId': imdbId,
        ...updates,
      };

      print("-----------------------");
      final response = await http.post(
        Uri.parse('$baseUrl/update.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 15));

      print(response.body);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final statusCode = body['statusCode'];
        return statusCode == 200 || statusCode == '200';
      }
    } catch (e) {
      print('[MovieApiService] Update Movie Error: $e');
    }
    return false;
  }

  /// Deletes a movie from a folder on the backend using POST method.
  Future<bool> deleteMovie({
    required int userId,
    required int folderId,
    required String imdbId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'folderId': folderId,
          'imdbId': imdbId,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final statusCode = body['statusCode'];
        return statusCode == 200 || statusCode == '200';
      }
    } catch (e) {
      print('[MovieApiService] Delete Movie Error: $e');
    }
    return false;
  }
}
