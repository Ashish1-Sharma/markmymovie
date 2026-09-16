import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markmymovie/core/theme/app_theme.dart';
import 'package:markmymovie/data/models/user_model.dart';
import 'package:markmymovie/data/repositories/auth_repository.dart';
import 'package:markmymovie/data/services/profile_api_service.dart';
import 'package:markmymovie/presentation/screens/profile/edit_profile_screen.dart';
import 'package:markmymovie/presentation/screens/profile/username_editor_screen.dart';

/// The signed-in user's own profile: identity, public link, stats and
/// social links, with entry points to the editors.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);

    // Render the cached profile immediately, then refresh from the
    // server so stats (views/likes) are current.
    final cached = await AuthRepository.instance.getStoredUser();
    if (!mounted) return;

    if (cached == null) {
      setState(() {
        _isLoading = false;
        _error = 'You are not signed in.';
      });
      return;
    }

    setState(() {
      _user = cached;
      _isLoading = false;
    });

    try {
      final fresh = await ProfileApiService.instance.getProfile(cached.id);
      await AuthRepository.instance.cacheUser(fresh);
      if (mounted) setState(() => _user = fresh);
    } catch (e) {
      // Offline or server hiccup — the cached profile is still on screen,
      // so surface the problem quietly rather than blanking the page.
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _openEditor(Widget screen) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => screen),
    );
    if (changed == true) await _load();
  }

  void _copyLink() {
    final user = _user;
    if (user == null) return;
    Clipboard.setData(ClipboardData(text: 'https://${user.publicProfileUrl}'));
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile link copied'),
        backgroundColor: AppColors.surfaceRaised,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile', style: AppTextStyles.headline),
        centerTitle: true,
        actions: [
          if (_user != null)
            IconButton(
              tooltip: 'Edit profile',
              onPressed: () => _openEditor(EditProfileScreen(user: _user!)),
              icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary, size: 21),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandRed),
                strokeWidth: 2.5,
              ),
            )
          : _user == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      _error ?? 'Profile unavailable.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  color: AppColors.brandRed,
                  backgroundColor: AppColors.surface,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 40),
                    children: [
                      _buildIdentity(_user!),
                      const SizedBox(height: AppSpacing.xl),
                      _buildLinkRow(_user!),
                      const SizedBox(height: AppSpacing.xl),
                      _buildStats(_user!.stats),
                      if (_user!.bio.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        _buildBio(_user!.bio),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      _buildSocialLinks(_user!),
                      const SizedBox(height: AppSpacing.xl),
                      _buildVisibilityNote(_user!),
                    ],
                  ),
                ),
    );
  }

  // ---------------------------------------------------------------------

  Widget _buildIdentity(UserModel user) {
    return Row(
      children: [
        _Avatar(url: user.profilePicture, name: user.name, size: 84),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name.isEmpty ? 'Unnamed' : user.name,
                style: AppTextStyles.largeTitle.copyWith(fontSize: 24),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: AppTextStyles.footnote,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// The public handle, with an inline edit affordance — this is the
  /// thing users actually share, so it gets its own row.
  Widget _buildLinkRow(UserModel user) {
    final hasUsername = user.username.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.link_rounded, color: AppColors.textTertiary, size: 19),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              hasUsername ? user.publicProfileUrl : 'No username set',
              style: AppTextStyles.callout.copyWith(
                color: hasUsername ? AppColors.textPrimary : AppColors.textTertiary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasUsername)
            IconButton(
              tooltip: 'Copy link',
              onPressed: _copyLink,
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(6),
              icon: const Icon(Icons.copy_rounded, color: AppColors.textTertiary, size: 18),
            ),
          IconButton(
            tooltip: 'Change username',
            onPressed: () => _openEditor(UsernameEditorScreen(user: user)),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
            icon: const Icon(Icons.edit_rounded, color: AppColors.brandRed, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(ProfileStats stats) {
    final items = <(IconData, String, String)>[
      (Icons.favorite_rounded, '${stats.totalLikes}', 'Likes'),
      (Icons.visibility_rounded, '${stats.profileViews}', 'Views'),
      (Icons.folder_rounded, '${stats.publicFolders}', 'Folders'),
      (Icons.movie_rounded, '${stats.publicMovies}', 'Movies'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: items.map((item) {
          return Expanded(
            child: Column(
              children: [
                Icon(item.$1, color: AppColors.brandRed, size: 19),
                const SizedBox(height: 6),
                Text(
                  item.$2,
                  style: AppTextStyles.title.copyWith(fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.$3,
                  style: AppTextStyles.footnote.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBio(String bio) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About', style: AppTextStyles.headline),
          const SizedBox(height: AppSpacing.sm),
          Text(bio, style: AppTextStyles.body),
        ],
      ),
    );
  }

  Widget _buildSocialLinks(UserModel user) {
    final links = user.socialLinks;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: Text('Links', style: AppTextStyles.headline)),
              TextButton(
                onPressed: () => _openEditor(EditProfileScreen(user: user)),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  links.isEmpty ? 'Add' : 'Edit',
                  style: const TextStyle(
                    color: AppColors.brandRed,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (links.isEmpty)
            Text('No links added yet.', style: AppTextStyles.footnote)
          else
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: links.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(socialIcon(entry.key), size: 15, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          socialLabel(entry.key),
                          style: AppTextStyles.footnote.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildVisibilityNote(UserModel user) {
    final isPublic = user.isProfilePublic;
    return Row(
      children: [
        Icon(
          isPublic ? Icons.public_rounded : Icons.lock_rounded,
          size: 16,
          color: isPublic ? AppColors.success : AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            isPublic
                ? 'Your profile is public. Only folders you mark public are shown.'
                : 'Your profile is private and will not open on the web.',
            style: AppTextStyles.footnote,
          ),
        ),
      ],
    );
  }
}

/// Shared platform metadata so the profile and editor stay in sync.
IconData socialIcon(String platform) {
  switch (platform) {
    case 'instagram':
      return Icons.camera_alt_outlined;
    case 'x':
      return Icons.alternate_email_rounded;
    case 'youtube':
      return Icons.play_circle_outline_rounded;
    case 'letterboxd':
      return Icons.local_movies_outlined;
    case 'imdb':
      return Icons.star_outline_rounded;
    case 'tiktok':
      return Icons.music_note_outlined;
    default:
      return Icons.language_rounded;
  }
}

String socialLabel(String platform) {
  switch (platform) {
    case 'instagram':
      return 'Instagram';
    case 'x':
      return 'X';
    case 'youtube':
      return 'YouTube';
    case 'letterboxd':
      return 'Letterboxd';
    case 'imdb':
      return 'IMDb';
    case 'tiktok':
      return 'TikTok';
    case 'website':
      return 'Website';
    default:
      return platform;
  }
}

/// Circular avatar that falls back to the user's initial — the photo is
/// optional and may be an empty string.
class _Avatar extends StatelessWidget {
  final String url;
  final String name;
  final double size;

  const _Avatar({required this.url, required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.brandRed.withOpacity(0.5), width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: url.isEmpty
          ? Center(
              child: Text(
                initial,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Center(
                child: Text(
                  initial,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
    );
  }
}
