import 'package:isar/isar.dart';

part 'movie_model.g.dart';

@collection
class MovieModel {
  Id id; // can be the same as "id" from TMDb or Watchmode

  late String title;
  late String originalTitle;
  late String plotOverview;

  late String type; // "movie" or "show"
  late int year;

  late String imdbId;
  late String tmdbType;

  late List<String> genreNames;

  late double userRating;
  late String poster;
  late String originalLanguage;

  String? trailer;
  String? trailerThumbnail;
  late int folderId;
  DateTime modifiedTime = DateTime.now();
  bool isWatch = false;
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
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: Isar.autoIncrement, // or generate custom hash if needed
      title: json['Title'] ?? '',
      originalTitle: json['Title'] ?? '',
      plotOverview: json['Plot'] ?? '',
      type: json['Type'] ?? 'movie',
      year: int.tryParse(json['Year']?.substring(0, 4) ?? '') ?? 0,
      imdbId: json['imdbID'] ?? '',
      tmdbType: json['Type'] ?? 'movie',
      genreNames: (json['Genre'] as String?)?.split(',').map((e) => e.trim()).toList() ?? [],
      userRating: double.tryParse(json['imdbRating'] ?? '') ?? 0.0,
      poster: json['Poster'] ?? '',
      originalLanguage: json['Language'] ?? '',
      trailer: null,
      trailerThumbnail: null,
      folderId: 0,
      isWatch: false,
      modifiedTime: DateTime.now(),
    );
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
