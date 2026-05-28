import 'package:flutter/material.dart';
import 'dart:async';

import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/data/models/movie_card_model.dart';
import 'package:markmymovie/data/models/movie_model.dart';
import 'package:markmymovie/presentation/screens/detail/movie_detail_screen.dart';

import '../../../data/services/tmdb_service.dart';

class SearchScreen extends StatefulWidget {
  final IsarService isarService;
  const SearchScreen({super.key,required this.isarService});

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
  final TmdbService _tmdbService = TmdbService();

  Future<void> _getMockMovies(String query) async {
    final results = await _tmdbService.searchMovies(query,widget.isarService);
    // _searchResults = results;

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
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
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      // TODO: Replace with your actual TMDb API call
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call

      // Mock data - replace with actual API response
      _getMockMovies(query);

      setState(() {
        // _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _searchResults.clear();
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  // Mock data - replace with your actual TMDb API integration

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Theater-like background
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'Search Movies',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F), // Card background
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(
                hintText: 'Search for movies...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.7),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                  },
                )
                    : null,
              ),
            ),
          ),

          // Content Area
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE50914)), // Netflix red
        ),
      );
    }

    if (!_hasSearched) {
      return _buildEmptyState();
    }

    if (_searchResults.isEmpty) {
      return _buildNoResultsState();
    }

    return _buildSearchResults();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Discover Your Next Movie',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search for any movie to add to your collection',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Movies Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: _searchResults[index],isarService: widget.isarService,searchFocusNode: _searchFocusNode,);
      },
    );
  }
}

class MovieCard extends StatefulWidget {
  final MovieCardModel movie;
  final IsarService isarService;
  final FocusNode searchFocusNode;

  const MovieCard({super.key, required this.movie,required this.isarService,required this.searchFocusNode});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.searchFocusNode.unfocus();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieDetailScreen(isarService: widget.isarService, movieId: widget.movie.imdbID),));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F), // Card background
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: widget.movie.poster != null
                      ? Image.network(
                    widget.movie.poster,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPosterPlaceholder();
                    },
                  )
                      : _buildPosterPlaceholder(),
                ),
              ),
            ),

            // Movie Info
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      widget.movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Rating
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       Icons.star,
                    //       color: Color(0xFFFFD600), // Amber for ratings
                    //       size: 16,
                    //     ),
                    //     const SizedBox(width: 4),
                    //     Text(
                    //       widget.movie.userRating.toStringAsFixed(1),
                    //       style: TextStyle(
                    //         color: Colors.white.withOpacity(0.8),
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
      color: Colors.grey[800],
      child: const Center(
        child: Icon(
          Icons.movie,
          color: Colors.white54,
          size: 48,
        ),
      ),
    );
  }
}
