import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markmymovie/core/theme/app_theme.dart';
import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/data/models/folder_model.dart';
import 'package:markmymovie/data/models/movie_model.dart';
import 'package:markmymovie/data/models/user_model.dart';
import 'package:markmymovie/data/repositories/auth_repository.dart';
import 'package:markmymovie/presentation/screens/detail/movie_detail_screen.dart';
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
  late final AnimationController _entranceController;

  final List<MovieModel> _recentMovies = [];
  final List<FolderModel> _folders = [];
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _loadDetails(initial: true);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  /// Pulls everything the home screen renders. Kept in one place so the
  /// pull-to-refresh and the return-from-subscreen paths stay identical.
  Future<void> _loadDetails({bool initial = false}) async {
    try {
      final results = await Future.wait([
        widget.isarService.getFirstFiveFolders(),
        widget.isarService.getRecentlyModifiedMovies(limit: 10),
        AuthRepository.instance.getStoredUser(),
      ]);

      if (!mounted) return;

      setState(() {
        _folders
          ..clear()
          ..addAll(results[0] as List<FolderModel>);
        _recentMovies
          ..clear()
          ..addAll(results[1] as List<MovieModel>);
        _user = results[2] as UserModel?;
      });
    } catch (e) {
      // A storage/session failure must not leave the screen stuck on the
      // skeleton — fall through and render the empty state instead.
      debugPrint('[HomeScreen] load failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        if (initial) _entranceController.forward();
      }
    }
  }

  Future<void> _openAndRefresh(Widget screen) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
    await _loadDetails();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  /// First name only — full names overflow the greeting row on narrow
  /// phones, and the row already ellipsizes as a second line of defence.
  String get _displayName {
    final name = _user?.name.trim() ?? '';
    if (name.isEmpty) return 'there';
    return name.split(RegExp(r'\s+')).first;
  }

  bool get _isLibraryEmpty => _folders.isEmpty && _recentMovies.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _loadDetails,
          color: AppColors.brandRed,
          backgroundColor: AppColors.surface,
          child: CustomScrollView(
            // Platform-default physics; AlwaysScrollable only so
            // pull-to-refresh still works when the content is short.
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // SliverToBoxAdapter(child: _stagger(0, _buildTopBar())),
              SliverToBoxAdapter(child: _stagger(1, _buildGreeting())),
              SliverToBoxAdapter(child: _stagger(2, _buildSearchBar())),
              if (_isLoading)
                SliverToBoxAdapter(child: _buildSkeleton())
              else ...[
                if (_recentMovies.isNotEmpty)
                  SliverToBoxAdapter(child: _stagger(3, _buildRecentSection())),
                if (_folders.isNotEmpty)
                  SliverToBoxAdapter(child: _stagger(4, _buildCollectionsSection())),
                if (_isLibraryEmpty)
                  SliverToBoxAdapter(child: _stagger(3, _buildEmptyState())),
              ],
              // Clears the FAB so the last card is never trapped under it.
              const SliverToBoxAdapter(child: SizedBox(height: 96)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.mediumImpact();
          _openAndRefresh(AddFolderScreen(isarService: widget.isarService));
        },
        backgroundColor: AppColors.brandRed,
        foregroundColor: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        icon: const Icon(Icons.create_new_folder_rounded, size: 21),
        label: const Text(
          'New Folder',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  /// Shown only when there is genuinely nothing to render, so the screen
  /// isn't just a greeting over empty space. Deliberately copy-only — the
  /// FAB is the call to action.
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 56, AppSpacing.xl, 0),
      child: Column(
        children: [
          const _BlendedMascot(
            asset: 'assets/add_movie_mascott.png',
            width: 168,
            height: 132,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Start building your stash',
            style: AppTextStyles.headline,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            'Create a folder to organize the movies you love.',
            style: AppTextStyles.footnote,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Staggered fade + rise, so sections settle in one after another rather
  /// than the whole page popping at once.
  Widget _stagger(int index, Widget child) {
    final start = (index * 0.09).clamp(0.0, 0.7);
    final animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, (start + 0.5).clamp(0.0, 1.0), curve: AppMotion.springOut),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
            .animate(animation),
        child: child,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Top bar
  // ---------------------------------------------------------------------

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.brandRed.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.brandRed.withOpacity(0.45)),
            ),
            child: const Icon(Icons.local_movies_rounded, color: AppColors.brandRed, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.7,
                  ),
                  children: [
                    TextSpan(text: 'Watch', style: TextStyle(color: Colors.white)),
                    TextSpan(text: 'stash', style: TextStyle(color: AppColors.brandRed)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _IconTile(
            icon: Icons.search_rounded,
            onTap: () => _openAndRefresh(SearchScreen(isarService: widget.isarService)),
          ),
          const SizedBox(width: AppSpacing.sm),
          _IconTile(
            icon: Icons.settings_rounded,
            onTap: () => _openAndRefresh(SettingsScreen(isarService: widget.isarService)),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Greeting + mascot
  // ---------------------------------------------------------------------

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$_greeting, $_displayName! 👋',
                  style: AppTextStyles.largeTitle.copyWith(fontSize: 24),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'Your personal movie stash',
                  style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const _BlendedMascot(asset: 'assets/search_mascott.png', width: 132, height: 108),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Search bar
  // ---------------------------------------------------------------------

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            _openAndRefresh(SearchScreen(isarService: widget.isarService));
          },
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.brandRed, size: 22),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Search movies, actors, genres...',
                    style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Section header
  // ---------------------------------------------------------------------

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onViewAll,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xxl, AppSpacing.lg, AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: AppColors.brandRed, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.footnote,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onViewAll != null) ...[
            const SizedBox(width: AppSpacing.sm),
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                onViewAll();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.brandRed,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.brandRed,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, color: AppColors.brandRed, size: 17),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Recently saved
  // ---------------------------------------------------------------------

  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.movie_filter_rounded,
          title: 'Recently Saved',
          subtitle: 'Your latest movies',
          onViewAll: _folders.isEmpty
              ? null
              : () => _openAndRefresh(AllFoldersScreen(isarService: widget.isarService)),
        ),
        SizedBox(
          // Poster (124 * 3/2 = 186) + gap + two text lines.
          height: 186 + 8 + 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: _recentMovies.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) => _buildMovieCard(_recentMovies[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(MovieModel movie) {
    return SizedBox(
      width: 124,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                _openAndRefresh(MovieDetailScreen(
                  isarService: widget.isarService,
                  movieModel: movie,
                ));
              },
              child: SizedBox(
                width: 124,
                height: 186,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildPoster(movie),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          movie.isWatch ? Icons.check_rounded : Icons.bookmark_rounded,
                          color: movie.isWatch ? AppColors.success : AppColors.gold,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            movie.title,
            style: AppTextStyles.callout.copyWith(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            movie.year > 0 ? '${movie.year}' : '—',
            style: AppTextStyles.footnote,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPoster(MovieModel movie) {
    if (movie.poster.isEmpty || !movie.poster.startsWith('http')) {
      return _buildPosterFallback(movie);
    }
    return CachedNetworkImage(
      imageUrl: movie.poster,
      fit: BoxFit.cover,
      fadeInDuration: AppMotion.fast,
      placeholder: (_, __) => Container(color: AppColors.surfaceRaised),
      errorWidget: (_, __, ___) => _buildPosterFallback(movie),
    );
  }

  Widget _buildPosterFallback(MovieModel movie) {
    return Container(
      color: AppColors.surfaceRaised,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_outlined, color: AppColors.textTertiary.withOpacity(0.6), size: 28),
          const SizedBox(height: AppSpacing.sm),
          Text(
            movie.title,
            style: AppTextStyles.footnote.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Collections
  // ---------------------------------------------------------------------

  Widget _buildCollectionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.folder_rounded,
          title: 'Your Collections',
          subtitle: 'Organize movies your way',
          onViewAll: () => _openAndRefresh(AllFoldersScreen(isarService: widget.isarService)),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: _folders.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) => _buildFolderCard(_folders[index]),
        ),
      ],
    );
  }

  Widget _buildFolderCard(FolderModel folder) {
    final movies = folder.movieIds;
    final count = movies.length;
    final accent = Color(folder.colorValue);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          _openAndRefresh(FolderListScreen(
            isarService: widget.isarService,
            folderName: folder.name,
            folderIcon: Icon(
              IconData(folder.iconCodePoint, fontFamily: folder.iconFontFamily),
              color: accent,
              size: 24,
            ),
            id: folder.id,
          ));
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      IconData(folder.iconCodePoint, fontFamily: folder.iconFontFamily),
                      color: accent,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          folder.name,
                          style: AppTextStyles.headline,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          count == 1 ? '1 movie' : '$count movies',
                          style: AppTextStyles.footnote,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    constraints: const BoxConstraints(minWidth: 34),
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.brandRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: AppColors.brandRed.withOpacity(0.35)),
                    ),
                    child: Text(
                      // Guard against a 4-digit count blowing out the row.
                      count > 999 ? '999+' : '$count',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.brandRed,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 22),
                ],
              ),
              // if (movies.isNotEmpty) ...[
              //   const SizedBox(height: AppSpacing.md),
              //   _buildPosterStrip(movies),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  /// A row of up to 5 poster thumbnails. Uses LayoutBuilder so the tiles
  /// divide the *actual* available width — no fixed sizes that overflow on
  /// small screens.
  Widget _buildPosterStrip(List<MovieModel> movies) {
    const maxTiles = 5;
    final shown = movies.take(maxTiles).toList();
    final extra = movies.length - shown.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSpacing.sm;
        final tileWidth = (constraints.maxWidth - gap * (maxTiles - 1)) / maxTiles;
        final tileHeight = tileWidth * 0.78;

        return Row(
          children: List.generate(shown.length, (i) {
            final isLast = i == shown.length - 1;
            return Padding(
              padding: EdgeInsets.only(right: i == maxTiles - 1 ? 0 : gap),
              child: SizedBox(
                width: tileWidth,
                height: tileHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: AppColors.surfaceRaised),
                      if (shown[i].poster.startsWith('http'))
                        CachedNetworkImage(
                          imageUrl: shown[i].poster,
                          fit: BoxFit.cover,
                          fadeInDuration: AppMotion.fast,
                          errorWidget: (_, __, ___) => const SizedBox.shrink(),
                        )
                      else
                        const Icon(Icons.movie_outlined, color: AppColors.textTertiary, size: 16),
                      if (isLast && extra > 0)
                        Container(
                          color: Colors.black.withOpacity(0.65),
                          alignment: Alignment.center,
                          child: Text(
                            '+$extra',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // ---------------------------------------------------------------------
  // Loading skeleton
  // ---------------------------------------------------------------------

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xxl, AppSpacing.lg, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SkeletonBox(width: 170, height: 22),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 186,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, __) => const _SkeletonBox(width: 124, height: 186),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _SkeletonBox(width: 190, height: 22),
          const SizedBox(height: AppSpacing.lg),
          const _SkeletonBox(width: double.infinity, height: 92),
          const SizedBox(height: AppSpacing.md),
          const _SkeletonBox(width: double.infinity, height: 92),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Bottom nav
  // ---------------------------------------------------------------------

  Widget _buildBottomNav() {
    final items = <(IconData, String, VoidCallback?)>[
      (Icons.home_rounded, 'Home', null),
      (
        Icons.explore_outlined,
        'Discover',
        () => _openAndRefresh(SearchScreen(isarService: widget.isarService))
      ),
      (
        Icons.folder_outlined,
        'Collections',
        () => _openAndRefresh(AllFoldersScreen(isarService: widget.isarService))
      ),
      (
        Icons.settings_outlined,
        'Settings',
        () => _openAndRefresh(SettingsScreen(isarService: widget.isarService))
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: items.map((item) {
              final selected = item.$3 == null;
              return Expanded(
                child: InkWell(
                  onTap: item.$3 == null
                      ? null
                      : () {
                          HapticFeedback.selectionClick();
                          item.$3!();
                        },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.$1,
                        size: 23,
                        color: selected ? AppColors.brandRed : AppColors.textTertiary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? AppColors.brandRed : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------
// Shared bits
// -----------------------------------------------------------------------

/// The mascot PNGs ship with a baked-in black backdrop and a soft glow.
/// A radial alpha mask dissolves those edges into the page so the artwork
/// reads as floating rather than as a visible rectangle.
class _BlendedMascot extends StatelessWidget {
  final String asset;
  final double width;
  final double height;

  const _BlendedMascot({required this.asset, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (rect) => const RadialGradient(
          center: Alignment.center,
          radius: 0.72,
          colors: [Colors.white, Colors.white, Colors.transparent],
          stops: [0.0, 0.6, 1.0],
        ).createShader(rect),
        child: Image.asset(
          asset,
          width: width,
          height: height,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconTile({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 21),
        ),
      ),
    );
  }
}

/// Pulsing placeholder block used by the first-load skeleton.
class _SkeletonBox extends StatefulWidget {
  final double width;
  final double height;

  const _SkeletonBox({required this.width, required this.height});

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1100),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
