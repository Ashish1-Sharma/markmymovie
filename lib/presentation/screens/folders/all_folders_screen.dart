import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/data/models/folder_model.dart';
import 'package:markmymovie/presentation/screens/folders/folder_list_screen.dart';

class AllFoldersScreen extends StatefulWidget {
  final IsarService isarService;

  const AllFoldersScreen({super.key, required this.isarService});

  @override
  State<AllFoldersScreen> createState() => _AllFoldersScreenState();
}

class _AllFoldersScreenState extends State<AllFoldersScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _staggerController;
  late Animation<double> _fadeAnimation;

  // View mode: grid or list
  bool _isGridView = true;

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  // Mock folder data - replace with actual data from your models
  List<FolderModel> _allFolders = [];

  // List<FolderModel> get _filteredFolders {
  //   if (_searchQuery.isEmpty) {
  //     return _allFolders;
  //   }
  //   return _allFolders.where((folder) {
  //     return folder['name']
  //         .toString()
  //         .toLowerCase()
  //         .contains(_searchQuery.toLowerCase()) ||
  //         folder['description']
  //             .toString()
  //             .toLowerCase()
  //             .contains(_searchQuery.toLowerCase());
  //   }).toList();
  // }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    _allFolders.clear();
    _allFolders = await widget.isarService.getAllFolders();
    setState(() {});
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _staggerController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _staggerController.dispose();
    _searchController.dispose();
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
              _buildSearchBar(),
              // _buildFolderStats(),
              _buildFoldersGrid(),
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
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: const Color(0xFF121212).withOpacity(0.95),
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
          child: const Icon(Icons.arrow_back, color: Colors.white70, size: 20),
        ),
      ),
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
              Icons.folder_special,
              color: Color(0xFFE50914),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'All Folders',
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
            HapticFeedback.lightImpact();
            setState(() {
              _isSearching = !_isSearching;
            });
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  _isSearching
                      ? const Color(0xFFE50914)
                      : const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.search,
              color: _isSearching ? Colors.white : Colors.white70,
              size: 20,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              _isGridView = !_isGridView;
            });
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
            child: Icon(
              _isGridView ? Icons.view_list : Icons.grid_view,
              color: Colors.white70,
              size: 20,
            ),
          ),
        ),
        // IconButton(
        //   onPressed: () => _showSortOptions(),
        //   icon: Container(
        //     padding: const EdgeInsets.all(8),
        //     decoration: BoxDecoration(
        //       color: const Color(0xFF1F1F1F),
        //       borderRadius: BorderRadius.circular(10),
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black.withOpacity(0.3),
        //           blurRadius: 8,
        //           offset: const Offset(0, 2),
        //         ),
        //       ],
        //     ),
        //     child: const Icon(
        //       Icons.sort,
        //       color: Colors.white70,
        //       size: 20,
        //     ),
        //   ),
        // ),
        // const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildSearchBar() {
    if (!_isSearching)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search folders...',
              hintStyle: const TextStyle(color: Color(0xFFB3B3B3)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFFE50914)),
              suffixIcon:
                  _searchQuery.isNotEmpty
                      ? IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                        icon: const Icon(Icons.clear, color: Color(0xFFB3B3B3)),
                      )
                      : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
      ),
    );
  }

  // Widget _buildFolderStats() {
  //   final totalFolders = _allFolders.length;
  //   final totalMovies = _allFolders.fold(
  //       0, (sum, folder) => sum + (folder['count'] as int));
  //   final recentlyUpdated = _allFolders.where((folder) =>
  //   folder['lastUpdated'].toString().contains('hour') ||
  //       folder['lastUpdated'].toString().contains('Just now')).length;
  //
  //   return SliverToBoxAdapter(
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       child: Container(
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             colors: [
  //               const Color(0xFFE50914).withOpacity(0.1),
  //               const Color(0xFF1F1F1F),
  //             ],
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //           ),
  //           borderRadius: BorderRadius.circular(16),
  //           border: Border.all(
  //             color: const Color(0xFFE50914).withOpacity(0.2),
  //             width: 1,
  //           ),
  //           boxShadow: [
  //             BoxShadow(
  //               color: const Color(0xFFE50914).withOpacity(0.1),
  //               blurRadius: 20,
  //               offset: const Offset(0, 8),
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             _buildStatItem('Folders', totalFolders.toString(), Icons.folder),
  //             _buildStatDivider(),
  //             _buildStatItem(
  //                 'Total Movies', totalMovies.toString(), Icons.movie),
  //             _buildStatDivider(),
  //             _buildStatItem(
  //                 'Recent Updates', recentlyUpdated.toString(), Icons.schedule),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 11),
          textAlign: TextAlign.center,
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

  Widget _buildFoldersGrid() {
    final folders = _allFolders;

    if (folders.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: const Color(0xFFB3B3B3).withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No folders found',
                  style: TextStyle(
                    color: const Color(0xFFB3B3B3).withOpacity(0.7),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your search terms',
                  style: TextStyle(
                    color: const Color(0xFFB3B3B3).withOpacity(0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _isGridView ? _buildGridView(folders) : _buildListView(folders);
  }

  Widget _buildGridView(List<FolderModel> folders) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.95,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return AnimatedBuilder(
            animation: _staggerController,
            builder: (context, child) {
              final animationValue = Curves.easeOutBack.transform(
                ((_staggerController.value - (index * 0.1)).clamp(0.0, 1.0)),
              );
              return Transform.scale(
                scale: animationValue,
                child: _buildFolderGridCard(folders[index]),
              );
            },
          );
        }, childCount: folders.length),
      ),
    );
  }

  Widget _buildListView(List<FolderModel> folders) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return AnimatedBuilder(
            animation: _staggerController,
            builder: (context, child) {
              final animationValue = Curves.easeOutBack.transform(
                ((_staggerController.value - (index * 0.05)).clamp(0.0, 1.0)),
              );
              return Transform.translate(
                offset: Offset(0, 50 * (1 - animationValue)),
                child: Opacity(
                  opacity: animationValue,
                  child: _buildFolderListCard(folders[index]),
                ),
              );
            },
          );
        }, childCount: folders.length),
      ),
    );
  }

  Widget _buildFolderGridCard(FolderModel folder) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (Color(folder.iconCodePoint)).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: (Color(folder.iconCodePoint)).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.lightImpact();
            // Navigate to folder detail screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => FolderListScreen(isarService: widget.isarService, folderName: folder.name, folderIcon: Icon(
                  IconData(
                    folder.iconCodePoint,
                    fontFamily: folder.iconFontFamily,
                  ),
                  color: Color(folder.colorValue),
                  size: 24,
                ), id: folder.id),
              ),
            ).then((value) async {
              await _loadFolders();
            },);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (Color(folder.iconCodePoint))
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (Color(folder.iconCodePoint))
                              .withOpacity(0.3),
                        ),
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
                    // if (folder['isDefault'])

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: (Color(folder.iconCodePoint))
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (Color(folder.iconCodePoint))
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.movie,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${folder.movieIds.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () => _showFolderOptions(folder),
                        //   icon: const Icon(
                        //     Icons.more_vert,
                        //     color: Color(0xFFB3B3B3),
                        //     size: 18,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Text(
                  folder.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // const SizedBox(height: 8),
                // Text(
                //   folder.,
                //   style: const TextStyle(
                //     color: Color(0xFFB3B3B3),
                //     fontSize: 12,
                //     height: 1.3,
                //   ),
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                // ),
                Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD600).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFD600).withOpacity(0.3),
                    ),
                  ),
                  child:  Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(folder.modifiedTime),
                    style: TextStyle(
                      color: Color(0xFFFFD600),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFolderListCard(FolderModel folder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (Color(folder.iconCodePoint)).withOpacity(0.2),
          width: 1,
        ),
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
            HapticFeedback.lightImpact();
            // Navigate to folder detail screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => FolderListScreen(isarService: widget.isarService, folderName: folder.name, folderIcon: Icon(
                      IconData(
                        folder.iconCodePoint,
                        fontFamily: folder.iconFontFamily,
                      ),
                      color: Color(folder.colorValue),
                      size: 24,
                    ), id: folder.id),
              ),
            ).then((value) async {
              await _loadFolders();
            },);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (Color(folder.iconCodePoint)).withOpacity(
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (Color(folder.iconCodePoint)).withOpacity(
                        0.3,
                      ),
                    ),
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              folder.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(folder.modifiedTime),
                        style: TextStyle(
                          color: Color(0xFFFFD600),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: (Color(folder.iconCodePoint))
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: (Color(folder.iconCodePoint))
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${folder.movieIds.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      Icons.chevron_right,
                      color: const Color(0xFFB3B3B3),
                      size: 20,
                    ),
                  ],
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
          // _showCreateFolderDialog();
        },
        backgroundColor: const Color(0xFFE50914),
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.create_new_folder, size: 24),
        label: const Text(
          'New Folder',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
