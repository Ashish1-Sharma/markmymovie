import 'package:flutter/material.dart';
import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/data/models/folder_model.dart';
import 'package:markmymovie/data/models/movie_model.dart';
import 'package:markmymovie/presentation/screens/folders/add_folder_screen.dart';
import 'package:markmymovie/presentation/screens/folders/all_folders_screen.dart';
import 'package:markmymovie/presentation/screens/folders/folder_list_screen.dart';
import 'package:markmymovie/presentation/screens/settings/settings_screen.dart';

import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final IsarService isarService;
  const HomeScreen({super.key, required this.isarService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock data - replace with actual data from your models
  final List<MovieModel> _recentMovies = [];

  final List<FolderModel> _folders = [];
  Future<void> loadDetails() async {
    _folders.clear();
    _recentMovies.clear();
    final response = await widget.isarService.getFirstFiveFolders();
    final moviesResponse = await widget.isarService.getRecentlyModifiedMovies();
    _folders.addAll(response);
    _recentMovies.addAll(moviesResponse);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
    loadDetails();
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
      child: RefreshIndicator(
        onRefresh: () async {
          await loadDetails();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF121212), // Theater-like background
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildAppBar(),
                  // _buildQuickStats(),
                  if (_recentMovies.isNotEmpty) _buildRecentMovies(),
                  _buildFoldersSection(),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ), // Bottom padding
                ],
              ),
            ),
          ),
          floatingActionButton: _buildFloatingActionButton(),
        ),
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
        bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE50914), // Netflix red
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: const Color(0xFFE50914).withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE50914).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE50914).withOpacity(0.3),
              ),
            ),
            child: const Icon(
              Icons.local_movies,
              color: Color(0xFFE50914),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'MarkMyMovie',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Navigate to search
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => SearchScreen(isarService: widget.isarService),
              ),
            ).then((value) async {
              await loadDetails();
            },);
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
            child: const Icon(Icons.search, color: Colors.white70, size: 20),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            // Navigate to settings
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) =>
                        SettingsScreen(isarService: widget.isarService),
              ),
            ).then((value) async {
              await loadDetails();
            },);
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
            child: const Icon(Icons.settings, color: Colors.white70, size: 20),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildQuickStats() {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🎬 Your Movie Journey',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Movies Saved', '147', Icons.bookmark),
                  _buildStatDivider(),
                  _buildStatItem('Folders', '8', Icons.folder),
                  _buildStatDivider(),
                  _buildStatItem('To Watch', '23', Icons.schedule),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF121212).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFFE50914), size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFFE50914).withOpacity(0.3),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildRecentMovies() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recently Added',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFFE50914),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _recentMovies.length,
              itemBuilder: (context, index) {
                final movie = _recentMovies[index];
                return _buildMovieCard(movie, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(MovieModel movie, int index) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1F1F1F),
                            const Color(0xFF2A2A2A),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: _buildPosterImage(movie),
                    ),

                    // Gradient overlay for better text readability
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                    // Bookmark icon
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.bookmark,
                          color: Color(0xFFFFD600),
                          size: 16,
                        ),
                      ),
                    ),

                    // Rating badge (if available)
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            movie.year?.toString() ?? 'Unknown',
            style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Separate method to handle poster image with error handling
  Widget _buildPosterImage(MovieModel movie) {
    // Check if poster URL is valid
    if (movie.poster == null ||
        movie.poster!.isEmpty ||
        !movie.poster!.startsWith('http')) {
      return _buildPosterPlaceholder(movie);
    }

    return Image.network(
      movie.poster!,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildPosterPlaceholder(movie);
      },
    );
  }

  // Loading placeholder while image loads
  Widget _buildLoadingPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1F1F1F), const Color(0xFF2A2A2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFFE50914).withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Beautiful placeholder when poster fails to load
  Widget _buildPosterPlaceholder(MovieModel movie) {
    // Generate a color based on movie title for variety
    final colors = [
      const Color(0xFFE50914), // Netflix red
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF3F51B5), // Indigo
      const Color(0xFF2196F3), // Blue
      const Color(0xFF009688), // Teal
      const Color(0xFF4CAF50), // Green
      const Color(0xFFFF9800), // Orange
    ];

    final colorIndex = movie.title.hashCode.abs() % colors.length;
    final accentColor = colors[colorIndex];

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1F1F1F), const Color(0xFF2A2A2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _MoviePosterPatternPainter(accentColor),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Movie icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: accentColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(Icons.movie, color: accentColor, size: 24),
                ),

                const SizedBox(height: 8),

                // Movie title (truncated)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    movie.title,
                    style: TextStyle(
                      color: accentColor.withOpacity(0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 4),

                // No poster text
                Text(
                  'No Poster',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoldersSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Folders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => AllFoldersScreen(isarService: widget.isarService)
                      ),
                    ).then((value) async {
                      await loadDetails();
                    },);
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFFE50914),
                    size: 18,
                  ),
                  iconAlignment: IconAlignment.end,
                  label: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFFE50914),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _folders.length,
            itemBuilder: (context, index) {
              final folder = _folders[index];
              return _buildFolderCard(folder, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFolderCard(FolderModel folder, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to folder detail
            print(folder.movieIds);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => FolderListScreen(
                      isarService: widget.isarService,
                      folderName: folder.name,
                      folderIcon: Icon(
                        IconData(
                          folder.iconCodePoint,
                          fontFamily: folder.iconFontFamily,
                        ),
                        color: Color(folder.colorValue),
                        size: 24,
                      ),
                      id: folder.id,
                    ),
              ),
            ).then((value) async {
              await loadDetails();
            },);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    IconData(
                      folder.iconCodePoint,
                      fontFamily: folder.iconFontFamily,
                    ),
                    color: Color(folder.colorValue),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        folder.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${folder.movieIds.length} movies',
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE50914).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE50914).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${folder.movieIds.length}',
                    style: const TextStyle(
                      color: Color(0xFFE50914),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFB3B3B3),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
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
          // Navigate to search/add movie
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen(isarService: widget.isarService),));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => AddFolderScreen(isarService: widget.isarService),
            ),
          ).then((value) async {
            await loadDetails();
          },);
        },
        backgroundColor: const Color(0xFFE50914),
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.add, size: 24),
        label: const Text(
          'Add Folder',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// Custom painter for background pattern
class _MoviePosterPatternPainter extends CustomPainter {
  final Color color;

  _MoviePosterPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    // Draw diagonal lines pattern
    for (int i = 0; i < size.width + size.height; i += 20) {
      canvas.drawLine(Offset(i.toDouble(), 0), Offset(0, i.toDouble()), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Alternative simpler placeholder (if you don't want the custom painter)
Widget _buildSimplePosterPlaceholder(MovieModel movie) {
  final colors = [
    const Color(0xFFE50914),
    const Color(0xFF9C27B0),
    const Color(0xFF3F51B5),
    const Color(0xFF009688),
  ];

  final colorIndex = movie.title.hashCode.abs() % colors.length;
  final accentColor = colors[colorIndex];

  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [const Color(0xFF1F1F1F), accentColor.withOpacity(0.1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie, color: accentColor.withOpacity(0.6), size: 32),
          const SizedBox(height: 8),
          Text(
            'No Image',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}
