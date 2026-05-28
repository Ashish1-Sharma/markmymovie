import 'package:flutter/material.dart';
import 'package:markmymovie/data/local_db/isar_service.dart';
import 'package:markmymovie/presentation/screens/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  IsarService isarService = IsarService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MarkMyMovie',
      debugShowCheckedModeBanner: false,
      theme: _buildCinematicTheme(),
      home: SplashScreen(isarService: isarService),
    );
  }

  ThemeData _buildCinematicTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.red,
      primaryColor: const Color(0xFFE50914), // Netflix red
      scaffoldBackgroundColor: const Color(0xFF121212), // Theater dark
      cardColor: const Color(0xFF1F1F1F),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFFB3B3B3),
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: Color(0xFF666666),
          fontSize: 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE50914),
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: const Color(0xFFE50914).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final IsarService isarService;

  const SplashScreen({super.key, required this.isarService});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  late AnimationController _progressController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoRotationAnimation;

  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  late Animation<double> _backgroundAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _logoRotationAnimation = Tween<double>(
      begin: -0.5,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    // Background animation
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() async {
    // Start background animation immediately
    _backgroundController.forward();

    // Start logo animation after a small delay
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    // Start text animation after logo starts
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();

    // Start progress animation
    await Future.delayed(const Duration(milliseconds: 300));
    _progressController.forward();

    // Initialize Isar and navigate after animations complete
    await Future.delayed(const Duration(milliseconds: 600));
    await _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize your Isar database here
      // await widget.isarService.initialize();

      // Simulate initialization time
      await Future.delayed(const Duration(milliseconds: 1000));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                HomeScreen(isarService: widget.isarService),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      // Handle initialization errors
      print('App initialization failed: $e');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _textController,
          _backgroundController,
          _progressController,
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              // Animated background gradient
              _buildAnimatedBackground(),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated logo
                    _buildAnimatedLogo(),

                    const SizedBox(height: 40),

                    // Animated text
                    _buildAnimatedText(),

                    const SizedBox(height: 60),

                    // Loading progress
                    _buildLoadingProgress(),
                  ],
                ),
              ),

              // Floating particles effect
              _buildFloatingParticles(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5 * _backgroundAnimation.value,
              colors: [
                const Color(0xFFE50914).withOpacity(0.1 * _backgroundAnimation.value),
                const Color(0xFF1F1F1F).withOpacity(0.3 * _backgroundAnimation.value),
                const Color(0xFF121212),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return Transform.rotate(
      angle: _logoRotationAnimation.value,
      child: Transform.scale(
        scale: _logoScaleAnimation.value,
        child: FadeTransition(
          opacity: _logoOpacityAnimation,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFE50914),
                  const Color(0xFFE50914).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE50914).withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: const Color(0xFFE50914).withOpacity(0.2),
                  blurRadius: 50,
                  spreadRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_movies,
              color: Colors.white,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedText() {
    return SlideTransition(
      position: _textSlideAnimation,
      child: FadeTransition(
        opacity: _textFadeAnimation,
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Colors.white,
                  Color(0xFFE50914),
                  Colors.white,
                ],
                stops: [0.0, 0.5, 1.0],
              ).createShader(bounds),
              child: const Text(
                'MarkMyMovie',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your personal movie vault',
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFFB3B3B3).withOpacity(_textFadeAnimation.value),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingProgress() {
    return Column(
      children: [
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.circular(2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFFE50914),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedOpacity(
          opacity: _progressAnimation.value > 0.1 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            _getLoadingText(),
            style: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlesPainter(_backgroundAnimation.value),
          );
        },
      ),
    );
  }

  String _getLoadingText() {
    final progress = _progressAnimation.value;
    if (progress < 0.3) {
      return 'Initializing database...';
    } else if (progress < 0.6) {
      return 'Setting up movie vault...';
    } else if (progress < 0.9) {
      return 'Preparing cinema experience...';
    } else {
      return 'Almost ready!';
    }
  }
}

class ParticlesPainter extends CustomPainter {
  final double animationValue;

  ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE50914).withOpacity(0.1 * animationValue)
      ..style = PaintingStyle.fill;

    // Draw floating particles
    for (int i = 0; i < 20; i++) {
      final x = (i * 47) % size.width;
      final y = (i * 31 + animationValue * 100) % size.height;
      final radius = (2 + (i % 3)) * animationValue;

      canvas.drawCircle(
        Offset(x.toDouble(), y.toDouble()),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}