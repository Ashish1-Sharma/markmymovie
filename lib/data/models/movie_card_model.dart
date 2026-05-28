class MovieCardModel {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;

  MovieCardModel({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.type,
    required this.poster,
  });

  factory MovieCardModel.fromJson(Map<String, dynamic> json) {
    return MovieCardModel(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? '',
      poster: json['Poster'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Year': year,
      'imdbID': imdbID,
      'Type': type,
      'Poster': poster,
    };
  }
}
