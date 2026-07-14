import 'dart:convert';

/// Represents an authenticated user returned by the backend.
class UserModel {
  final int id;
  final String googleId;
  final String name;
  final String email;
  final String profilePicture;
  final String createdAt;
  final String updatedAt;
  final String lastLoginAt;

  const UserModel({
    required this.id,
    required this.googleId,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      googleId: json['google_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profilePicture: json['profile_picture']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      lastLoginAt: json['last_login_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'google_id': googleId,
      'name': name,
      'email': email,
      'profile_picture': profilePicture,
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

  UserModel copyWith({
    int? id,
    String? googleId,
    String? name,
    String? email,
    String? profilePicture,
    String? createdAt,
    String? updatedAt,
    String? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      googleId: googleId ?? this.googleId,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
