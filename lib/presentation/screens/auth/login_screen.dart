import 'package:flutter/material.dart';
import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/logic/auth_notifier.dart';
import 'package:markmymovie/presentation/screens/home/home_screen.dart';
import 'package:markmymovie/presentation/widgets/google_sign_in_button.dart';

/// Authentication / Login screen.
///
/// Shown when no session is found on app start. Uses the exact same
/// cinematic dark theme (radial gradient background, animated logo,
/// slide-in text) as [SplashScreen] to feel like a native extension.
class LoginScreen extends StatefulWidget {
  final IsarService isarService;

  const LoginScreen({super.key, required this.isarService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // ── Animation controllers ────────────────────────────────────────────────
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _bgController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bgAnimation;
  late Animation<double> _pulseAnimation;

  // ── State ────────────────────────────────────────────────────────────────
  final _authNotifier = AuthNotifier();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startEntryAnimation();
  }

  void _initAnimations() {
    _bgController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _bgAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Subtle logo pulse
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startEntryAnimation() async {
    _bgController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _bgController.dispose();
    _pulseController.dispose();
    _authNotifier.dispose();
    super.dispose();
  }

  // ── Sign-in handler ───────────────────────────────────────────────────────

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final success = await _authNotifier.login();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success && _authNotifier.user != null) {
      widget.isarService.syncFoldersFromServer();
      final userName = _authNotifier.user!.name;
      _showSuccessSnackbar('Welcome back, $userName! 🎬');

      // Brief pause so the snackbar is visible, then navigate
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      _navigateToHome();
    } else {
      final errorMsg = _authNotifier.errorMessage ??
          'Sign in failed. Please try again.';
      _authNotifier.clearError();
      _showErrorSnackbar(errorMsg);
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, _) =>
            HomeScreen(isarService: widget.isarService),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // ── Snackbar helpers ───────────────────────────────────────────────────────

  void _showSuccessSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1DB954), // success green
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE50914),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _bgController,
          _fadeController,
          _slideController,
        ]),
        builder: (context, _) {
          return Stack(
            children: [
              _buildBackground(),
              _buildFloatingParticles(),
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Top spacer with skip button placeholder
                        const Spacer(flex: 2),

                        // ── Logo ───────────────────────────────────────
                        _buildLogo(),
                        const SizedBox(height: 40),

                        // ── Title & subtitle ───────────────────────────
                        SlideTransition(
                          position: _slideAnimation,
                          child: _buildHeroText(),
                        ),

                        const Spacer(flex: 3),

                        // ── Google Sign-In Button ──────────────────────
                        SlideTransition(
                          position: _slideAnimation,
                          child: _buildAuthCard(),
                        ),

                        const SizedBox(height: 24),

                        // ── Privacy note ───────────────────────────────
                        SlideTransition(
                          position: _slideAnimation,
                          child: _buildPrivacyNote(),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Sub-builders ──────────────────────────────────────────────────────────

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.4 * _bgAnimation.value,
          colors: [
            const Color(0xFFE50914)
                .withOpacity(0.12 * _bgAnimation.value),
            const Color(0xFF1F1F1F)
                .withOpacity(0.25 * _bgAnimation.value),
            const Color(0xFF121212),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _bgAnimation,
        builder: (_, __) => CustomPaint(
          painter: _ParticlesPainter(_bgAnimation.value),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (_, child) => Transform.scale(
        scale: _pulseAnimation.value,
        child: child,
      ),
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE50914), Color(0xFFB00711)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE50914).withOpacity(0.45),
              blurRadius: 32,
              spreadRadius: 0,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: const Color(0xFFE50914).withOpacity(0.2),
              blurRadius: 60,
              spreadRadius: 8,
            ),
          ],
        ),
        child: const Icon(
          Icons.local_movies,
          color: Colors.white,
          size: 60,
        ),
      ),
    );
  }

  Widget _buildHeroText() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFFE50914), Colors.white],
            stops: [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: const Text(
            'Welcome to MovieVault',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.8,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Sign in to sync your watchlists, favorites,\nratings, and preferences across devices.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withOpacity(0.65),
            height: 1.6,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get started',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          GoogleSignInButton(
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _handleGoogleSignIn,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyNote() {
    return Text(
      'By continuing, you agree to our Terms of Service\nand Privacy Policy.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white.withOpacity(0.35),
        fontSize: 12,
        height: 1.6,
      ),
    );
  }
}

// ── Particles painter (reused from SplashScreen style) ─────────────────────

class _ParticlesPainter extends CustomPainter {
  final double value;
  _ParticlesPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE50914).withOpacity(0.08 * value)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 18; i++) {
      final x = (i * 53.0) % size.width;
      final y = (i * 37.0 + value * 80) % size.height;
      final r = (1.5 + (i % 3)) * value;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
