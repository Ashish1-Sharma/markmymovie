import 'package:flutter/material.dart';
import 'package:markmymovie/core/theme/app_theme.dart';

/// Standalone, GIF-driven splash screen for Watchstash.
///
/// This is intentionally **separate** from the existing `SplashScreen` in
/// `main.dart` — it does not replace it, and nothing currently routes to
/// it. Wire it up yourself (e.g. swap `home:` in `main.dart`, or push it
/// as the very first route) when you're ready to switch splash screens.
///
/// Visual spec:
/// - Pure black (#000000) background.
/// - `assets/splash1.gif` (the popcorn mascot) centered with generous
///   negative space, played as-is — no redrawing, no extra artwork.
/// - "Watchstash" wordmark below the mascot in white with a subtle red
///   accent.
/// - A minimal "Warming up servers..." caption + animated red→white→gray
///   progress bar with a live percentage, pinned near the bottom.
class WatchstashGifSplashScreen extends StatefulWidget {
  /// Called once the loading sequence completes (i.e. the progress bar
  /// reaches 100%). Wire this to your navigation (e.g.
  /// `Navigator.pushReplacement`) if you use this screen directly as
  /// `home:`. Left null, the screen just sits at 100% — useful when you're
  /// driving navigation from elsewhere.
  final VoidCallback? onFinished;

  /// Total time the fake-progress loading sequence takes to reach 100%.
  /// Defaults to the 1–2s cinematic window this screen was designed for.
  final Duration minimumDisplay;

  const WatchstashGifSplashScreen({
    super.key,
    this.onFinished,
    this.minimumDisplay = const Duration(milliseconds: 1800),
  });

  @override
  State<WatchstashGifSplashScreen> createState() => _WatchstashGifSplashScreenState();
}

class _WatchstashGifSplashScreenState extends State<WatchstashGifSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: widget.minimumDisplay,
      vsync: this,
    );

    // Starts visibly at 0% and eases in smoothly — no initial burst that
    // skips past the low numbers — then eases out into a fast finish.
    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOutCubic),
    );

    if (widget.onFinished != null) {
      _progressController.addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onFinished!();
      });
    }

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  /// Cinema-flavored loading captions, keyed to the same three phases as
  /// the progress curve — a nod to the popcorn mascot rather than generic
  /// "server" copy.
  String _loadingCaption(double t) {
    if (t < 0.35) return 'DIMMING THE LIGHTS...';
    if (t < 0.62) return 'GRABBING THE POPCORN...';
    if (t < 0.88) return 'ROLLING THE REEL...';
    return 'ALMOST SHOWTIME...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 36),

            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  height: 1.0,
                ),
                children: [
                  TextSpan(text: 'Watch', style: TextStyle(color: Colors.white)),
                  TextSpan(text: 'stash', style: TextStyle(color: AppColors.brandRed)),
                ],
              ),
            ),
            const Spacer(flex: 4),

            // Mascot — the GIF is the whole visual, untouched.
            Image.asset(
              'assets/mascott.png',
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),

            const SizedBox(height: 36),

            // Wordmark.


            const Spacer(flex: 5),

            // Loading section — animated gradient progress bar + live %.
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  final t = _progress.value.clamp(0.0, 1.0);
                  final percent = (t * 100).round();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full-width gradient sweep: red (start) → bright
                      // white (current progress) → dim gray (not yet
                      // reached). The white point tracks `t` so the bar
                      // itself reads as a moving "loading" edge.
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: const [
                                AppColors.brandRed,
                                Colors.white,
                                Color(0xFF3A3A3A),
                              ],
                              stops: [0.0, t, 1.0],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _loadingCaption(t),
                            style: AppTextStyles.footnote.copyWith(
                              letterSpacing: 2.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$percent%',
                            style: AppTextStyles.footnote.copyWith(
                              color: AppColors.brandRed,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
