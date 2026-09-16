import 'package:flutter/material.dart';

/// Supported folder icons list
const List<IconData> _supportedFolderIcons = [
  Icons.folder,
  Icons.movie,
  Icons.favorite,
  Icons.star,
  Icons.weekend,
  Icons.local_fire_department,
  Icons.rocket_launch,
  Icons.nightlight,
  Icons.family_restroom,
  Icons.theater_comedy,
  Icons.camera_roll,
  Icons.video_library,
  Icons.trending_up,
  Icons.grade,
  Icons.bookmark,
  Icons.watch_later,
  Icons.home,
  Icons.tv,
  Icons.local_movies,
  Icons.label,
  Icons.list,
  Icons.style,
  Icons.grid_view,
  Icons.collections,
  Icons.folder_special,
  Icons.video_collection,
  Icons.play_circle,
  Icons.videocam,
];

/// Map of icon code points to static [IconData] instances.
/// Using static constant IconData references avoids non-constant IconData invocations
/// which fail during release builds when icon tree shaking is enabled.
final Map<int, IconData> _iconCodePointMap = {
  for (final icon in _supportedFolderIcons) icon.codePoint: icon,
};

/// Returns a constant [IconData] corresponding to the given [codePoint].
/// If the codePoint is not found in the supported icons map, defaults to [Icons.folder].
IconData getFolderIconData(int codePoint, [String? fontFamily]) {
  return _iconCodePointMap[codePoint] ?? Icons.folder;
}
