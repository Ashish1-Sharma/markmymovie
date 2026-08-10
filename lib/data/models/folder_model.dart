import 'dart:math';
import 'movie_model.dart';

class FolderModel {
  String id = '';
  int? serverFolderId;

  late String name; // e.g. "Favorites", "Watch Later"

  late DateTime createdAt;

  final List<MovieModel> movieIds = []; // Links to MovieModel

  late DateTime modifiedTime;

  late int iconCodePoint;
  late String iconFontFamily;
  late int colorValue;

  FolderModel({
    required this.name,
    required this.createdAt,
    required this.modifiedTime,
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.colorValue,
  }) {
    id = generateRandomId();
  }

  static String generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        12, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
