import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/data/models/folder_model.dart';
import 'package:markmymovie/data/models/movie_model.dart';
import 'package:markmymovie/data/services/tmdb_service.dart';


class MovieDetailScreen extends StatefulWidget {
  final IsarService isarService;
  final String? movieId;
  final MovieModel? movieModel;

  const MovieDetailScreen({
    super.key,
    required this.isarService,
     this.movieId,
     this.movieModel,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
   late MovieModel movie;
  bool _isInFolder = false; // Mock data - check if movie is in any folder
  bool _isWatched = false; // Mock data - check if movie is watched
  bool _isFavorite = false; // Mock data - check if movie is favorite
 bool  isLoaded = false;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollListener();
    _loadData();
  }

  Future<void> _loadData() async{
    if(widget.movieId != null){
      movie = await TmdbService().fetchMovieDetails(widget.movieId ?? '');
    } else{
      movie = widget.movieModel!;
    }

    _isWatched = movie.isWatch;
    isLoaded = true;
    setState(() {

    });
  }
  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      final isScrolled = _scrollController.offset > 200;
      if (isScrolled != _isScrolled) {
        setState(() {
          _isScrolled = isScrolled;
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _buildCinematicTheme(),
      child: !isLoaded ?Center(child: CircularProgressIndicator()) : Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeroAppBar(),
              _buildMovieInfo(),
              _buildActionButtons(),
              _buildPlotSection(),
              _buildDetailsSection(),
              _buildTrailerSection(),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
        // floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  ThemeData _buildCinematicTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.red,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1F1F1F),
    );
  }

  Widget _buildHeroAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      elevation: 0,
      backgroundColor:
          _isScrolled
              ? const Color(0xFF121212).withOpacity(0.95)
              : Colors.transparent,
      leading: _buildAppBarButton(
        icon: Icons.arrow_back,
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        _buildAppBarButton(
          icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: _isFavorite ? const Color(0xFFE50914) : Colors.white70,
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              _isFavorite = !_isFavorite;
            });
          },
        ),
        _buildAppBarButton(
          icon: Icons.share,
          onPressed: () {
            // Share movie functionality
          },
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeroImage(),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _buildAppBarButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color ?? Colors.white70, size: 22),
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background poster with blur effect
        if (movie.poster.isEmpty) ...[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1F1F1F),
                  const Color(0xFF2A2A2A),
                  const Color(0xFF1F1F1F),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(Icons.movie, color: Color(0xFF666666), size: 120),
            ),
          ),
          // In real app: use Image.network(movie.poster) with blur and opacity

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.8),
                  const Color(0xFF121212),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Movie poster in bottom section
          Positioned(
            bottom: 40,
            left: 20,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _buildMoviePoster(),
            ),
          ),
        ],

        Image.network(movie.poster),
        // Rating badge
        Positioned(top: 100, right: 20, child: _buildRatingBadge()),
      ],
    );
  }

  Widget _buildMoviePoster() {
    return Container(
      width: 160,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFFE50914).withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF2A2A2A), const Color(0xFF1F1F1F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(Icons.movie, color: Color(0xFF666666), size: 64),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD600), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD600).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Color(0xFFFFD600), size: 24),
          const SizedBox(width: 6),
          Text(
            movie.userRating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieInfo() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and year
            Text(
              movie.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.0,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  movie.year.toString(),
                  style: const TextStyle(
                    color: Color(0xFFE50914),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Text(
                    movie.type.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Genres
            _buildGenreChips(),

            const SizedBox(height: 20),

            // Language info
            _buildInfoRow(
              'Original Language',
              movie.originalLanguage.toUpperCase(),
            ),
            const SizedBox(height: 8),
            // _buildInfoRow('IMDb ID', movie.imdbId),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          movie.genreNames.map((genre) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFE50914).withOpacity(0.1),
                    const Color(0xFF1F1F1F),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE50914).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                genre,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: Color(0xFFB3B3B3),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            if(movie.folderId.isNotEmpty)
            Expanded(
              child: _buildActionButton(
                icon:
                    _isWatched ? Icons.check_circle : Icons.play_circle_filled,
                label: _isWatched ? 'Watched' : 'Mark as Watched',
                color:
                    _isWatched
                        ? const Color(0xFF00C853)
                        : const Color(0xFFE50914),
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  movie.isWatch = !_isWatched;
                  await widget.isarService.saveMovie(movie);
                  setState(() {
                    _isWatched = !_isWatched;
                  });
                },
              ),
            ),
            if(movie.folderId.isNotEmpty)
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: movie.folderId.isNotEmpty ? Icons.bookmark : Icons.bookmark_border,
                label: movie.folderId.isNotEmpty ? 'In Folders' : 'Add to Folder',
                color:
                movie.folderId.isNotEmpty
                        ? const Color(0xFFFFD600)
                        : const Color(0xFF666666),
                onPressed: () async{
                 final folders = await widget.isarService.getAllFolders();
                  _showFolderOptions(folders);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor:
              color == const Color(0xFFFFD600) ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildPlotSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE50914).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Color(0xFFE50914),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Plot Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                movie.plotOverview,
                style: const TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 16,
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD600).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Color(0xFFFFD600),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Movie Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow('Original Title', movie.originalTitle),
              _buildDetailRow('Release Year', movie.year.toString()),
              _buildDetailRow('Type', movie.type.toUpperCase()),
              _buildDetailRow('TMDb Type', movie.tmdbType),
              _buildDetailRow(
                'Language',
                movie.originalLanguage.toUpperCase(),
              ),
              // _buildDetailRow('IMDb ID', movie.imdbId),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailerSection() {
    if (movie.trailer == null)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE50914).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.play_circle_filled,
                      color: Color(0xFFE50914),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Trailer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.play_circle_filled,
                        color: Color(0xFFE50914),
                        size: 64,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Play Trailer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movie.trailer ?? '',
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
          _showQuickActions();
        },
        backgroundColor: const Color(0xFFE50914),
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.more_horiz, size: 24),
        label: const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showFolderOptions(List<FolderModel> folders) {

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            minChildSize: 0.4,
            builder:
                (context, scrollController) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB3B3B3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Add to Folders',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            ...List.generate(folders.length,  (index) {
                              print(folders[index].id);
                              bool isExist = false;
                              if(movie.folderId.isNotEmpty && movie.folderId == folders[index].id){
                                isExist = true;
                              } else {
                                isExist = false;
                              }
                              return GestureDetector(
                                  onTap: () async {
                                   await widget.isarService.addMovieToFolder(folderId: folders[index].id, movie: movie);
                                   Navigator.pop(context);
                                   setState(() {

                                   });
                                  },
                                  child: _buildFolderOption(folders[index].name,isExist));
                            },),
                            // _buildFolderOption('🍿 Weekend Watch', true),
                            // _buildFolderOption('🚀 Sci-Fi Favorites', false),
                            // _buildFolderOption('⭐ Must Watch Soon', false),
                            // _buildFolderOption('🎭 Classics', false),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.add),
                              label:  Text('Create New Folder'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE50914),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
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

  Widget _buildFolderOption(String folderName, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color:
            isSelected
                ? const Color(0xFFE50914).withOpacity(0.1)
                : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  folderName,
                  style: TextStyle(
                    color:
                        isSelected ? const Color(0xFFE50914) : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Color(0xFFE50914))
              else
                const Icon(
                  Icons.add_circle_outline,
                  color: Color(0xFFB3B3B3),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.edit, color: Color(0xFFFFD600)),
                  title: const Text(
                    'Edit Movie',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.share, color: Color(0xFF00C853)),
                  title: const Text(
                    'Share Movie',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Remove Movie',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }
}
