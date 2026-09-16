import 'dart:convert';

/// Aggregate counts shown on the profile header. Computed server-side
/// over the user's *public* folders only.
class ProfileStats {
  final int publicFolders;
  final int publicMovies;
  final int totalLikes;
  final int profileViews;
  final String? topGenre;

  const ProfileStats({
    this.publicFolders = 0,
    this.publicMovies = 0,
    this.totalLikes = 0,
    this.profileViews = 0,
    this.topGenre,
  });

  static int _int(dynamic v) =>
      v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      publicFolders: _int(json['public_folders']),
      publicMovies: _int(json['public_movies']),
      totalLikes: _int(json['total_likes']),
      profileViews: _int(json['profile_views']),
      topGenre: (json['top_genre']?.toString().trim().isEmpty ?? true)
          ? null
          : json['top_genre'].toString().trim(),
    );
  }

  Map<String, dynamic> toJson() => {
        'public_folders': publicFolders,
        'public_movies': publicMovies,
        'total_likes': totalLikes,
        'profile_views': profileViews,
        'top_genre': topGenre,
      };
}

/// Represents an authenticated user returned by the backend.
class UserModel {
  final int id;
  final String googleId;

  /// Public URL slug — the profile lives at `/@<username>`. Unique.
  final String username;
  final String name;
  final String bio;
  final String email;
  final String profilePicture;
  final String bannerImage;

  /// Platform → URL, e.g. `{'instagram': 'https://instagram.com/x'}`.
  /// Only platforms the backend whitelists survive a save.
  final Map<String, String> socialLinks;

  final bool isProfilePublic;
  final ProfileStats stats;

  final String createdAt;
  final String updatedAt;
  final String lastLoginAt;

  const UserModel({
    required this.id,
    required this.googleId,
    required this.username,
    required this.name,
    required this.bio,
    required this.email,
    required this.profilePicture,
    required this.bannerImage,
    required this.socialLinks,
    required this.isProfilePublic,
    required this.stats,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLoginAt,
  });

  static Map<String, String> _links(dynamic raw) {
    if (raw == null) return const {};
    // The column is JSON, but a plain string can come back from older
    // rows or from a re-encoded cache — handle both.
    final decoded = raw is String
        ? (raw.trim().isEmpty ? null : jsonDecode(raw))
        : raw;
    if (decoded is! Map) return const {};
    return decoded.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''))
      ..removeWhere((_, v) => v.isEmpty);
  }

  static bool _bool(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    final s = v?.toString().toLowerCase();
    return s == '1' || s == 'true';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      googleId: json['google_id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profilePicture: json['profile_picture']?.toString() ?? '',
      bannerImage: json['banner_image']?.toString() ?? '',
      socialLinks: _links(json['social_links']),
      // Absent means "public" — matches the column default.
      isProfilePublic:
          json.containsKey('is_profile_public') ? _bool(json['is_profile_public']) : true,
      stats: json['stats'] is Map
          ? ProfileStats.fromJson(Map<String, dynamic>.from(json['stats'] as Map))
          : const ProfileStats(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      lastLoginAt: json['last_login_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'google_id': googleId,
      'username': username,
      'name': name,
      'bio': bio,
      'email': email,
      'profile_picture': profilePicture,
      'banner_image': bannerImage,
      'social_links': socialLinks,
      'is_profile_public': isProfilePublic,
      'stats': stats.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'last_login_at': lastLoginAt,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  static UserModel? fromJsonString(String jsonString) {
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Public profile URL shown in the app and copied to the clipboard.
  String get publicProfileUrl => 'watchstash.app/@$username';

  UserModel copyWith({
    int? id,
    String? googleId,
    String? username,
    String? name,
    String? bio,
    String? email,
    String? profilePicture,
    String? bannerImage,
    Map<String, String>? socialLinks,
    bool? isProfilePublic,
    ProfileStats? stats,
    String? createdAt,
    String? updatedAt,
    String? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      googleId: googleId ?? this.googleId,
      username: username ?? this.username,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      bannerImage: bannerImage ?? this.bannerImage,
      socialLinks: socialLinks ?? this.socialLinks,
      isProfilePublic: isProfilePublic ?? this.isProfilePublic,
      stats: stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
