# Watchstash — Project Context

This file is a working reference for maintaining and extending this app.
Read this first before making changes — it captures product decisions,
current schema, and planned work so context isn't lost between sessions.

## What this app is

Watchstash (formerly "Mark My Movie", package `com.ashish.markmymovie`)
is a movie/TV watchlist app. Users search for movies/shows and save them
into custom folders (organized by mood, genre, or occasion). Originally
built as a personal watchlist tool; now being extended into a **creator
link-in-bio tool for movie/TV recommendations**.

- Mobile app: Flutter
- Backend: PHP + MySQL, hosted on Hostinger
- Current repo state: PHP backend files have just been merged into the
  same project as the Flutter app (single repo going forward)
- Play Store listing (old name): ~100+ downloads, Lifestyle category

## Rebrand in progress

- Old name: "Mark My Movie" / "MarkMyMovie" — red filmstrip icon
- New name: **Watchstash** — new logo is a rounded-square icon with a
  minimal white folder/stash glyph, not a filmstrip
- Tagline: "Your Movie Watchlist, Stashed"
- Brand colors: near-black background (#0a0808), brand red (~#DE2028
  range), off-white text (#F5F5F5), muted gray subtext (#969496)
- Wherever old branding appears in code (app name strings, package
  metadata, in-app logo assets, Play Store listing text), it needs to be
  swapped to Watchstash — treat any lingering "Mark My Movie" references
  as bugs to fix, not intentional.

## The core problem this app solves

Movie/TV recommendation creators on TikTok/YouTube/Instagram post reels
like "5 horror movies for October" — viewers currently have to pause,
screenshot, and Google each title one by one. Watchstash lets:
1. A regular user save movies into private folders for their own watchlist
   (the original, already-built functionality)
2. A creator mark a folder public, so it becomes a shareable list
   (`watchstash.com/@handle` or `watchstash.com/@handle/folder-slug`) that
   followers can open straight from a bio link — no app install required
   to view it, with a CTA to install for saving movies to their own list

## Current database schema (as of last export)

Three real tables + one deprecated one:

### `folder_movie_sync` — DEPRECATED, should be dropped
Legacy table with varchar folder/movie IDs and no real metadata. Superseded
by `movies` below. Had duplicate-insert bugs (same imdb_id inserted 5x)
that the new `movies` table's unique constraint fixes. **Do not build
anything against this table — drop it once confirmed unused.**

### `users`
```sql
id, google_id (unique), username (unique), name, bio, email (unique),
profile_picture, banner_image, profile_views (int, default 0),
total_likes (int, default 0), is_profile_public (tinyint, default 1),
login_provider (enum 'google'), is_active, created_at, last_login_at
```
Already has what's needed for public creator profiles: unique `username`
for the `@handle` URL, and `is_profile_public` toggle.

### `folders`
```sql
id, user_id (FK -> users.id), name, description, slug,
visibility (enum 'private','public','unlisted', default 'private'),
icon_codepoint, icon_font_family, color_value, created_at, updated_at
```
`visibility` and `slug` already exist — the public/private folder system
was already planned for. **Gap: `slug` is currently NULL on every existing
row** — needs to be auto-generated (slugified name + short hash for
uniqueness) whenever a folder is set to `public` or `unlisted`.

### `movies`
```sql
id, user_id (FK), folder_id (FK -> folders.id, cascade delete),
imdb_id, tmdb_type, title, original_title, plot_overview, type, year,
genre_names (json), user_rating, poster, original_language, trailer,
trailer_thumbnail, is_watch (tinyint), modified_time, created_at
UNIQUE (user_id, folder_id, imdb_id)
```
This is the real, current movie-storage table (richer metadata, proper
int FKs, dedupe constraint) — always use this, never `folder_movie_sync`.

## Known schema gaps for the creator feature (not yet built)

1. **`folders.slug`** — needs auto-generation logic on public/unlisted toggle
2. **No per-movie creator commentary field** — `movies` has no `note`/
   `commentary` column. For "why this movie is on my horror list" text,
   add something like `movies.creator_note TEXT NULL`
3. **No folder-level engagement tracking** — `users` has `profile_views`/
   `total_likes` but `folders` has nothing. Add `folders.views INT DEFAULT 0`
   and `folders.likes INT DEFAULT 0` (or a separate likes table if you want
   per-user like tracking, not just a counter)
4. **No `is_creator` flag** — not strictly required (any user with a public
   folder is effectively a creator), but worth adding to `users` if
   creator-only features (analytics, badges) get built later
5. **Public API endpoints don't exist yet** — need:
   - `GET /u/{username}` — public profile: user info + list of public folders
   - `GET /f/{slug}` — single public folder: folder info + its movies
   - Both read-only, no auth required, should respect `is_profile_public`
     and `folders.visibility`

## Product/feature decisions made so far (don't re-litigate these)

- Public/private is a **folder-level** toggle, not account-level — a
  creator can have both private personal folders and public curated ones
- Sharing works at two levels: whole profile (`@handle`) and individual
  folder (`@handle/slug`) — creators will link specific folders in specific
  video captions, not always their whole profile
- The public web page is meant to be viewable with **zero friction** —
  no login/install required to browse; app install is the secondary CTA
  for someone who wants to save movies to their own list
- MVP build order agreed: (1) public/private toggle + public folder view
  inside the app first, (2) standalone public web page for folders,
  (3) individual folder-level sharing + deep links once real usage data
  shows which folders/creators get traffic

## Play Store ASO copy (current, Watchstash-branded)

Short description:
> Movie & TV watchlist app — save picks from creators into organized folders

Full description covers: save movies instantly, unlimited folders, follow
creators' public lists, full movie/show details (ratings, genre, cast,
plot, trailers), favorites tracking, dark cinematic theme.

## Marketing context (for reference, not code-relevant)

Primary audience: micro/mid movie-recommendation creators (1K-500K
followers) on TikTok/Reels/YouTube Shorts in niches like horror, anime,
K-drama, "movies like X". Secondary: their followers. Go-to-market is
creator outreach + organic short-form content + ASO, not paid ads at this
stage. Cross-promotion available from the agency's other app, Catalog
Maker (~500K downloads).
