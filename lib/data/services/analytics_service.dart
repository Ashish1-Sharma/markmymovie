import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  /// Event triggered whenever a user searches for a movie
  Future<void> logMovieSearch(String searchTerm) async {
    try {
      await _analytics.logEvent(
        name: 'movie_search',
        parameters: {
          'search_term': searchTerm,
        },
      );
    } catch (e) {
      debugPrint('Analytics error (logMovieSearch): $e');
    }
  }

  /// Event triggered when search results for a movie are fetched
  Future<void> logMovieFetched({
    required String searchTerm,
    required int resultCount,
    required bool hasError,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'movie_fetched',
        parameters: {
          'search_term': searchTerm,
          'result_count': resultCount,
          'has_error': hasError ? 1 : 0,
        },
      );
    } catch (e) {
      debugPrint('Analytics error (logMovieFetched): $e');
    }
  }

  /// Event triggered when a movie card is clicked to open movie details
  Future<void> logMovieClick({
    required String movieId,
    required String movieTitle,
    String? mediaType,
    String source = 'search',
  }) async {
    try {
      await _analytics.logEvent(
        name: 'movie_click',
        parameters: {
          'movie_id': movieId,
          'movie_title': movieTitle,
          'media_type': mediaType ?? 'movie',
          'source': source,
        },
      );
    } catch (e) {
      debugPrint('Analytics error (logMovieClick): $e');
    }
  }

  /// Event triggered on user login
  Future<void> logLogin({required String method}) async {
    try {
      await _analytics.logLogin(loginMethod: method);
    } catch (e) {
      debugPrint('Analytics error (logLogin): $e');
    }
  }

  /// Event triggered on user registration
  Future<void> logSignUp({required String method}) async {
    try {
      await _analytics.logSignUp(signUpMethod: method);
    } catch (e) {
      debugPrint('Analytics error (logSignUp): $e');
    }
  }

  /// Event triggered on logout
  Future<void> logLogout() async {
    try {
      await _analytics.logEvent(name: 'logout');
    } catch (e) {
      debugPrint('Analytics error (logLogout): $e');
    }
  }

  /// Event triggered when movie is marked as watched/unwatched
  Future<void> logMarkAsWatched({
    required String movieId,
    required String movieTitle,
    required bool isWatched,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'mark_as_watched',
        parameters: {
          'movie_id': movieId,
          'movie_title': movieTitle,
          'is_watched': isWatched ? 1 : 0,
        },
      );
    } catch (e) {
      debugPrint('Analytics error (logMarkAsWatched): $e');
    }
  }

  /// Event triggered when user clicks to play trailer
  Future<void> logWatchTrailer({
    required String movieId,
    required String movieTitle,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'watch_trailer',
        parameters: {
          'movie_id': movieId,
          'movie_title': movieTitle,
        },
      );
    } catch (e) {
      debugPrint('Analytics error (logWatchTrailer): $e');
    }
  }

  /// Event triggered when user creates a new folder/watchlist
  Future<void> logCreateFolder({
    required String folderName,
    required bool isPublic,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'create_folder',
        parameters: {
          'folder_name': folderName,
          'is_public': isPublic ? 1 : 0,
        },
      );
    } catch (e) {
      debugPrint('Analytics error (logCreateFolder): $e');
    }
  }

  /// Event triggered when a movie is added to a folder/watchlist
  Future<void> logAddToFolder({
    required String movieId,
    required String movieTitle,
    required String folderId,
    required String folderName,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'add_to_folder',
        parameters: {
          'movie_id': movieId,
          'movie_title': movieTitle,
          'folder_id': folderId,
          'folder_name': folderName,
        },
      );
    } catch (e) {
      debugPrint('Analytics error (logAddToFolder): $e');
    }
  }

  /// Event triggered when a movie is removed from a folder
  Future<void> logRemoveFromFolder({
    required String movieId,
    required String folderId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'remove_from_folder',
        parameters: {
          'movie_id': movieId,
          'folder_id': folderId,
        },
      );
    } catch (e) {
      debugPrint('Analytics error (logRemoveFromFolder): $e');
    }
  }

  /// Event triggered when a folder is deleted
  Future<void> logDeleteFolder({
    required String folderId,
    required String folderName,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'delete_folder',
        parameters: {
          'folder_id': folderId,
          'folder_name': folderName,
        },
      );
    } catch (e) {
      debugPrint('Analytics error (logDeleteFolder): $e');
    }
  }

  /// Event triggered when setting a movie reminder
  Future<void> logSetReminder({
    required String movieId,
    required String movieTitle,
    required String reminderTime,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'set_reminder',
        parameters: {
          'movie_id': movieId,
          'movie_title': movieTitle,
          'reminder_time': reminderTime,
        },
      );
    } catch (e) {
      debugPrint('Analytics error (logSetReminder): $e');
    }
  }
}
