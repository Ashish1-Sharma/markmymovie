import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/data/models/movie_card_model.dart';
import 'package:markmymovie/data/models/movie_model.dart';

class TmdbService {
  static const String _apiKey = '3fb6a8a8';
  static const String _baseUrl = 'https://www.omdbapi.com';
  /// Fetch basic search results
  Future<List<MovieCardModel>> searchMovies(String query, IsarService service) async {
    final searchUrl = '$_baseUrl/?apiKey=$_apiKey&s=$query';

    final response = await http.get(Uri.parse(searchUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch search results');
    }

    Map<String, dynamic> data = json.decode(response.body);

    if (data['Response'] == 'False' || data['Search'] == null) {
      return [];
    }

    List results = data['Search'];

    List<MovieCardModel> movies = results
        .map((item) => MovieCardModel.fromJson(item))
        .toList();

    return movies;
  }


  /// Fetch full movie details using IMDb ID
  Future<MovieModel> fetchMovieDetails(String imdbId) async {
    final detailUrl = '$_baseUrl/?i=${imdbId}&apikey=3fb6a8a8&y=&plot=short';

    final response = await http.get(Uri.parse(detailUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch movie details');
    }

    final data = json.decode(response.body);
print(data);
    return MovieModel.fromJson(data);
  }
}
