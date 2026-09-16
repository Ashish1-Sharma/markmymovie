-- ============================================================
-- Watchstash — Public Profiles (v1)
-- Run these ONE AT A TIME, in order, against the `movie` database.
-- Every statement is safe to run on the existing production data.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Social links on the user profile.
--    Stored as a JSON object keyed by platform, e.g.
--    {"instagram":"https://instagram.com/x","x":"https://x.com/y"}
--    NULL means "no links set".
-- ------------------------------------------------------------
ALTER TABLE `users`
  ADD COLUMN `social_links` JSON DEFAULT NULL AFTER `bio`;


-- ------------------------------------------------------------
-- 2. Track when a profile was last edited (used for cache-busting
--    the public page and for "last updated" copy).
-- ------------------------------------------------------------
ALTER TABLE `users`
  ADD COLUMN `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
  ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`;


-- ------------------------------------------------------------
-- 3. Per-folder like counter (the "245 Likes" stat).
--    Denormalised counter — incremented by the public like endpoint.
-- ------------------------------------------------------------
ALTER TABLE `folders`
  ADD COLUMN `likes_count` INT NOT NULL DEFAULT 0 AFTER `visibility`;


-- ------------------------------------------------------------
-- 4. De-duplicates likes from the same anonymous visitor.
--    `visitor_hash` is a SHA-256 of (IP + User-Agent + daily salt),
--    so the public site needs no login to like a folder exactly once.
-- ------------------------------------------------------------
CREATE TABLE `folder_likes` (
  `id`           INT NOT NULL AUTO_INCREMENT,
  `folder_id`    INT NOT NULL,
  `visitor_hash` CHAR(64) NOT NULL,
  `created_at`   TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_folder_visitor` (`folder_id`, `visitor_hash`),
  CONSTRAINT `folder_likes_ibfk_1`
    FOREIGN KEY (`folder_id`) REFERENCES `folders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- ------------------------------------------------------------
-- 5. Same idea for profile views — one view per visitor per day,
--    so a refresh loop can't inflate the counter.
-- ------------------------------------------------------------
CREATE TABLE `profile_views_log` (
  `id`           INT NOT NULL AUTO_INCREMENT,
  `user_id`      INT NOT NULL,
  `visitor_hash` CHAR(64) NOT NULL,
  `viewed_on`    DATE NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_user_visitor_day` (`user_id`, `visitor_hash`, `viewed_on`),
  CONSTRAINT `profile_views_log_ibfk_1`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- ------------------------------------------------------------
-- 6. The public site looks folders up by (user, visibility) on every
--    profile hit — without this it is a full scan of `folders`.
-- ------------------------------------------------------------
CREATE INDEX `idx_folders_user_visibility`
  ON `folders` (`user_id`, `visibility`);


-- ============================================================
-- 7. USERNAME CLEANUP  —  IMPORTANT, READ BEFORE RUNNING
--
-- `username` is the public URL slug (watchstash.app/@<username>),
-- but rows created by the current google_login.php can contain
-- characters that are not URL-safe. Real examples in your data:
--     'ashishsharmab.tech(cs)2ndsem6'   <- dots and parentheses
--     'витя12', 'المهيبالزريقي13'        <- non-ASCII
--
-- 7a. First, just LOOK at which rows are affected (read-only):
-- ============================================================
SELECT `id`, `username`, `email`
FROM `users`
WHERE `username` NOT REGEXP '^[a-z0-9_]{3,30}$';


-- ------------------------------------------------------------
-- 7b. Then rewrite only those rows to a safe fallback slug
--     ("user<id>"). Affected users can pick a real username from
--     the app's username editor afterwards.
--     Review the 7a output before running this.
-- ------------------------------------------------------------
UPDATE `users`
SET `username` = CONCAT('user', `id`)
WHERE `username` NOT REGEXP '^[a-z0-9_]{3,30}$';


-- ------------------------------------------------------------
-- 8. OPTIONAL — make existing folders public so there is something
--    to see on the public site immediately. Every folder is
--    'private' today, so a fresh public profile renders empty.
--    Replace 1 with the user id you want to test with, or skip
--    this entirely and toggle visibility from the app.
-- ------------------------------------------------------------
-- UPDATE `folders` SET `visibility` = 'public' WHERE `user_id` = 1;
