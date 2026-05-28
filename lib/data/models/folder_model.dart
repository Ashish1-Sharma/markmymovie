import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'movie_model.dart';

part 'folder_model.g.dart';

@collection
class FolderModel {
  Id id = Isar.autoIncrement;

  late String name; // e.g. "Favorites", "Watch Later"

  late DateTime createdAt;

  final movieIds = IsarLinks<MovieModel>(); // Links to MovieModel

  @Index() // 👈 Added index for sorting/filtering
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
  });
}
