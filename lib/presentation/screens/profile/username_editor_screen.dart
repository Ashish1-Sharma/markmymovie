import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markmymovie/core/theme/app_theme.dart';
import 'package:markmymovie/data/models/user_model.dart';
import 'package:markmymovie/data/repositories/auth_repository.dart';
import 'package:markmymovie/data/services/profile_api_service.dart';

/// Dedicated editor for the public handle, with debounced live
/// availability checking. Pops `true` when the username changed.
class UsernameEditorScreen extends StatefulWidget {
  final UserModel user;

  const UsernameEditorScreen({super.key, required this.user});

  @override
  State<UsernameEditorScreen> createState() => _UsernameEditorScreenState();
}

class _UsernameEditorScreenState extends State<UsernameEditorScreen> {
  /// Mirrors the server-side rule in `Users::validateUsername`.
  static final _format = RegExp(r'^[a-z0-9_]{3,30}$');

  late final TextEditingController _controller;
  Timer? _debounce;

  UsernameCheck? _check;
  bool _isChecking = false;
  bool _isSaving = false;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.user.username);
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  String get _value => _controller.text.trim().toLowerCase();
  bool get _isUnchanged => _value == widget.user.username.toLowerCase();

  void _onChanged() {
    _debounce?.cancel();

    final value = _value;

    setState(() {
      _check = null;
      _isChecking = false;
      // Validate locally first so obvious mistakes give instant feedback
      // without a network round-trip.
      _localError = value.isEmpty || _format.hasMatch(value)
          ? null
          : 'Use 3-30 characters: lowercase letters, numbers and underscores';
    });

    if (value.isEmpty || _localError != null || _isUnchanged) return;

    setState(() => _isChecking = true);
    _debounce = Timer(const Duration(milliseconds: 450), () => _check_(value));
  }

  Future<void> _check_(String value) async {
    try {
      final result = await ProfileApiService.instance
          .checkUsername(value, userId: widget.user.id);
      // A slower earlier request must not overwrite a newer keystroke.
      if (!mounted || value != _value) return;
      setState(() {
        _check = result;
        _isChecking = false;
      });
    } catch (_) {
      if (!mounted || value != _value) return;
      setState(() => _isChecking = false);
    }
  }

  bool get _canSave =>
      !_isSaving &&
      !_isChecking &&
      !_isUnchanged &&
      _localError == null &&
      _value.isNotEmpty &&
      (_check?.usable ?? false);

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final saved = await ProfileApiService.instance.updateUsername(
        userId: widget.user.id,
        username: _value,
      );

      await AuthRepository.instance
          .cacheUser(widget.user.copyWith(username: saved));

      if (!mounted) return;
      HapticFeedback.mediumImpact();
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.brandRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
        title: const Text('Username', style: AppTextStyles.headline),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Your username is your public link. Changing it breaks any link you have already shared.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLength: 30,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (_canSave) _save();
            },
            // Block invalid characters at the source rather than
            // rejecting them after the fact.
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
              TextInputFormatter.withFunction(
                (oldValue, newValue) => newValue.copyWith(
                  text: newValue.text.toLowerCase(),
                ),
              ),
            ],
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontSize: 17,
            ),
            decoration: InputDecoration(
              prefixText: '@',
              prefixStyle: AppTextStyles.body.copyWith(
                color: AppColors.textTertiary,
                fontSize: 17,
              ),
              suffixIcon: _buildStatusIcon(),
              counterStyle: AppTextStyles.footnote.copyWith(fontSize: 11),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
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
          _buildStatusLine(),
          const SizedBox(height: AppSpacing.xl),
          _buildPreview(),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _canSave ? _save : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandRed,
                disabledBackgroundColor: AppColors.surfaceRaised,
                disabledForegroundColor: AppColors.textTertiary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Save Username',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildStatusIcon() {
    if (_value.isEmpty || _isUnchanged) return null;
    if (_isChecking) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.textTertiary),
          ),
        ),
      );
    }
    if (_localError != null || (_check != null && !_check!.usable)) {
      return const Icon(Icons.error_outline_rounded, color: AppColors.brandRed, size: 20);
    }
    if (_check?.usable ?? false) {
      return const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20);
    }
    return null;
  }

  Widget _buildStatusLine() {
    String? message;
    Color color = AppColors.textTertiary;

    if (_isUnchanged && _value.isNotEmpty) {
      message = 'This is your current username.';
    } else if (_localError != null) {
      message = _localError;
      color = AppColors.brandRed;
    } else if (_isChecking) {
      message = 'Checking availability...';
    } else if (_check != null) {
      message = _check!.usable ? '@${_check!.username} is available' : _check!.reason;
      color = _check!.usable ? AppColors.success : AppColors.brandRed;
    }

    if (message == null) return const SizedBox(height: AppSpacing.sm);

    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 4),
      child: Text(message, style: AppTextStyles.footnote.copyWith(color: color)),
    );
  }

  Widget _buildPreview() {
    final handle = _value.isEmpty ? 'username' : _value;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.link_rounded, color: AppColors.textTertiary, size: 18),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'watchstash.app/@$handle',
              style: AppTextStyles.callout.copyWith(
                color: _value.isEmpty ? AppColors.textTertiary : AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
