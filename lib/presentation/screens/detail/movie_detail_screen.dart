import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markmymovie/core/theme/app_theme.dart';
import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/data/models/folder_model.dart';
import 'package:markmymovie/data/models/movie_model.dart';
import 'package:markmymovie/data/models/watch_provider_model.dart';
import 'package:markmymovie/data/services/tmdb_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final IsarService isarService;
  final String? movieId; // TMDB numeric id (when opened from search)
  final String? mediaType; // 'movie' or 'tv' (when opened from search)
  final MovieModel? movieModel; // pre-loaded local movie (when opened from a folder)

  const MovieDetailScreen({
    super.key,
    required this.isarService,
    this.movieId,
    this.mediaType,
    this.movieModel,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

enum _DetailTab { overview, cast, whereToWatch }

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late MovieModel movie;
  bool _isWatched = false;
  bool _isFavorite = false;
  bool isLoaded = false;
  _DetailTab _tab = _DetailTab.overview;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.movieId != null) {
      // Opened from search — full TMDB details (incl. cast/providers/trailer)
      // come back in one call.
      movie = await TmdbService().fetchMovieDetails(
        widget.movieId!,
        mediaType: widget.mediaType ?? 'movie',
      );
    } else {
      // Opened from a saved folder — we only have local fields. Fetch the
      // extras (cast/watch providers/trailer) live and merge them in;
      // degrade quietly if TMDB can't be reached or the title can't be
      // resolved.
      movie = widget.movieModel!;
      try {
        final extras = await TmdbService().fetchExtrasForImdbId(movie.imdbId);
        if (extras != null) {
          movie.cast = extras.cast;
          movie.watchProviders = extras.watchProviders;
          movie.trailer = extras.trailer ?? movie.trailer;
          movie.trailerThumbnail = extras.trailerThumbnail ?? movie.trailerThumbnail;
        }
      } catch (_) {
        // No network / lookup failure — show what we already have locally.
      }
    }

    _isWatched = movie.isWatch;
    isLoaded = true;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: !isLoaded
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandRed),
                strokeWidth: 2.5,
              ),
            )
          : CustomScrollView(
            // controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildStickyThumbnail(),
              _buildMovieInfo(),
              _buildActionButtons(),
              _buildSegmentedTabs(),
              _buildTabContent(),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
    );
  }

  // ---------------------------------------------------------------------
  // Sticky landscape thumbnail (fixed size, pinned — no scroll animation)
  // ---------------------------------------------------------------------

  static const double _thumbnailHeight = 220;

  Widget _buildStickyThumbnail() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickyThumbnailDelegate(
        height: _thumbnailHeight,
        child: _buildThumbnailContent(),
      ),
    );
  }

  Widget _buildThumbnailContent() {
    final thumbnailUrl = (movie.trailerThumbnail?.isNotEmpty ?? false)
        ? movie.trailerThumbnail!
        : movie.poster;
    final hasTrailer = movie.trailer != null && movie.trailer!.isNotEmpty;

    return Container(
      color: AppColors.bg,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (thumbnailUrl.isEmpty)
            Container(
              color: AppColors.surface,
              child: Center(
                child: Icon(Icons.movie_outlined, color: AppColors.textTertiary.withOpacity(0.5), size: 72),
              ),
            )
          else
            CachedNetworkImage(
              imageUrl: thumbnailUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(color: AppColors.surface),
            ),
          // Thin bottom fade so the title block below sits on a clean edge.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0x66000000), AppColors.bg],
                stops: [0.6, 0.85, 1.0],
              ),
            ),
          ),
          if (hasTrailer)
            Center(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _openTrailer(movie.trailer!);
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.overlayScrim,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
                ),
              ),
            ),
          Positioned(
            top: 12,
            left: 12,
            child: _NavGlassButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Row(
              children: [
                _NavGlassButton(
                  icon: _isWatched ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                  color: _isWatched ? AppColors.success : null,
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    movie.isWatch = !_isWatched;
                    if (movie.folderId.isNotEmpty) {
                      await widget.isarService.saveMovie(movie);
                    }
                    setState(() => _isWatched = !_isWatched);
                  },
                ),
                const SizedBox(width: 8),
                _NavGlassButton(
                  icon: _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: _isFavorite ? AppColors.brandRed : null,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() => _isFavorite = !_isFavorite);
                  },
                ),
              ],
            ),
          ),
          if (movie.userRating > 0) Positioned(bottom: 12, right: 12, child: _buildRatingBadge()),
        ],
      ),
    );
  }

  Widget _buildRatingBadge() {
    return GlassMaterial(
      blur: 16,
      tint: AppColors.overlayScrim,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      border: Border.all(color: AppColors.gold.withOpacity(0.5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, color: AppColors.gold, size: 18),
            const SizedBox(width: 5),
            Text(movie.userRating.toStringAsFixed(1), style: AppTextStyles.callout),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Title / meta
  // ---------------------------------------------------------------------

  Widget _buildMovieInfo() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(movie.title, style: AppTextStyles.largeTitle),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                if (movie.year > 0) ...[
                  Text(
                    movie.year.toString(),
                    style: AppTextStyles.callout.copyWith(color: AppColors.brandRed),
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
                _buildPillLabel(movie.type == 'tv' ? 'SHOW' : 'MOVIE'),
                if (movie.originalLanguage.isNotEmpty) ...[
                  const SizedBox(width: AppSpacing.sm),
                  _buildPillLabel(movie.originalLanguage.toUpperCase()),
                ],
              ],
            ),
            if (movie.genreNames.isNotEmpty) ...[
              const SizedBox(height: 14),
              _buildGenreChips(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPillLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(text, style: AppTextStyles.caption),
    );
  }

  Widget _buildGenreChips() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: movie.genreNames.map((genre) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.brandRed.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.brandRed.withOpacity(0.35)),
          ),
          child: Text(genre, style: AppTextStyles.footnote.copyWith(color: AppColors.textPrimary)),
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------

  Widget _buildActionButtons() {
    final hasTrailer = movie.trailer != null && movie.trailer!.isNotEmpty;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
        child: Row(
          children: [
            Expanded(
              child: _PillButton(
                icon: movie.folderId.isNotEmpty ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                label: movie.folderId.isNotEmpty ? 'In Folders' : 'Add to Folder',
                filled: false,
                onPressed: () async {
                  HapticFeedback.selectionClick();
                  final folders = await widget.isarService.getAllFolders();
                  if (mounted) _showFolderOptions(folders);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _PillButton(
                icon: Icons.play_arrow_rounded,
                label: hasTrailer ? 'Watch Trailer' : 'No Trailer',
                filled: true,
                onPressed: hasTrailer
                    ? () {
                        HapticFeedback.mediumImpact();
                        _openTrailer(movie.trailer!);
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Segmented tabs (Overview / Cast / Where to Watch)
  // ---------------------------------------------------------------------

  Widget _buildSegmentedTabs() {
    final tabs = <_DetailTab, String>{
      _DetailTab.overview: 'Overview',
      _DetailTab.cast: 'Cast',
      _DetailTab.whereToWatch: 'Where to Watch',
    };

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xxl, AppSpacing.xl, 0),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: tabs.entries.map((entry) {
              final selected = _tab == entry.key;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_tab == entry.key) return;
                    HapticFeedback.selectionClick();
                    setState(() => _tab = entry.key);
                  },
                  child: AnimatedContainer(
                    duration: AppMotion.fast,
                    curve: AppMotion.standard,
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.surfaceRaised : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: selected ? Border.all(color: AppColors.borderStrong) : null,
                    ),
                    child: Text(
                      entry.value,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.footnote.copyWith(
                        color: selected ? AppColors.textPrimary : AppColors.textTertiary,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return SliverToBoxAdapter(
      child: AnimatedSwitcher(
        duration: AppMotion.medium,
        switchInCurve: AppMotion.springOut,
        switchOutCurve: AppMotion.standard,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).animate(animation),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(_tab),
          child: switch (_tab) {
            _DetailTab.overview => _buildOverviewTab(),
            _DetailTab.cast => _buildCastTab(),
            _DetailTab.whereToWatch => _buildWhereToWatchTab(),
          },
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (movie.plotOverview.isNotEmpty)
            Text(movie.plotOverview, style: AppTextStyles.body)
          else
            Text('No overview available.', style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.xxl),
          _buildDetailsCard(),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    final rows = <MapEntry<String, String>>[
      if (movie.originalTitle != movie.title) MapEntry('Original Title', movie.originalTitle),
      if (movie.year > 0) MapEntry('Release Year', movie.year.toString()),
      MapEntry('Media Type', movie.type == 'tv' ? 'TV Show' : 'Movie'),
      if (movie.originalLanguage.isNotEmpty)
        MapEntry('Language', movie.originalLanguage.toUpperCase()),
    ];
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Details', style: AppTextStyles.headline),
          const SizedBox(height: AppSpacing.md),
          for (final row in rows) _buildDetailRow(row.key, row.value),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: AppTextStyles.subhead)),
          Expanded(child: Text(value, style: AppTextStyles.callout)),
        ],
      ),
    );
  }

  Widget _buildCastTab() {
    if (movie.cast.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
        child: Text('No cast information available.', style: AppTextStyles.body),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 0),
      child: Column(
        children: movie.cast.map((member) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 52,
                    height: 52,
                    color: AppColors.surface,
                    child: member.profilePath != null
                        ? CachedNetworkImage(
                            imageUrl: member.profilePath!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person, color: AppColors.textTertiary),
                          )
                        : const Icon(Icons.person, color: AppColors.textTertiary),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: AppTextStyles.callout,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (member.character.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          member.character,
                          style: AppTextStyles.footnote,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWhereToWatchTab() {
    final providers = movie.watchProviders;
    final allOptions = providers == null
        ? <WatchProviderOption>[]
        : [...providers.flatrate, ...providers.rent, ...providers.buy];
    final seen = <String>{};
    final uniqueOptions = allOptions.where((o) => seen.add(o.providerName)).toList();

    if (uniqueOptions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
        child: Text('Not currently available to stream, rent or buy.', style: AppTextStyles.body),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 0),
      child: Wrap(
        spacing: AppSpacing.lg,
        runSpacing: AppSpacing.lg,
        children: uniqueOptions.map((option) {
          return SizedBox(
            width: 64,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Container(
                    width: 56,
                    height: 56,
                    color: AppColors.surface,
                    child: option.logoPath != null
                        ? CachedNetworkImage(imageUrl: option.logoPath!, fit: BoxFit.cover)
                        : const Icon(Icons.live_tv, color: AppColors.textTertiary, size: 22),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  option.providerName,
                  style: AppTextStyles.footnote,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _openTrailer(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open trailer.'), backgroundColor: AppColors.brandRed),
        );
      }
    }
  }

  // ---------------------------------------------------------------------
  // Add-to-folder sheet
  // ---------------------------------------------------------------------

  void _showFolderOptions(List<FolderModel> folders) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text('Add to Folders', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    ...List.generate(folders.length, (index) {
                      bool isExist = movie.folderId.isNotEmpty && movie.folderId == folders[index].id;
                      return GestureDetector(
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          await widget.isarService.addMovieToFolder(
                            folderId: folders[index].id,
                            movie: movie,
                          );
                          if (context.mounted) Navigator.pop(context);
                          setState(() {});
                        },
                        child: _buildFolderOption(folders[index].name, isExist),
                      );
                    }),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Create New Folder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
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
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.brandRed.withOpacity(0.08) : AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: isSelected ? AppColors.brandRed.withOpacity(0.5) : AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              folderName,
              style: AppTextStyles.callout.copyWith(
                color: isSelected ? AppColors.brandRed : AppColors.textPrimary,
              ),
            ),
          ),
          Icon(
            isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
            color: isSelected ? AppColors.brandRed : AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}

/// Fixed-size pinned header — minExtent == maxExtent so it never resizes,
/// fades, or parallaxes as the sheet scrolls beneath it; it simply stays put.
class _StickyThumbnailDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  _StickyThumbnailDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(covariant _StickyThumbnailDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

/// Frosted-glass circular icon button used in the nav bar over hero imagery.
class _NavGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const _NavGlassButton({required this.icon, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return GlassMaterial(
      blur: 20,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: SizedBox(
        width: 40,
        height: 40,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          icon: Icon(icon, color: color ?? AppColors.textPrimary.withOpacity(0.9), size: 19),
        ),
      ),
    );
  }
}

/// iOS-style pill action button — filled (primary) or outlined (secondary).
class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback? onPressed;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return SizedBox(
      height: 48,
      child: filled
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label, style: AppTextStyles.callout.copyWith(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: disabled ? AppColors.surfaceRaised : AppColors.brandRed,
                disabledBackgroundColor: AppColors.surfaceRaised,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20, color: AppColors.textPrimary),
              label: Text(label, style: AppTextStyles.callout),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
              ),
            ),
    );
  }
}
