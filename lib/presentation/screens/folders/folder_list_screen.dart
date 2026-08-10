import 'package:flutter/material.dart';
import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/data/models/movie_model.dart';
import 'package:markmymovie/presentation/screens/detail/movie_detail_screen.dart';
import 'package:markmymovie/presentation/screens/search/search_screen.dart';
import 'package:markmymovie/presentation/widgets/custom_alerts.dart';

class FolderListScreen extends StatefulWidget {
  final IsarService isarService;
  final String folderName;
  final String id;
  final Icon folderIcon;

  const FolderListScreen({
    super.key,
    required this.isarService,
    required this.folderName,
    required this.folderIcon,
    required this.id,
  });

  @override
  State<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock movie data - replace with actual data from your models
  List<MovieModel> _movies = [];

  Future<void> _loadMovies() async {
    _movies.clear();
    final response = await widget.isarService.getMoviesByFolder(widget.id);
    _movies.addAll(response);
    print(_movies);
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
    _loadMovies();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _buildCinematicTheme(),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(),
              _buildFolderHeader(),
              _buildMoviesList(),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  ThemeData _buildCinematicTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.red,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1F1F1F),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFFB3B3B3),
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFF121212).withOpacity(0.9),
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white70,
            size: 20,
          ),
        ),
      ),
      title: Row(
        children: [
          widget.folderIcon,
          const SizedBox(width: 12),
          Text(
            widget.folderName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            _showSortOptions();
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.sort,
              color: Colors.white70,
              size: 20,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            _showGridToggle();
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.grid_view,
              color: Colors.white70,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildFolderHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFE50914).withOpacity(0.1),
                const Color(0xFF1F1F1F),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE50914).withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE50914).withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child:  widget.folderIcon,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.folderName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatChip('${_movies.length} Movies', Icons.movie),
                        const SizedBox(width: 12),
                        _buildStatChip(
                          '${_movies.where((m) => !m.isWatch).length} To Watch',
                          Icons.schedule,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF121212).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFFB3B3B3),
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final movie = _movies[index];
            return _buildMovieCard(movie, index);
          },
          childCount: _movies.length,
        ),
      ),
    );
  }

  Widget _buildMovieCard(MovieModel movie, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to movie detail
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieDetailScreen(isarService: widget.isarService, movieModel: movie,),)).then((value) async {
              await _loadMovies();
            },);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Poster
                _buildMoviePoster(movie),
                const SizedBox(width: 16),
                // Movie Info
                Expanded(
                  child: _buildMovieInfo(movie),
                ),
                const SizedBox(width: 12),
                // Action Buttons
                _buildActionButtons(movie),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoviePoster(MovieModel movie) {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Placeholder for poster image
            if(movie.poster==null)...[
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2A2A2A),
                      const Color(0xFF1F1F1F),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.movie,
                  color: Color(0xFF666666),
                  size: 32,
                ),
              ),
              // In real app, use: Image.network(movie['poster'], fit: BoxFit.cover)

              // Rating badge
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFD600),
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        movie.userRating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if(movie.poster!=null)
              Image.network(movie.poster),
            // Watched indicator
            if (movie.isWatch)
              Positioned(
                bottom: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C853),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfo(MovieModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              movie.year.toString(),
              style: const TextStyle(
                color: Color(0xFFE50914),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                movie.genreNames.toString(),
                style: const TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: movie.isWatch
                ? const Color(0xFF00C853).withOpacity(0.1)
                : const Color(0xFFFFD600).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: movie.isWatch
                  ? const Color(0xFF00C853).withOpacity(0.3)
                  : const Color(0xFFFFD600).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                movie.isWatch ? Icons.check_circle : Icons.schedule,
                color: movie.isWatch
                    ? const Color(0xFF00C853)
                    : const Color(0xFFFFD600),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                movie.isWatch ? 'Watched' : 'To Watch',
                style: TextStyle(
                  color: movie.isWatch
                      ? const Color(0xFF00C853)
                      : const Color(0xFFFFD600),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Text(
        //   'Added ${movie.release_date}',
        //   style: const TextStyle(
        //     color: Color(0xFF666666),
        //     fontSize: 12,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildActionButtons(MovieModel movie) {
    return Column(
      children: [
        // Mark as watched/unwatched button
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: (movie.isWatch
                    ? const Color(0xFF00C853)
                    : const Color(0xFFFFD600)).withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: movie.isWatch
                ? const Color(0xFF00C853)
                : const Color(0xFFFFD600),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () async {
                // Toggle watched status
                movie.isWatch = !movie.isWatch;
                await widget.isarService.saveMovie(movie);
                setState(() {

                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  movie.isWatch ? Icons.check : Icons.schedule,
                  color: movie.isWatch ? Colors.white : Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // More options button
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                _showMovieOptions(movie);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE50914).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to search/add movie to this folder
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => SearchScreen(isarService: widget.isarService),
            ),
          ).then((value) async {
            await _loadMovies();
          },);
        },
        backgroundColor: const Color(0xFFE50914),
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.add, size: 24),
        label: const Text(
          'Add Movies',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sort Movies',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            // Sort options would go here
            const Text(
              'Sort options coming soon...',
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGridToggle() {
    // Toggle between list and grid view
    CinematicAlerts.showSnackBar(
      context,
      message: 'Grid view coming soon.',
      type: AlertType.success,
    );
  }

  void _showMovieOptions(MovieModel movie) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              movie.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            // ListTile(
            //   leading: const Icon(Icons.edit, color: Color(0xFFE50914)),
            //   title: const Text('Edit Movie', style: TextStyle(color: Colors.white)),
            //   onTap: () => Navigator.pop(context),
            // ),
            ListTile(
              leading: const Icon(Icons.folder, color: Color(0xFFFFD600)),
              title: const Text('Move to Folder', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove from Folder', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}