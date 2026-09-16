import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markmymovie/core/theme/app_theme.dart';
import 'package:markmymovie/data/models/user_model.dart';
import 'package:markmymovie/data/repositories/auth_repository.dart';
import 'package:markmymovie/data/services/profile_api_service.dart';
import 'package:markmymovie/presentation/screens/profile/profile_screen.dart'
    show socialIcon, socialLabel;

/// Edits name, bio, photo URL, social links and profile visibility.
/// Pops `true` when something was saved so the caller can refresh.
class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  /// Must mirror `Users::$socialPlatforms` on the backend — anything
  /// else is silently dropped server-side.
  static const _platforms = [
    'instagram',
    'x',
    'youtube',
    'letterboxd',
    'imdb',
    'tiktok',
    'website',
  ];

  static const _bioLimit = 300;

  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _photoController;
  late final Map<String, TextEditingController> _linkControllers;

  late bool _isProfilePublic;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _bioController = TextEditingController(text: widget.user.bio);
    _photoController = TextEditingController(text: widget.user.profilePicture);
    _isProfilePublic = widget.user.isProfilePublic;
    _linkControllers = {
      for (final platform in _platforms)
        platform: TextEditingController(text: widget.user.socialLinks[platform] ?? ''),
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _photoController.dispose();
    for (final controller in _linkControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _validate() {
    if (_nameController.text.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (_bioController.text.trim().length > _bioLimit) {
      return 'Bio must be $_bioLimit characters or fewer';
    }

    final photo = _photoController.text.trim();
    if (photo.isNotEmpty && !_isHttpUrl(photo)) {
      return 'Photo URL must start with http:// or https://';
    }

    for (final entry in _linkControllers.entries) {
      final url = entry.value.text.trim();
      if (url.isNotEmpty && !_isHttpUrl(url)) {
        return '${socialLabel(entry.key)} link must start with http:// or https://';
      }
    }
    return null;
  }

  bool _isHttpUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  Future<void> _save() async {
    final error = _validate();
    if (error != null) {
      _showMessage(error, isError: true);
      return;
    }

    setState(() => _isSaving = true);

    // Empty values are sent as empty strings, not omitted — that's how
    // the backend distinguishes "clear this field" from "leave it alone".
    final links = <String, String>{};
    for (final entry in _linkControllers.entries) {
      final url = entry.value.text.trim();
      if (url.isNotEmpty) links[entry.key] = url;
    }

    try {
      final updated = await ProfileApiService.instance.updateProfile(
        userId: widget.user.id,
        name: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        profilePicture: _photoController.text.trim(),
        socialLinks: links,
        isProfilePublic: _isProfilePublic,
      );

      await AuthRepository.instance.cacheUser(updated);

      if (!mounted) return;
      HapticFeedback.mediumImpact();
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showMessage(e.toString(), isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.brandRed : AppColors.surfaceRaised,
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
        centerTitle: true,
        title: const Text('Edit Profile', style: AppTextStyles.headline),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandRed),
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.brandRed,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 40),
        children: [
          _Field(
            label: 'Name',
            controller: _nameController,
            hint: 'Your display name',
            maxLength: 150,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppSpacing.lg),
          _Field(
            label: 'Bio',
            controller: _bioController,
            hint: 'A line about your taste in movies',
            maxLength: _bioLimit,
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.lg),
          _Field(
            label: 'Photo URL',
            controller: _photoController,
            hint: 'https://... (leave empty to use your initial)',
            keyboardType: TextInputType.url,
            helper:
                'Direct image link. Upload support is coming — paste a URL for now.',
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Text('Social Links', style: AppTextStyles.headline),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Shown on your public profile. Leave a field empty to remove it.',
            style: AppTextStyles.footnote,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final platform in _platforms) ...[
            _Field(
              label: socialLabel(platform),
              icon: socialIcon(platform),
              controller: _linkControllers[platform]!,
              hint: 'https://...',
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const SizedBox(height: AppSpacing.md),
          _buildVisibilityToggle(),
        ],
      ),
    );
  }

  Widget _buildVisibilityToggle() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Public profile', style: AppTextStyles.callout),
                const SizedBox(height: 2),
                Text(
                  _isProfilePublic
                      ? 'Anyone with your link can view your public folders.'
                      : 'Your profile link will return "not found".',
                  style: AppTextStyles.footnote,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Switch(
            value: _isProfilePublic,
            activeColor: AppColors.brandRed,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              setState(() => _isProfilePublic = value);
            },
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? helper;
  final IconData? icon;
  final int? maxLength;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const _Field({
    required this.label,
    required this.controller,
    this.hint,
    this.helper,
    this.icon,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 15, color: AppColors.textTertiary),
              const SizedBox(width: 6),
            ],
            Text(label, style: AppTextStyles.subhead),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
            helperText: helper,
            helperStyle: AppTextStyles.footnote.copyWith(fontSize: 11),
            helperMaxLines: 2,
            counterStyle: AppTextStyles.footnote.copyWith(fontSize: 11),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.brandRed),
            ),
          ),
        ),
      ],
    );
  }
}
