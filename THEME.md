# MarkMyMovie — "Watchstash" Design System

This document is the source of truth for MarkMyMovie's visual language. It
describes the direction implemented in [`lib/core/theme/app_theme.dart`](lib/core/theme/app_theme.dart)
and the reference implementation in the movie detail screen. New screens
should build on these tokens instead of inventing new colors/spacing inline.

## Design principles

1. **Cinema, not chrome.** Near-black surfaces let poster art and stills be
   the brightest thing on screen. UI chrome recedes.
2. **iOS-native feel.** Frosted glass ("material") nav bars, spring easing,
   segmented tab controls, haptic feedback on every interactive tap, and
   tight negative letter-spacing on headings — the app should feel at home
   next to Apple TV / Apple Music, not like a ported Android app.
3. **Flat over shadow.** Depth is communicated with hairline borders and
   subtle color-layering (`surface` → `surfaceRaised`), not drop shadows.
   Shadows are reserved for floating elements (glass bars, sheets, posters).
4. **One accent.** Brand red is used sparingly — for the primary action,
   selection state, and rating badges — so it stays meaningful.

## Color

| Token | Hex | Usage |
|---|---|---|
| `AppColors.bg` | `#0A0808` | App/scaffold background |
| `AppColors.surface` | `#161414` | Cards, chips, sheets |
| `AppColors.surfaceRaised` | `#1E1B1B` | Elevated surface on top of `surface` |
| `AppColors.border` | `#F5F5F5` @ 10% | Hairline dividers/borders |
| `AppColors.borderStrong` | `#F5F5F5` @ 20% | Emphasized borders (selected state) |
| `AppColors.brandRed` | `#DE2028` | Primary actions, selection, links |
| `AppColors.brandRedDim` | `#9C161B` | Pressed/secondary red |
| `AppColors.textPrimary` | `#F5F5F5` | Headings, primary copy |
| `AppColors.textSecondary` | `#D8D6D8` | Body copy |
| `AppColors.textTertiary` | `#969496` | Captions, meta, placeholders |
| `AppColors.gold` | `#FFD600` | Star ratings only |
| `AppColors.success` | `#34C759` | "Watched" / positive confirmation |

Do not introduce new raw `Color(0x...)` literals in screen files — add a
token to `AppColors` instead so a future palette change is a one-file edit.

> Note: `home_screen.dart`, `login_screen.dart`, and `settings_screen.dart`
> currently still use an older Netflix-red palette (`#E50914` / `#121212`).
> These are legacy and should be migrated to `AppColors` as they're touched;
> `search_screen.dart` and `movie_detail_screen.dart` are the current
> reference implementations.

## Typography

`AppTextStyles` models an SF Pro-like scale: large headings carry tight
negative letter-spacing, body copy uses relaxed line-height (1.55) for
readability on dark backgrounds.

| Style | Size / Weight | Use |
|---|---|---|
| `largeTitle` | 28 / bold, -0.6 tracking | Screen/movie title |
| `title` | 20 / bold, -0.4 tracking | Sheet headers |
| `headline` | 17 / w700, -0.2 tracking | Section headers, app bar title |
| `body` | 15 / regular, 1.55 line-height | Paragraph copy (overview/plot) |
| `callout` | 15 / w600 | Button labels |
| `subhead` | 13 / w500, tertiary color | Row labels, metadata |
| `footnote` | 12 / w500, tertiary color | Cast credit, small captions |
| `caption` | 11 / w600, +0.4 tracking | Pills/badges (e.g. "MOVIE", "TV") |

## Spacing & radius

Use the 4pt-based scale in `AppSpacing` (`xs`=4 … `xxxl`=32) for all
padding/gaps, and `AppRadius` (`sm`=8, `md`=12, `lg`=16, `xl`=20, `pill`=999)
for corner rounding. Buttons and cards default to `md`/`lg`; pills and
segmented controls use `pill`.

## Motion

- `AppMotion.springOut` — a cubic bezier approximating iOS's spring curve;
  use for entrance transitions and tab-switch content.
- `AppMotion.standard` (`easeOutCubic`) — default for simple fades.
- Durations: `fast` 200ms (micro-interactions), `medium` 350ms (tab/section
  transitions), `slow` 500ms (screen entrance).
- Pair every tap that changes state (favorite, watched, tab switch, sheet
  open) with `HapticFeedback.lightImpact()`/`mediumImpact()` — this is what
  makes the app *feel* native on iOS.

## Glass material

`GlassMaterial` (in `app_theme.dart`) wraps `BackdropFilter` + a translucent
`surface` tint to reproduce iOS's frosted "material" effect. Use it for:

- Floating nav-bar buttons over hero imagery (back, favorite, watched)
- Segmented tab bars
- Bottom sheets and overlays that sit above scrollable content

Avoid plain `Colors.black.withOpacity(...)` containers for these — route
through `GlassMaterial` so blur/tint stay consistent app-wide.

## Component patterns

- **Hero image**: full-bleed poster/backdrop with a bottom gradient
  (`AppColors.heroGradient`) fading into `bg`, so the title block reads
  clearly without a hard cut.
- **Segmented tabs** (Overview / Cast / Where to Watch): a single pill-shaped
  container with a sliding `AnimatedContainer` indicator behind the selected
  label — not Material's underlined `TabBar`.
- **Rating badge**: dark glass pill, gold star + bold number, floated over
  the hero image.
- **Action row**: two pill buttons max at the top (primary filled red +
  secondary outlined) — additional state toggles (favorite, watched) live in
  the nav bar as icon buttons, not as a third pill, to avoid button clutter.

## Applying the theme

```dart
MaterialApp(
  theme: AppTheme.dark,
  ...
)
```

Screen-level code should reference `AppColors` / `AppTextStyles` /
`AppSpacing` / `AppRadius` directly rather than pulling values off
`Theme.of(context)` for anything Watchstash-specific — the app is
intentionally single-themed (dark only) for now.
