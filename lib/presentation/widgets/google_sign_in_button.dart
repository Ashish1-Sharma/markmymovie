import 'package:flutter/material.dart';

/// A branded "Continue with Google" button matching the app's cinematic theme.
///
/// Features:
/// - Google "G" logo painted via [CustomPaint] (no extra dependency)
/// - Press scale animation
/// - Circular loading indicator while [isLoading] is true
/// - Disabled state prevents multiple simultaneous taps
class GoogleSignInButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.isLoading || widget.onPressed == null) return;
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    _releasePress();
    if (!widget.isLoading && widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  void _handleTapCancel() => _releasePress();

  void _releasePress() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = widget.isLoading || widget.onPressed == null;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: disabled ? null : _handleTapDown,
        onTapUp: disabled ? null : _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: disabled ? 0.7 : 1.0,
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  // Touch feedback handled by GestureDetector above
                  onTap: null,
                  splashColor: Colors.white.withOpacity(0.05),
                  highlightColor: Colors.white.withOpacity(0.03),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.isLoading)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFE50914),
                              ),
                            ),
                          )
                        else
                          const _GoogleLogo(size: 24),
                        const SizedBox(width: 14),
                        Text(
                          widget.isLoading
                              ? 'Signing in...'
                              : 'Continue with Google',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Google "G" Logo painted with CustomPaint ───────────────────────────────

class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double r = w / 2;

    // Background circle (white)
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r, bgPaint);

    // Clip to circle
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r)));

    final double strokeW = w * 0.085;

    // Blue arc (right, top-right)
    _drawArc(canvas, cx, cy, r * 0.68, -10, 75, strokeW, const Color(0xFF4285F4));
    // Red arc (top-left)
    _drawArc(canvas, cx, cy, r * 0.68, 185, 100, strokeW, const Color(0xFFEA4335));
    // Yellow arc (bottom-left, bottom)
    _drawArc(canvas, cx, cy, r * 0.68, 245, 75, strokeW, const Color(0xFFFBBC05));
    // Green arc (bottom-right)
    _drawArc(canvas, cx, cy, r * 0.68, 290, 80, strokeW, const Color(0xFF34A853));

    // Horizontal bar for the "G" cut (white rectangle)
    final barPaint = Paint()..color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(cx - strokeW * 0.1, cy - strokeW * 0.7, r * 0.85, strokeW * 1.4),
      barPaint,
    );

    // Fill right portion of horizontal bar with blue
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(cx + strokeW * 0.4, cy - strokeW * 0.7, r * 0.48, strokeW * 1.4),
      bluePaint,
    );

    // White dot in center (inner hole)
    canvas.drawCircle(Offset(cx, cy), r * 0.39, bgPaint);
  }

  void _drawArc(Canvas canvas, double cx, double cy, double radius,
      double startDeg, double sweepDeg, double strokeWidth, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      _toRad(startDeg),
      _toRad(sweepDeg),
      false,
      paint,
    );
  }

  double _toRad(double deg) => deg * (3.14159265358979 / 180.0);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
