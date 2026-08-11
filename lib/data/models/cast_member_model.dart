import 'package:markmymovie/core/constants/tmdb_constants.dart';

/// A single cast member for a movie/show. Transient — fetched live from
/// TMDB, never persisted locally.
class CastMember {
  final String name;
  final String character;
  final String? profilePath;

  CastMember({required this.name, required this.character, this.profilePath});

  factory CastMember.fromJson(Map<String, dynamic> json) {
    final path = json['profile_path'] as String?;
    return CastMember(
      name: json['name'] as String? ?? '',
      character: json['character'] as String? ?? '',
      profilePath:
          (path != null && path.isNotEmpty)
              ? '${TmdbConstants.profileImageBase}$path'
              : null,
    );
  }
}
