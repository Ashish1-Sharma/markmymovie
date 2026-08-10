import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:markmymovie/core/constants/auth_constants.dart';

/// Handles HTTP requests with the folder backend API endpoints.
class FolderApiService {
  FolderApiService._();

  static final FolderApiService instance = FolderApiService._();

  String get baseUrl => '${AuthConstants.apiBaseUrl}/api/folders';

  /// Creates a folder on the backend and returns the server's folder integer ID.
  Future<int?> createFolder({
    required int userId,
    required String name,
    required int iconCodePoint,
    required String iconFontFamily,
    required int colorValue,
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
          'name': name,
          'description': '',
          'visibility': 'private',
          'iconCodePoint': iconCodePoint,
          'iconFontFamily': iconFontFamily,
          'colorValue': colorValue,
        }),
      ).timeout(const Duration(seconds: 15));

      print(jsonEncode({
        'userId': userId,
        'name': name,
        'description': '',
        'visibility': 'private',
        'iconCodePoint': iconCodePoint,
        'iconFontFamily': iconFontFamily,
        'colorValue': colorValue,
      }));
      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final statusCode = body['statusCode'];
        if (statusCode == 201 || statusCode == 200 || statusCode == '201' || statusCode == '200') {
          final folderData = body['body'] as Map<String, dynamic>;
          return int.tryParse(folderData['id'].toString());
        }
      }
    } catch (e) {
      print('[FolderApiService] Create Folder Error: $e');
    }
    return null;
  }

  /// Fetches all folders belonging to [userId] from the backend.
  Future<List<Map<String, dynamic>>> getFolders({required int userId}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/list.php?userId=$userId'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final statusCode = body['statusCode'];
        if (statusCode == 200 || statusCode == '200') {
          final list = body['body'] as List<dynamic>;
          return list.map((e) => e as Map<String, dynamic>).toList();
        }
      }
    } catch (e) {
      print('[FolderApiService] Get Folders Error: $e');
    }
    return [];
  }

  /// Updates an existing folder on the backend using PUT method.
  Future<bool> updateFolder({
    required int folderId,
    required int userId,
    required String name,
    required int iconCodePoint,
    required String iconFontFamily,
    required int colorValue,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'id': folderId,
          'userId': userId,
          'name': name,
          'description': '',
          'visibility': 'private',
          'iconCodePoint': iconCodePoint,
          'iconFontFamily': iconFontFamily,
          'colorValue': colorValue,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final statusCode = body['statusCode'];
        return statusCode == 200 || statusCode == '200';
      }
    } catch (e) {
      print('[FolderApiService] Update Folder Error: $e');
    }
    return false;
  }

  /// Deletes a folder on the backend using DELETE method.
  Future<bool> deleteFolder({
    required int folderId,
    required int userId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'folderId': folderId,
          'userId': userId,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final statusCode = body['statusCode'];
        return statusCode == 200 || statusCode == '200';
      }
    } catch (e) {
      print('[FolderApiService] Delete Folder Error: $e');
    }
    return false;
  }
}
