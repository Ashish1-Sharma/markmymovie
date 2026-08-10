import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:markmymovie/data/models/folder_model.dart';
import 'package:markmymovie/data/models/movie_model.dart';
import 'package:markmymovie/data/repositories/auth_repository.dart';
import 'package:markmymovie/data/services/folder_api_service.dart';
import 'package:markmymovie/data/services/movie_api_service.dart';

class IsarService {
  late Future<Database> db;

  IsarService() {
    db = openDB();
  }

  Future<Database> openDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'markmymovie.db');
    
    return await openDatabase(
      path,
      version: 3,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS movies');
          await db.execute('DROP TABLE IF EXISTS folders');
          await _createTables(db);
        } else if (oldVersion < 3) {
          try {
            await db.execute('ALTER TABLE folders ADD COLUMN serverFolderId INTEGER');
          } catch (_) {}
          try {
            await db.execute('ALTER TABLE movies ADD COLUMN serverMovieId INTEGER');
          } catch (_) {}
        }
      },
      onCreate: (Database db, int version) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE folders (
        id TEXT PRIMARY KEY,
        serverFolderId INTEGER,
        name TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        modifiedTime TEXT NOT NULL,
        iconCodePoint INTEGER NOT NULL,
        iconFontFamily TEXT NOT NULL,
        colorValue INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE movies (
        id TEXT PRIMARY KEY,
        serverMovieId INTEGER,
        title TEXT NOT NULL,
        originalTitle TEXT NOT NULL,
        plotOverview TEXT NOT NULL,
        type TEXT NOT NULL,
        year INTEGER NOT NULL,
        imdbId TEXT NOT NULL,
        tmdbType TEXT NOT NULL,
        genreNames TEXT NOT NULL,
        userRating REAL NOT NULL,
        poster TEXT NOT NULL,
        originalLanguage TEXT NOT NULL,
        trailer TEXT,
        trailerThumbnail TEXT,
        folderId TEXT NOT NULL,
        modifiedTime TEXT NOT NULL,
        isWatch INTEGER NOT NULL,
        FOREIGN KEY (folderId) REFERENCES folders (id) ON DELETE CASCADE
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_folders_modifiedTime ON folders (modifiedTime DESC)'
    );
    await db.execute(
      'CREATE INDEX idx_movies_modifiedTime ON movies (modifiedTime DESC)'
    );
    await db.execute(
      'CREATE INDEX idx_movies_folderId ON movies (folderId)'
    );
  }

  // ── Mappers ────────────────────────────────────────────────────────────────

  FolderModel _rowToFolder(Map<String, dynamic> row) {
    final folder = FolderModel(
      name: row['name'] as String,
      createdAt: DateTime.parse(row['createdAt'] as String),
      modifiedTime: DateTime.parse(row['modifiedTime'] as String),
      iconCodePoint: row['iconCodePoint'] as int,
      iconFontFamily: row['iconFontFamily'] as String,
      colorValue: row['colorValue'] as int,
    );
    folder.id = row['id'] as String;
    folder.serverFolderId = row['serverFolderId'] as int?;
    return folder;
  }

  Map<String, dynamic> _folderToRow(FolderModel folder) {
    final row = <String, dynamic>{
      'name': folder.name,
      'createdAt': folder.createdAt.toIso8601String(),
      'modifiedTime': folder.modifiedTime.toIso8601String(),
      'iconCodePoint': folder.iconCodePoint,
      'iconFontFamily': folder.iconFontFamily,
      'colorValue': folder.colorValue,
      'serverFolderId': folder.serverFolderId,
    };
    if (folder.id.isNotEmpty) {
      row['id'] = folder.id;
    }
    return row;
  }

  MovieModel _rowToMovie(Map<String, dynamic> row) {
    List<String> genres = [];
    try {
      genres = List<String>.from(jsonDecode(row['genreNames'] as String));
    } catch (_) {}

    final movie = MovieModel(
      id: row['id'] as String,
      title: row['title'] as String,
      originalTitle: row['originalTitle'] as String,
      plotOverview: row['plotOverview'] as String,
      type: row['type'] as String,
      year: row['year'] as int,
      imdbId: row['imdbId'] as String,
      tmdbType: row['tmdbType'] as String,
      genreNames: genres,
      userRating: (row['userRating'] as num).toDouble(),
      poster: row['poster'] as String,
      originalLanguage: row['originalLanguage'] as String,
      folderId: row['folderId'] as String,
      isWatch: (row['isWatch'] as int) == 1,
      modifiedTime: DateTime.parse(row['modifiedTime'] as String),
      trailer: row['trailer'] as String?,
      trailerThumbnail: row['trailerThumbnail'] as String?,
    );
    movie.serverMovieId = row['serverMovieId'] as int?;
    return movie;
  }

  Map<String, dynamic> _movieToRow(MovieModel movie) {
    final row = <String, dynamic>{
      'title': movie.title,
      'originalTitle': movie.originalTitle,
      'plotOverview': movie.plotOverview,
      'type': movie.type,
      'year': movie.year,
      'imdbId': movie.imdbId,
      'tmdbType': movie.tmdbType,
      'genreNames': jsonEncode(movie.genreNames),
      'userRating': movie.userRating,
      'poster': movie.poster,
      'originalLanguage': movie.originalLanguage,
      'folderId': movie.folderId,
      'isWatch': movie.isWatch ? 1 : 0,
      'modifiedTime': movie.modifiedTime.toIso8601String(),
      'trailer': movie.trailer,
      'trailerThumbnail': movie.trailerThumbnail,
      'serverMovieId': movie.serverMovieId,
    };
    if (movie.id.isNotEmpty) {
      row['id'] = movie.id;
    }
    return row;
  }

  // ── Operations ─────────────────────────────────────────────────────────────

  Future<void> saveFolder(FolderModel folder) async {
    final database = await db;
    if (folder.id.isEmpty) {
      folder.id = FolderModel.generateRandomId();
    }

    print('[IsarService] saveFolder local ID: ${folder.id}, name: ${folder.name}, serverFolderId: ${folder.serverFolderId}');

    // Call API sync if user is logged in
    try {
      final user = await AuthRepository.instance.getStoredUser();
      print('[IsarService] saveFolder user session: ${user?.email} (ID: ${user?.id})');
      if (user != null) {
        if (folder.serverFolderId == null || folder.serverFolderId == 0) {
          print('[IsarService] saveFolder calling FolderApiService.createFolder');
          final serverId = await FolderApiService.instance.createFolder(
            userId: user.id,
            name: folder.name,
            iconCodePoint: folder.iconCodePoint,
            iconFontFamily: folder.iconFontFamily,
            colorValue: folder.colorValue,
          );
          print('[IsarService] saveFolder FolderApiService.createFolder response ID: $serverId');
          if (serverId != null) {
            folder.serverFolderId = serverId;
          }
        } else {
          print('[IsarService] saveFolder calling FolderApiService.updateFolder for server ID: ${folder.serverFolderId}');
          final success = await FolderApiService.instance.updateFolder(
            folderId: folder.serverFolderId!,
            userId: user.id,
            name: folder.name,
            iconCodePoint: folder.iconCodePoint,
            iconFontFamily: folder.iconFontFamily,
            colorValue: folder.colorValue,
          );
          print('[IsarService] saveFolder FolderApiService.updateFolder response: $success');
        }
      }
    } catch (e) {
      print('[IsarService] Folder sync error: $e');
    }

    final row = _folderToRow(folder);
    await database.insert(
      'folders',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> saveMovie(MovieModel movie) async {
    final database = await db;
    movie.modifiedTime = DateTime.now();
    if (movie.id.isEmpty) {
      movie.id = MovieModel.generateRandomId();
    }

    print('[IsarService] saveMovie title: ${movie.title}, folderId: "${movie.folderId}", imdbId: "${movie.imdbId}", serverMovieId: ${movie.serverMovieId}');

    // Call API sync if user is logged in
    try {
      final user = await AuthRepository.instance.getStoredUser();
      print('[IsarService] saveMovie user: ${user?.email} (ID: ${user?.id})');
      if (user != null) {
        final List<Map<String, dynamic>> folders = await database.query(
          'folders',
          where: 'id = ?',
          whereArgs: [movie.folderId],
        );
        print('[IsarService] saveMovie folders matches found: ${folders.length}');
        if (folders.isNotEmpty) {
          final localFolder = _rowToFolder(folders.first);
          final serverFolderId = localFolder.serverFolderId;
          print('[IsarService] saveMovie local folder: ${localFolder.name}, serverFolderId: $serverFolderId');
          if (serverFolderId != null && serverFolderId != 0) {
            if (movie.serverMovieId == null || movie.serverMovieId == 0) {
              print('[IsarService] saveMovie calling MovieApiService.createMovie');
              final serverId = await MovieApiService.instance.createMovie(
                userId: user.id,
                folderId: serverFolderId,
                movie: movie,
              );
              print('[IsarService] saveMovie MovieApiService.createMovie response: $serverId');
              if (serverId != null) {
                movie.serverMovieId = serverId;
              }
            } else {
              print('[IsarService] saveMovie calling MovieApiService.updateMovie for serverMovieId: ${movie.serverMovieId}');
              final success = await MovieApiService.instance.updateMovie(
                userId: user.id,
                folderId: serverFolderId,
                imdbId: movie.imdbId,
                updates: {
                  'title': movie.title,
                  'originalTitle': movie.originalTitle,
                  'plotOverview': movie.plotOverview,
                  'type': movie.type,
                  'year': movie.year,
                  'tmdbType': movie.tmdbType,
                  'genreNames': movie.genreNames,
                  'userRating': movie.userRating,
                  'poster': movie.poster,
                  'originalLanguage': movie.originalLanguage,
                  'trailer': movie.trailer ?? '',
                  'trailerThumbnail': movie.trailerThumbnail ?? '',
                  'isWatch': movie.isWatch,
                },
              );
              print('[IsarService] saveMovie MovieApiService.updateMovie response: $success');
            }
          }
        }
      }
    } catch (e) {
      print('[IsarService] Movie sync error: $e');
    }

    final row = _movieToRow(movie);
    await database.insert(
      'movies',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FolderModel>> getFirstFiveFolders() async {
    final database = await db;
    final List<Map<String, dynamic>> folderMaps = await database.query(
      'folders',
      orderBy: 'modifiedTime DESC',
      limit: 5,
    );

    final List<FolderModel> folders = [];
    for (final map in folderMaps) {
      final folder = _rowToFolder(map);
      final List<Map<String, dynamic>> movieMaps = await database.query(
        'movies',
        where: 'folderId = ?',
        whereArgs: [folder.id],
      );
      folder.movieIds.addAll(movieMaps.map(_rowToMovie));
      folders.add(folder);
    }
    return folders;
  }

  Future<List<MovieModel>> getRecentlyModifiedMovies() async {
    final database = await db;
    final last24Hours = DateTime.now().subtract(Duration(hours: 24));
    
    final List<Map<String, dynamic>> maps = await database.query(
      'movies',
      where: 'modifiedTime > ?',
      whereArgs: [last24Hours.toIso8601String()],
      orderBy: 'modifiedTime DESC',
      limit: 5,
    );
    return maps.map(_rowToMovie).toList();
  }

  Future<List<FolderModel>> getAllFolders() async {
    final database = await db;
    final List<Map<String, dynamic>> folderMaps = await database.query('folders');

    final List<FolderModel> folders = [];
    for (final map in folderMaps) {
      final folder = _rowToFolder(map);
      final List<Map<String, dynamic>> movieMaps = await database.query(
        'movies',
        where: 'folderId = ?',
        whereArgs: [folder.id],
      );
      folder.movieIds.addAll(movieMaps.map(_rowToMovie));
      folders.add(folder);
    }
    return folders;
  }

  Future<List<MovieModel>> getMoviesByFolder(String folderId) async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query(
      'movies',
      where: 'folderId = ?',
      whereArgs: [folderId],
    );
    return maps.map(_rowToMovie).toList();
  }

  Future<MovieModel?> getMovie(String id) async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _rowToMovie(maps.first);
  }

  Future<List<MovieModel>> getMoviesByWatchStatus(bool isWatched) async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query(
      'movies',
      where: 'isWatch = ?',
      whereArgs: [isWatched ? 1 : 0],
    );
    return maps.map(_rowToMovie).toList();
  }

  Future<void> addMovieToFolder({
    required String folderId,
    required MovieModel movie,
  }) async {
    final database = await db;
    await database.transaction((txn) async {
      final List<Map<String, dynamic>> folders = await txn.query(
        'folders',
        where: 'id = ?',
        whereArgs: [folderId],
      );

      if (folders.isNotEmpty) {
        movie.folderId = folderId;
        movie.modifiedTime = DateTime.now();
        if (movie.id.isEmpty) {
          movie.id = MovieModel.generateRandomId();
        }

        // Call API sync if user is logged in
        try {
          final user = await AuthRepository.instance.getStoredUser();
          final localFolder = _rowToFolder(folders.first);
          final serverFolderId = localFolder.serverFolderId;
          print('[IsarService] addMovieToFolder user: ${user?.email} (ID: ${user?.id}), serverFolderId: $serverFolderId, serverMovieId: ${movie.serverMovieId}');
          if (user != null && serverFolderId != null && serverFolderId != 0) {
            if (movie.serverMovieId == null || movie.serverMovieId == 0) {
              print('[IsarService] addMovieToFolder calling MovieApiService.createMovie');
              final serverId = await MovieApiService.instance.createMovie(
                userId: user.id,
                folderId: serverFolderId,
                movie: movie,
              );
              print('[IsarService] addMovieToFolder MovieApiService.createMovie response: $serverId');
              if (serverId != null) {
                movie.serverMovieId = serverId;
              }
            } else {
              print('[IsarService] addMovieToFolder calling MovieApiService.updateMovie for serverMovieId: ${movie.serverMovieId}');
              final success = await MovieApiService.instance.updateMovie(
                userId: user.id,
                folderId: serverFolderId,
                imdbId: movie.imdbId,
                updates: {
                  'title': movie.title,
                  'originalTitle': movie.originalTitle,
                  'plotOverview': movie.plotOverview,
                  'type': movie.type,
                  'year': movie.year,
                  'tmdbType': movie.tmdbType,
                  'genreNames': movie.genreNames,
                  'userRating': movie.userRating,
                  'poster': movie.poster,
                  'originalLanguage': movie.originalLanguage,
                  'trailer': movie.trailer ?? '',
                  'trailerThumbnail': movie.trailerThumbnail ?? '',
                  'isWatch': movie.isWatch,
                },
              );
              print('[IsarService] addMovieToFolder MovieApiService.updateMovie response: $success');
            }
          }
        } catch (e) {
          print('[IsarService] addMovieToFolder sync error: $e');
        }

        final movieRow = _movieToRow(movie);
        
        await txn.insert(
          'movies',
          movieRow,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        final folderMap = folders.first;
        final folder = _rowToFolder(folderMap);
        folder.modifiedTime = DateTime.now();
        
        await txn.update(
          'folders',
          _folderToRow(folder),
          where: 'id = ?',
          whereArgs: [folderId],
        );
      } else {
        throw Exception('Folder not found');
      }
    });
  }

  Future<void> deleteFolder(String folderId) async {
    final database = await db;
    
    // Call API sync if user is logged in
    try {
      final List<Map<String, dynamic>> folders = await database.query(
        'folders',
        where: 'id = ?',
        whereArgs: [folderId],
      );
      if (folders.isNotEmpty) {
        final folder = _rowToFolder(folders.first);
        final user = await AuthRepository.instance.getStoredUser();
        if (user != null && folder.serverFolderId != null && folder.serverFolderId != 0) {
          await FolderApiService.instance.deleteFolder(
            folderId: folder.serverFolderId!,
            userId: user.id,
          );
        }
      }
    } catch (e) {
      print('[IsarService] Folder delete sync error: $e');
    }

    await database.delete(
      'folders',
      where: 'id = ?',
      whereArgs: [folderId],
    );
  }

  Future<void> syncFoldersFromServer() async {
    try {
      final user = await AuthRepository.instance.getStoredUser();
      if (user == null) {
        print('[IsarService] syncFoldersFromServer aborted: no user session');
        return;
      }

      final database = await db;
      print('[IsarService] syncFoldersFromServer starting bidirectional sync for user: ${user.email}');

      // 1. Upload local folders that don't have a serverFolderId yet
      final List<Map<String, dynamic>> unsyncedLocalFolders = await database.query(
        'folders',
        where: 'serverFolderId IS NULL OR serverFolderId = 0',
      );
      print('[IsarService] syncFoldersFromServer: found ${unsyncedLocalFolders.length} unsynced local folders');
      for (final row in unsyncedLocalFolders) {
        final folder = _rowToFolder(row);
        print('[IsarService] syncFoldersFromServer: uploading offline folder "${folder.name}"');
        final serverId = await FolderApiService.instance.createFolder(
          userId: user.id,
          name: folder.name,
          iconCodePoint: folder.iconCodePoint,
          iconFontFamily: folder.iconFontFamily,
          colorValue: folder.colorValue,
        );
        print('[IsarService] syncFoldersFromServer: upload response serverId: $serverId');
        if (serverId != null) {
          folder.serverFolderId = serverId;
          await database.update(
            'folders',
            _folderToRow(folder),
            where: 'id = ?',
            whereArgs: [folder.id],
          );
        }
      }

      // 2. Upload local movies that don't have a serverMovieId yet
      final List<Map<String, dynamic>> unsyncedLocalMovies = await database.query(
        'movies',
        where: 'serverMovieId IS NULL OR serverMovieId = 0',
      );
      print('[IsarService] syncFoldersFromServer: found ${unsyncedLocalMovies.length} unsynced local movies');
      for (final row in unsyncedLocalMovies) {
        final movie = _rowToMovie(row);
        // Find the folder's serverFolderId
        final List<Map<String, dynamic>> folderRow = await database.query(
          'folders',
          where: 'id = ?',
          whereArgs: [movie.folderId],
        );
        if (folderRow.isNotEmpty) {
          final folder = _rowToFolder(folderRow.first);
          final serverFolderId = folder.serverFolderId;
          print('[IsarService] syncFoldersFromServer: uploading offline movie "${movie.title}" in folder "${folder.name}" (serverFolderId: $serverFolderId)');
          if (serverFolderId != null && serverFolderId != 0) {
            final serverId = await MovieApiService.instance.createMovie(
              userId: user.id,
              folderId: serverFolderId,
              movie: movie,
            );
            print('[IsarService] syncFoldersFromServer: upload response serverId: $serverId');
            if (serverId != null) {
              movie.serverMovieId = serverId;
              await database.update(
                'movies',
                _movieToRow(movie),
                where: 'id = ?',
                whereArgs: [movie.id],
              );
            }
          }
        }
      }

      // 3. Pull folders from the server
      final serverFolders = await FolderApiService.instance.getFolders(userId: user.id);
      print('[IsarService] syncFoldersFromServer: fetched ${serverFolders.length} folders from server');
      if (serverFolders.isEmpty) return;

      for (final serverFolder in serverFolders) {
        final int serverId = int.tryParse(serverFolder['id'].toString()) ?? 0;
        if (serverId == 0) continue;

        // Check if we already have this folder locally
        final List<Map<String, dynamic>> localMatches = await database.query(
          'folders',
          where: 'serverFolderId = ?',
          whereArgs: [serverId],
        );

        String localFolderId = '';
        if (localMatches.isNotEmpty) {
          // Update local details if different
          final localFolder = _rowToFolder(localMatches.first);
          localFolder.name = serverFolder['name'] as String? ?? localFolder.name;
          localFolder.iconCodePoint = int.tryParse(serverFolder['iconCodePoint'].toString()) ?? localFolder.iconCodePoint;
          localFolder.iconFontFamily = serverFolder['iconFontFamily'] as String? ?? localFolder.iconFontFamily;
          localFolder.colorValue = int.tryParse(serverFolder['colorValue'].toString()) ?? localFolder.colorValue;
          localFolderId = localFolder.id;
          
          await database.update(
            'folders',
            _folderToRow(localFolder),
            where: 'id = ?',
            whereArgs: [localFolder.id],
          );
        } else {
          // Create new local folder mapped to this server folder
          final newFolder = FolderModel(
            name: serverFolder['name'] as String? ?? 'Unnamed Folder',
            createdAt: DateTime.tryParse(serverFolder['createdAt'].toString()) ?? DateTime.now(),
            modifiedTime: DateTime.tryParse(serverFolder['updatedAt'].toString()) ?? DateTime.now(),
            iconCodePoint: int.tryParse(serverFolder['iconCodePoint'].toString()) ?? 59530,
            iconFontFamily: serverFolder['iconFontFamily'] as String? ?? 'MaterialIcons',
            colorValue: int.tryParse(serverFolder['colorValue'].toString()) ?? 4283215696,
          );
          newFolder.serverFolderId = serverId;
          localFolderId = newFolder.id;
          
          await database.insert(
            'folders',
            _folderToRow(newFolder),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        // Sync movies inside this folder
        await syncMoviesForFolder(user.id, localFolderId, serverId);
      }
    } catch (e) {
      print('[IsarService] syncFoldersFromServer error: $e');
    }
  }

  Future<void> syncMoviesForFolder(int userId, String localFolderId, int serverFolderId) async {
    try {
      final serverMovies = await MovieApiService.instance.getMovies(
        userId: userId,
        folderId: serverFolderId,
      );
      if (serverMovies.isEmpty) return;

      final database = await db;
      for (final serverMovie in serverMovies) {
        final int serverId = int.tryParse(serverMovie['id'].toString()) ?? 0;
        final String imdbId = serverMovie['imdb_id'] as String? ?? '';
        if (imdbId.isEmpty) continue;

        // Check if we already have this movie locally in this folder
        final List<Map<String, dynamic>> localMatches = await database.query(
          'movies',
          where: 'folderId = ? AND imdbId = ?',
          whereArgs: [localFolderId, imdbId],
        );

        List<String> genres = [];
        if (serverMovie['genre_names'] is List) {
          genres = List<String>.from(serverMovie['genre_names']);
        }

        if (localMatches.isNotEmpty) {
          // Update details
          final localMovie = _rowToMovie(localMatches.first);
          localMovie.serverMovieId = serverId;
          localMovie.title = serverMovie['title'] as String? ?? localMovie.title;
          localMovie.originalTitle = serverMovie['original_title'] as String? ?? localMovie.originalTitle;
          localMovie.plotOverview = serverMovie['plot_overview'] as String? ?? localMovie.plotOverview;
          localMovie.type = serverMovie['type'] as String? ?? localMovie.type;
          localMovie.year = int.tryParse(serverMovie['year'].toString()) ?? localMovie.year;
          localMovie.tmdbType = serverMovie['tmdb_type'] as String? ?? localMovie.tmdbType;
          localMovie.genreNames = genres.isNotEmpty ? genres : localMovie.genreNames;
          localMovie.userRating = double.tryParse(serverMovie['user_rating'].toString()) ?? localMovie.userRating;
          localMovie.poster = serverMovie['poster'] as String? ?? localMovie.poster;
          localMovie.originalLanguage = serverMovie['original_language'] as String? ?? localMovie.originalLanguage;
          localMovie.trailer = serverMovie['trailer'] as String? ?? localMovie.trailer;
          localMovie.trailerThumbnail = serverMovie['trailer_thumbnail'] as String? ?? localMovie.trailerThumbnail;
          localMovie.isWatch = serverMovie['is_watch'] is bool 
              ? serverMovie['is_watch'] 
              : (int.tryParse(serverMovie['is_watch'].toString()) == 1);

          await database.update(
            'movies',
            _movieToRow(localMovie),
            where: 'id = ?',
            whereArgs: [localMovie.id],
          );
        } else {
          // Insert new movie
          final newMovie = MovieModel(
            id: MovieModel.generateRandomId(),
            title: serverMovie['title'] as String? ?? 'Untitled Movie',
            originalTitle: serverMovie['original_title'] as String? ?? '',
            plotOverview: serverMovie['plot_overview'] as String? ?? '',
            type: serverMovie['type'] as String? ?? 'movie',
            year: int.tryParse(serverMovie['year'].toString()) ?? 0,
            imdbId: imdbId,
            tmdbType: serverMovie['tmdb_type'] as String? ?? 'movie',
            genreNames: genres,
            userRating: double.tryParse(serverMovie['user_rating'].toString()) ?? 0.0,
            poster: serverMovie['poster'] as String? ?? '',
            originalLanguage: serverMovie['original_language'] as String? ?? '',
            folderId: localFolderId,
            isWatch: serverMovie['is_watch'] is bool 
                ? serverMovie['is_watch'] 
                : (int.tryParse(serverMovie['is_watch'].toString()) == 1),
            modifiedTime: DateTime.tryParse(serverMovie['modified_time'].toString()) ?? DateTime.now(),
            trailer: serverMovie['trailer'] as String?,
            trailerThumbnail: serverMovie['trailer_thumbnail'] as String?,
          );
          newMovie.serverMovieId = serverId;

          await database.insert(
            'movies',
            _movieToRow(newMovie),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    } catch (e) {
      print('[IsarService] syncMoviesForFolder error: $e');
    }
  }

  Future<void> deleteMovieFromFolder({
    required String folderId,
    required String imdbId,
  }) async {
    final database = await db;
    
    // Call API sync if user is logged in
    try {
      final user = await AuthRepository.instance.getStoredUser();
      if (user != null) {
        final List<Map<String, dynamic>> folders = await database.query(
          'folders',
          where: 'id = ?',
          whereArgs: [folderId],
        );
        if (folders.isNotEmpty) {
          final localFolder = _rowToFolder(folders.first);
          final serverFolderId = localFolder.serverFolderId;
          if (serverFolderId != null && serverFolderId != 0) {
            await MovieApiService.instance.deleteMovie(
              userId: user.id,
              folderId: serverFolderId,
              imdbId: imdbId,
            );
          }
        }
      }
    } catch (e) {
      print('[IsarService] Movie delete sync error: $e');
    }

    await database.delete(
      'movies',
      where: 'folderId = ? AND imdbId = ?',
      whereArgs: [folderId, imdbId],
    );
  }
}
