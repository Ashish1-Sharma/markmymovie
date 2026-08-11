import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/data/models/movie_card_model.dart';
import 'package:markmymovie/presentation/screens/detail/movie_detail_screen.dart';

import '../../../data/services/tmdb_service.dart';

// Brand palette (Watchstash) — near-black background, brand red accent,
// off-white text, muted gray subtext.
const _bgColor = Color(0xFF0A0808);
const _surfaceColor = Color(0xFF161414);
const _borderColor = Color(0x1AF5F5F5); // off-white @ 10%
const _brandRed = Color(0xFFDE2028);
const _textColor = Color(0xFFF5F5F5);
const _subtextColor = Color(0xFF969496);

class SearchScreen extends StatefulWidget {
  final IsarService isarService;
  const SearchScreen({super.key, required this.isarService});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;
  List<MovieCardModel> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  bool _hasError = false;
  final TmdbService _tmdbService = TmdbService();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (_searchController.text.trim().isNotEmpty) {
        _performSearch(_searchController.text.trim());
      } else {
        setState(() {
          _searchResults.clear();
          _hasSearched = false;
          _hasError = false;
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _hasError = false;
    });

    try {
      final results = await _tmdbService.searchMovies(query, widget.isarService);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _searchResults.clear();
        _isLoading = false;
        _hasError = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Search failed. Please try again.'),
          backgroundColor: _brandRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        title: const Text(
          'Search',
          style: TextStyle(color: _textColor, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: _textColor),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: const TextStyle(color: _textColor, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search movies & shows…',
          hintStyle: const TextStyle(color: _subtextColor),
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: _subtextColor, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: _subtextColor, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_brandRed),
        ),
      );
    }

    if (!_hasSearched) {
      return _buildMessageState(
        icon: Icons.movie_outlined,
        title: 'Find something to watch',
        subtitle: 'Search for any movie or show to add to your folders',
      );
    }

    if (_searchResults.isEmpty && !_hasError) {
      return _buildMessageState(
        icon: Icons.search_off,
        title: 'No results',
        subtitle: 'Try a different title or spelling',
      );
    }

    return _buildSearchResults();
  }

  Widget _buildMessageState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: _subtextColor.withOpacity(0.6)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: _subtextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return MovieCard(
          movie: _searchResults[index],
          isarService: widget.isarService,
          searchFocusNode: _searchFocusNode,
        );
      },
    );
  }
}

class MovieCard extends StatelessWidget {
  final MovieCardModel movie;
  final IsarService isarService;
  final FocusNode searchFocusNode;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isarService,
    required this.searchFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        searchFocusNode.unfocus();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(
              isarService: isarService,
              movieId: movie.tmdbId,
              mediaType: movie.mediaType,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: movie.poster.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: movie.poster,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildPosterPlaceholder(),
                      errorWidget: (context, url, error) => _buildPosterPlaceholder(),
                    )
                  : _buildPosterPlaceholder(),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: _textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        if (movie.year.isNotEmpty) movie.year,
                        movie.mediaType == 'tv' ? 'Show' : 'Movie',
                      ].join(' · '),
                      style: const TextStyle(
                        color: _subtextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterPlaceholder() {
    return Container(
      color: _bgColor,
      alignment: Alignment.center,
      child: const Icon(Icons.movie_outlined, color: _subtextColor, size: 36),
    );
  }
}
