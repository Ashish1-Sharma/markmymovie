# Watchstash — Public Profile API (v1)

Everything the public website needs to render a user's profile and their
public folders **without any authentication**.

- **Base URL:** `https://tworingz.com/markmymovie`
- **Content type:** `application/json` on every request and response
- **CORS:** `Access-Control-Allow-Origin: *` — callable directly from the browser
- **Auth:** none on `/api/public/*`. The `/api/user/*` endpoints are used by
  the mobile app only and take a `userId` in the body.

Every response uses the same envelope:

```json
{ "statusCode": 200, "message": "…", "body": { } }
```

> `statusCode` inside the JSON is the real result — the HTTP status is
> always 200 unless the server itself failed. **Check the inner
> `statusCode`, not the HTTP one.**

| Code | Meaning |
|---|---|
| 200 | Success |
| 400 | Missing/invalid parameter |
| 404 | Profile or folder not found (or not public) |
| 405 | Wrong HTTP method |
| 409 | Username already taken |
| 500 | Server error |

---

## URL scheme (suggested)

| Page | URL | Endpoint it calls |
|---|---|---|
| Profile | `/@:username` | `POST /api/public/getProfile.php` |
| Folder | `/@:username/f/:folderId` | `POST /api/public/getFolder.php` |

`username` **is** the profile slug — lowercase `a–z`, `0–9`, `_`, 3–30 chars.
There is no separate slug column.

---

# PUBLIC ENDPOINTS (no auth — for the website)

## 1. Get a public profile

Returns the profile, its **public** folders, and aggregate stats.

```
POST /api/public/getProfile.php
```

**Payload**

```json
{ "username": "ashish", "countView": true }
```

| Field | Type | Required | Notes |
|---|---|---|---|
| `username` | string | yes | Case-insensitive |
| `countView` | bool | no | Default `true`. Pass `false` for prefetch/preview so you don't inflate the counter. |

**Response 200**

```json
{
  "statusCode": 200,
  "message": "Profile fetched successfully",
  "body": {
    "profile": {
      "id": 1,
      "username": "ashish",
      "name": "Ashish",
      "bio": "Watching movies is cheaper than therapy.",
      "social_links": {
        "instagram": "https://instagram.com/ashish",
        "letterboxd": "https://letterboxd.com/ashish"
      },
      "profile_picture": "https://…",
      "banner_image": "https://…",
      "profile_views": 8421,
      "total_likes": 1254,
      "created_at": "2026-05-10 10:15:32",
      "stats": {
        "public_folders": 18,
        "public_movies": 782,
        "total_likes": 1254,
        "profile_views": 8421,
        "top_genre": "Sci-Fi"
      }
    },
    "folders": [
      {
        "id": 12,
        "name": "Anime",
        "description": "",
        "slug": null,
        "visibility": "public",
        "color_value": 4294924066,
        "icon_codepoint": 58258,
        "icon_font_family": "MaterialIcons",
        "total_movies": 45,
        "likes_count": 245,
        "latest_movie_poster": "https://…",
        "latest_movie_title": "One Piece",
        "latest_movie_imdb": "tt11737520"
      }
    ]
  }
}
```

**Notes**
- `profile_picture` may be an **empty string** — fall back to the first letter of `name`.
- `social_links` is `{}` when none are set. Keys are limited to:
  `instagram`, `x`, `youtube`, `letterboxd`, `imdb`, `tiktok`, `website`.
- Only folders with `visibility = 'public'` are returned. `private` and
  `unlisted` never appear here.
- `404` if the username doesn't exist **or** the user set their profile to private.
- `color_value` is a 32-bit ARGB int (Flutter `Color`). To CSS: `#` + `(value & 0xFFFFFF).toString(16)`.

---

## 2. Get one public folder and its movies

```
POST /api/public/getFolder.php
```

**Payload**

```json
{ "username": "ashish", "folderId": 12 }
```

**Response 200**

```json
{
  "statusCode": 200,
  "message": "Folder fetched successfully",
  "body": {
    "folder": {
      "id": 12,
      "name": "Anime",
      "description": "",
      "visibility": "public",
      "likes_count": 245,
      "color_value": 4294924066,
      "icon_codepoint": 58258,
      "icon_font_family": "MaterialIcons",
      "created_at": "2026-07-14 15:12:34",
      "updated_at": "2026-07-14 15:12:34",
      "username": "ashish",
      "owner_name": "Ashish",
      "owner_picture": "https://…"
    },
    "movies": [
      {
        "id": 2,
        "imdb_id": "tt11737520",
        "tmdb_type": "series",
        "title": "One Piece",
        "original_title": "One Piece",
        "plot_overview": "With his straw hat and ragtag crew…",
        "type": "series",
        "year": 2023,
        "genre_names": ["Action", "Adventure", "Comedy"],
        "user_rating": 8.3,
        "poster": "https://…",
        "original_language": "English",
        "trailer": "",
        "trailer_thumbnail": "",
        "is_watch": false,
        "created_at": "2026-07-14 16:01:30"
      }
    ]
  }
}
```

**Notes**
- `genre_names` is a real JSON **array** (already decoded), not a string.
- `is_watch` is a real **boolean**.
- `404` if the folder isn't public, doesn't belong to that user, or the profile is private.
- Movies are ordered newest-first (`created_at DESC`). No pagination in v1 —
  add `LIMIT/OFFSET` to `getPublicFolderMovies()` if folders get large.

---

## 3. Like a folder

One like per anonymous visitor per folder. The visitor is identified by a
salted daily hash of IP + User-Agent — no cookie, no login.

```
POST /api/public/likeFolder.php
```

**Payload**

```json
{ "folderId": 12 }
```

**Response 200**

```json
{
  "statusCode": 200,
  "message": "Like registered",
  "body": { "folderId": 12, "likes_count": 246, "already_liked": false }
}
```

`already_liked: true` means the counter was **not** incremented — show the
button as already-liked rather than treating it as an error.

> There is no unlike endpoint in v1.

---

# APP ENDPOINTS (used by the Flutter app)

These take `userId` in the body. **There is no token check yet** — see
Security notes below before exposing them beyond the app.

## 4. Get own profile

```
POST /api/user/getProfile.php
{ "userId": 1 }
```

Returns the same shape as the public `profile` object, plus `email`,
`google_id`, `is_profile_public`, and `last_login_at`.

## 5. Update profile (partial)

```
POST /api/user/updateProfile.php
```

```json
{
  "userId": 1,
  "name": "Ashish",
  "bio": "Watching movies is cheaper than therapy.",
  "profilePicture": "https://…",
  "bannerImage": "https://…",
  "socialLinks": { "instagram": "https://instagram.com/ashish" },
  "isProfilePublic": true
}
```

Only the keys you send are written. Rules:

| Field | Rule |
|---|---|
| `name` | 1–150 chars, required if sent |
| `bio` | ≤ 300 chars, `""` clears it |
| `profilePicture` | valid URL or `""` to clear |
| `bannerImage` | valid URL or `""` to clear |
| `socialLinks` | whole object replaces the old one. Unknown platforms and non-`http(s)` URLs are silently dropped. |
| `isProfilePublic` | bool |

Returns the updated profile in `body`. `400` with a human-readable
`message` on validation failure.

## 6. Check username availability

```
POST /api/user/checkUsername.php
{ "username": "ashish", "userId": 1 }
```

`userId` is optional; it excludes the caller's own row so their current
username doesn't report as taken.

```json
{
  "statusCode": 200,
  "message": "Checked",
  "body": {
    "username": "ashish",
    "valid": true,
    "available": false,
    "reason": "That username is already taken"
  }
}
```

- `valid: false` → the string itself is malformed (bad chars, wrong length, reserved word).
- `valid: true, available: false` → well-formed but taken.

Reserved: `admin, api, www, app, about, login, logout, signup, settings,
profile, user, u, f, support, help, terms, privacy, watchstash, null,
undefined`.

## 7. Change username

```
POST /api/user/updateUsername.php
{ "userId": 1, "username": "ashish" }
```

Returns `409` with a message if invalid or taken. On success:

```json
{ "statusCode": 200, "message": "Username updated", "body": { "username": "ashish" } }
```

> Changing a username **breaks previously shared links** — there are no
> redirects from old handles in v1.

## 8. Change folder visibility

```
POST /api/folders/updateVisibility.php
{ "userId": 1, "folderId": 12, "visibility": "public" }
```

`visibility` ∈ `private` | `public` | `unlisted`. Scoped by `userId`, so a
user can never flip someone else's folder. `404` if the folder isn't theirs.

---

# Database changes

Run `server/migrations/001_public_profiles.sql` — statements are numbered
and meant to be run one at a time.

Summary:

| # | Change |
|---|---|
| 1 | `users.social_links` JSON |
| 2 | `users.updated_at` timestamp |
| 3 | `folders.likes_count` int |
| 4 | new table `folder_likes` (dedupe likes) |
| 5 | new table `profile_views_log` (dedupe views) |
| 6 | index `idx_folders_user_visibility` |
| 7 | **username cleanup** — existing rows contain non-URL-safe usernames (`витя12`, `ashishsharmab.tech(cs)2ndsem6`). Step 7a lists them, 7b rewrites them to `user<id>`. |
| 8 | optional — flip some folders to `public` so you have test data |

---

# Things to know before you build the site

1. **Every folder is `private` today.** Until users toggle folders public in
   the app (or you run migration step 8), every public profile renders with
   an empty folder list. Test with step 8.

2. **`google_login.php` still auto-generates usernames** with a weak rule,
   so new signups can still produce non-URL-safe handles. It should be updated to
   use the same `^[a-z0-9_]{3,30}$` rule as `Users::validateUsername()`.

3. **No rate limiting.** `likeFolder` and `getProfile` are open endpoints.
   The visitor hash stops casual double-counting but not a scripted attack.
   Add rate limiting at the web-server level before you promote the site.

4. **`/api/user/*` endpoints trust `userId` from the request body.** Anyone
   who knows a user id can edit that profile. This is fine while only the
   app calls them, but **must** be fixed (verify the Google token or issue a
   session token) before the public site or anything else can reach them.

5. **DB credentials are committed** in `config/database.php`. Move them to
   environment variables / a file outside the web root.

6. **No pagination** on folder movies. Fine for hundreds; add
   `LIMIT`/`OFFSET` if libraries grow.

7. **Image URLs are user-supplied** (`profile_picture`, `banner_image`) and
   only syntax-checked. Set a `Content-Security-Policy` `img-src` on the site
   and never render them as anything but `<img>`.
