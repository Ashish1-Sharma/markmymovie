import 'package:isar/isar.dart';
import 'package:markmymovie/data/models/folder_model.dart';
import 'package:markmymovie/data/models/movie_model.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [MovieModelSchema, FolderModelSchema],
      directory: dir.path,
      name: 'mydata',
    );
  }
  Future<void> saveFolder(FolderModel folder) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.folderModels.put(folder);
    });
  }

// ✅ Save or update a movie
  Future<void> saveMovie(MovieModel movie) async {
    final isar = await db;
    movie.modifiedTime = DateTime.now();
    await isar.writeTxn(() async {
      await isar.movieModels.put(movie);
    });
  }
  // ✅ Fetch only first 5 folders
  Future<List<FolderModel>> getFirstFiveFolders() async {
    final isar = await db;
    return await isar.folderModels
        .where()
        .sortByModifiedTimeDesc()
        .limit(5)
        .findAll();
  }


  // ✅ Fetch recently modified movies (e.g. within last 24 hours or ordered by modifiedTime)
  Future<List<MovieModel>> getRecentlyModifiedMovies() async {
    final isar = await db;
    final last24Hours = DateTime.now().subtract(Duration(hours: 24));

    return await isar.movieModels
        .filter()
        .modifiedTimeGreaterThan(last24Hours)
        .sortByModifiedTimeDesc()
        .limit(5)
        .findAll();
  }


  // ✅ Fetch all folders
  Future<List<FolderModel>> getAllFolders() async {
    final isar = await db;
    return await isar.folderModels.where().findAll();
  }

  // ✅ Fetch all movies inside a folder
  Future<List<MovieModel>> getMoviesByFolder(int folderId) async {
    final isar = await db;

    final folder = await isar.folderModels.get(folderId);
    if (folder == null) return [];

    await folder.movieIds.load(); // Load linked movies
    return folder.movieIds.toList(); // Return them as a list
  }

  Future<MovieModel?> getMovie(int id) async {
    final isar = await db;

    final movie = await isar.movieModels.get(id);
    if (movie == null) return null;
 // Load linked movies
    return movie; // Return them as a list
  }
  // ✅ Fetch movies by isWatch = true or false
  Future<List<MovieModel>> getMoviesByWatchStatus(bool isWatched) async {
    final isar = await db;
    return await isar.movieModels.filter().isWatchEqualTo(isWatched).findAll();
  }


  Future<void> addMovieToFolder({
    required int folderId,
    required MovieModel movie,
  }) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final folder = await isar.folderModels.get(folderId);

      if (folder != null) {
        // Save movie (if not already saved)
        movie.folderId = folderId;
        await isar.movieModels.put(movie);

        // Add movie to folder link
        folder.movieIds.add(movie);
        await folder.movieIds.save();

        // Update modified time
        folder.modifiedTime = DateTime.now();
        await isar.folderModels.put(folder);
        print("setted");
      } else {
        throw Exception('Folder not found');
      }
    });
  }

}
