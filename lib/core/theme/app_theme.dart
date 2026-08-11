import 'dart:ui';
import 'package:flutter/material.dart';

/// MarkMyMovie — "Watchstash" design system.
///
/// A single source of truth for color, type, spacing and motion so every
/// screen reads as one product instead of a patchwork of one-off styles.
/// See `THEME.md` at the repo root for the full rationale and usage guide.
class AppColors {
  AppColors._();

  // Surfaces — near-black, layered by elevation rather than shadow.
  static const bg = Color(0xFF0A0808);
  static const surface = Color(0xFF161414);
  static const surfaceRaised = Color(0xFF1E1B1B);
  static const border = Color(0x1AF5F5F5); // off-white @ 10%
  static const borderStrong = Color(0x33F5F5F5); // off-white @ 20%

  // Brand.
  static const brandRed = Color(0xFFDE2028);
  static const brandRedDim = Color(0xFF9C161B);

  // Text.
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFFD8D6D8);
  static const textTertiary = Color(0xFF969496);

  // Semantic accents.
  static const gold = Color(0xFFFFD600); // ratings
  static const success = Color(0xFF34C759); // watched / positive state
  static const danger = brandRed;

  static const overlayScrim = Color(0xCC000000); // 80% black, glass panels

  static const heroGradient = [
    Colors.transparent,
    Color(0x59000000), // black @ 35%
    bg,
  ];
}

class AppRadius {
  AppRadius._();
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const pill = 999.0;
}

class AppSpacing {
  AppSpacing._();
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
}

/// Motion curves tuned to feel like iOS spring animations rather than
/// Material's linear/ease defaults.
class AppMotion {
  AppMotion._();
  static const Curve springOut = Cubic(0.16, 1.0, 0.3, 1.0);
  static const Curve standard = Curves.easeOutCubic;
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
}

/// Type scale modeled on iOS's SF Pro sizing/tracking: tight negative
/// letter-spacing on large headings, generous line-height on body copy.
class AppTextStyles {
  AppTextStyles._();

  static const largeTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.6,
    height: 1.15,
  );

  static const title = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.4,
  );

  static const headline = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const body = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 15,
    height: 1.55,
    letterSpacing: -0.1,
  );

  static const callout = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
  );

  static const subhead = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static const footnote = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const caption = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  );
}

/// Reusable frosted-glass ("iOS material") backdrop used behind nav bars,
/// pills and sheets floating over content.
class GlassMaterial extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color tint;
  final BorderRadius borderRadius;
  final Border? border;

  const GlassMaterial({
    super.key,
    required this.child,
    this.blur = 20,
    this.tint = const Color(0x99161414), // surface @ 60%
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.md)),
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: tint,
            borderRadius: borderRadius,
            border: border ?? Border.all(color: AppColors.border),
          ),
          child: child,
        ),
      ),
    );
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: base.colorScheme.copyWith(
        surface: AppColors.bg,
        primary: AppColors.brandRed,
        secondary: AppColors.brandRed,
        error: AppColors.danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headline,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandRed,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      ),
      dividerColor: AppColors.border,
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
