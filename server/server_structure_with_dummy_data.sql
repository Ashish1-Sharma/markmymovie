-- Adminer 5.5.1 MySQL 8.0.42-0ubuntu0.20.04.1 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `folder_movie_sync`;
CREATE TABLE `folder_movie_sync` (
  `id` int NOT NULL AUTO_INCREMENT,
  `folder_id` varchar(100) NOT NULL,
  `movie_id` varchar(100) NOT NULL,
  `movie_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_movie_id` (`movie_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `folder_movie_sync` (`id`, `folder_id`, `movie_id`, `movie_name`, `created_at`) VALUES
(1,	'0',	'0',	'',	'2026-05-30 10:55:37'),
(2,	'1',	'2',	'',	'2026-05-30 10:56:22'),
(4,	'1',	'3',	'',	'2026-05-30 11:02:20'),
(5,	'1',	'4',	'',	'2026-05-30 11:02:38'),
(6,	'1',	'5',	'Ready Player One',	'2026-05-30 11:04:19'),
(7,	'1',	'6',	'Rogue One: A Star Wars Story',	'2026-05-30 11:04:24'),
(8,	'1',	'7',	'One Battle After Another',	'2026-05-30 11:04:30'),
(9,	'1',	'0',	'Ome Cor',	'2026-05-30 11:17:52'),
(11,	'1',	'tt2802976',	'The Legend of Ome: No Way Out',	'2026-05-30 11:19:45'),
(12,	'1',	'tt2802976',	'The Legend of Ome: No Way Out',	'2026-05-30 11:21:19'),
(13,	'1',	'tt2802976',	'The Legend of Ome: No Way Out',	'2026-05-30 11:21:21'),
(14,	'1',	'tt2802976',	'The Legend of Ome: No Way Out',	'2026-05-30 11:21:23'),
(15,	'1',	'tt2802976',	'The Legend of Ome: No Way Out',	'2026-05-30 11:21:27'),
(16,	'1',	'tt2435224',	'The Legend of Ome',	'2026-05-30 11:21:44'),
(17,	'1',	'tt0120667',	'Fantastic Four',	'2026-06-01 04:44:26'),
(18,	'1',	'tt0159206',	'Sex and the City',	'2026-06-02 04:53:28'),
(19,	'1',	'tt2580046',	'Miraculous: Tales of Ladybug & Cat Noir',	'2026-06-03 11:33:25'),
(20,	'1',	'tt1375666',	'Inception',	'2026-06-06 02:06:32'),
(21,	'1',	'tt5295894',	'Inception: The Cobol Job',	'2026-06-06 02:07:08'),
(22,	'1',	'tt6793710',	'The Crack: Inception',	'2026-06-06 02:07:27'),
(23,	'1',	'tt14088510',	'Tarot',	'2026-06-13 14:49:19'),
(24,	'1',	'tt14088510',	'Tarot',	'2026-06-13 14:49:23'),
(25,	'1',	'tt26443616',	'Hoppers',	'2026-06-13 14:51:06'),
(26,	'1',	'tt26443616',	'Hoppers',	'2026-06-13 14:52:45'),
(27,	'1',	'tt0944947',	'Game of Thrones',	'2026-06-24 19:40:29'),
(28,	'1',	'tt0944947',	'Game of Thrones',	'2026-06-24 19:40:52'),
(29,	'1',	'tt28498932',	'Pyasi Pushpa',	'2026-06-26 11:16:37'),
(30,	'1',	'tt11214590',	'House of Gucci',	'2026-06-26 15:44:03'),
(31,	'1',	'tt11214590',	'House of Gucci',	'2026-06-26 15:44:13'),
(32,	'1',	'tt0032138',	'The Wizard of Oz',	'2026-06-28 00:23:07'),
(33,	'1',	'tt1179891',	'My Bloody Valentine',	'2026-06-28 01:20:18'),
(34,	'1',	'tt17490712',	'Mortal Kombat II',	'2026-06-28 02:23:20'),
(35,	'1',	'tt17490712',	'Mortal Kombat II',	'2026-06-28 02:23:33'),
(36,	'1',	'tt18673856',	'Family Express Bengali Movie',	'2026-06-28 17:05:22'),
(37,	'1',	'tt0988824',	'Naruto: Shippuden',	'2026-06-29 12:28:58'),
(38,	'1',	'tt0988824',	'Naruto: Shippuden',	'2026-06-29 12:29:08'),
(39,	'1',	'tt1954470',	'Gangs of Wasseypur',	'2026-06-29 13:40:41'),
(40,	'1',	'tt1954470',	'Gangs of Wasseypur',	'2026-06-29 13:41:14'),
(41,	'1',	'tt39139925',	'Dhurandhar The Revenge',	'2026-07-09 14:36:19'),
(42,	'1',	'tt34610311',	'The Shadow\'s Edge',	'2026-07-09 15:55:26'),
(43,	'1',	'tt9376612',	'Shang-Chi and the Legend of the Ten Rings',	'2026-07-09 15:57:21'),
(44,	'1',	'tt0388629',	'One Piece',	'2026-07-10 04:09:11'),
(45,	'1',	'tt0388629',	'One Piece',	'2026-07-10 11:17:26'),
(46,	'1',	'tt4154664',	'Captain Marvel',	'2026-07-11 16:00:25'),
(47,	'1',	'tt0378109',	'Into the Blue',	'2026-07-12 02:08:07')
ON DUPLICATE KEY UPDATE `id` = VALUES(`id`), `folder_id` = VALUES(`folder_id`), `movie_id` = VALUES(`movie_id`), `movie_name` = VALUES(`movie_name`), `created_at` = VALUES(`created_at`);

DROP TABLE IF EXISTS `folders`;
CREATE TABLE `folders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text,
  `slug` varchar(150) DEFAULT NULL,
  `visibility` enum('private','public','unlisted') DEFAULT 'private',
  `icon_codepoint` int DEFAULT NULL,
  `icon_font_family` varchar(100) DEFAULT NULL,
  `color_value` bigint DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `folders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `folders` (`id`, `user_id`, `name`, `description`, `slug`, `visibility`, `icon_codepoint`, `icon_font_family`, `color_value`, `created_at`, `updated_at`) VALUES
(1,	8,	'Action Packed',	'',	NULL,	'private',	58258,	'MaterialIcons',	4294924066,	'2026-07-14 15:12:34',	'2026-07-14 15:12:34'),
(2,	8,	'Action Packed',	'',	NULL,	'private',	58258,	'MaterialIcons',	4294924066,	'2026-07-14 15:12:54',	'2026-07-14 15:12:54'),
(3,	8,	'Date Ni',	'',	NULL,	'private',	57947,	'MaterialIcons',	4293467747,	'2026-07-14 15:13:01',	'2026-07-14 15:13:01'),
(4,	8,	'Weekend Watch',	'',	NULL,	'private',	59105,	'MaterialIcons',	4293200148,	'2026-07-14 16:01:29',	'2026-07-14 16:01:29'),
(5,	8,	'Action Packed',	'',	NULL,	'private',	58258,	'MaterialIcons',	4294924066,	'2026-07-14 16:01:29',	'2026-07-14 16:01:29'),
(6,	8,	'Date Night',	'',	NULL,	'private',	57947,	'MaterialIcons',	4293467747,	'2026-07-14 16:01:29',	'2026-07-14 16:01:29'),
(7,	8,	'Action Packed',	'',	NULL,	'private',	58258,	'MaterialIcons',	4294924066,	'2026-07-14 16:01:30',	'2026-07-14 16:01:30'),
(8,	8,	'Action Packed',	'',	NULL,	'private',	58258,	'MaterialIcons',	4294924066,	'2026-07-14 16:01:30',	'2026-07-14 16:01:30'),
(9,	10,	'Action Packed',	'',	NULL,	'private',	58964,	'MaterialIcons',	4294924066,	'2026-07-15 12:31:59',	'2026-07-15 12:31:59'),
(10,	13,	'Action Packed',	'',	NULL,	'private',	59045,	'MaterialIcons',	4294924066,	'2026-07-16 21:10:08',	'2026-07-16 21:10:08'),
(11,	6,	'Family Time',	'',	NULL,	'private',	57943,	'MaterialIcons',	4283215696,	'2026-07-17 12:08:40',	'2026-07-17 12:08:40'),
(12,	19,	'Weekend Watch',	'',	NULL,	'private',	58381,	'MaterialIcons',	4293200148,	'2026-07-26 07:17:04',	'2026-07-26 07:17:04'),
(13,	22,	'Weekend Watch',	'',	NULL,	'private',	59105,	'MaterialIcons',	4293200148,	'2026-07-28 06:23:19',	'2026-07-28 06:23:19'),
(14,	22,	'Action Packed',	'',	NULL,	'private',	58258,	'MaterialIcons',	4294924066,	'2026-07-28 06:23:48',	'2026-07-28 06:23:48'),
(15,	25,	'Weekend Watch',	'',	NULL,	'private',	59105,	'MaterialIcons',	4293200148,	'2026-07-29 15:37:44',	'2026-07-29 15:37:44'),
(16,	25,	'Horror Nights',	'',	NULL,	'private',	58414,	'MaterialIcons',	4288423856,	'2026-07-29 15:38:02',	'2026-07-29 15:38:02'),
(17,	26,	'Action Packed',	'',	NULL,	'private',	58258,	'MaterialIcons',	4294924066,	'2026-07-29 15:53:39',	'2026-07-29 15:53:39'),
(18,	32,	'hi',	'',	NULL,	'private',	58381,	'MaterialIcons',	4293200148,	'2026-08-02 12:00:15',	'2026-08-02 12:00:15'),
(19,	35,	'Action Packe',	'',	NULL,	'private',	58019,	'MaterialIcons',	4294956544,	'2026-08-02 14:25:57',	'2026-08-02 14:25:57'),
(20,	36,	'Action Packed',	'',	NULL,	'private',	59045,	'MaterialIcons',	4294924066,	'2026-08-02 15:48:37',	'2026-08-02 15:48:37'),
(21,	29,	'Weekend Watch',	'',	NULL,	'private',	59105,	'MaterialIcons',	4293200148,	'2026-08-05 19:06:04',	'2026-08-05 19:06:04'),
(22,	29,	'Date Night',	'',	NULL,	'private',	57947,	'MaterialIcons',	4293467747,	'2026-08-05 19:06:11',	'2026-08-05 19:06:11')
ON DUPLICATE KEY UPDATE `id` = VALUES(`id`), `user_id` = VALUES(`user_id`), `name` = VALUES(`name`), `description` = VALUES(`description`), `slug` = VALUES(`slug`), `visibility` = VALUES(`visibility`), `icon_codepoint` = VALUES(`icon_codepoint`), `icon_font_family` = VALUES(`icon_font_family`), `color_value` = VALUES(`color_value`), `created_at` = VALUES(`created_at`), `updated_at` = VALUES(`updated_at`);

DROP TABLE IF EXISTS `movies`;
CREATE TABLE `movies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `folder_id` int NOT NULL,
  `imdb_id` varchar(30) NOT NULL,
  `tmdb_type` varchar(20) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `original_title` varchar(255) DEFAULT NULL,
  `plot_overview` text,
  `type` varchar(20) DEFAULT NULL,
  `year` int DEFAULT NULL,
  `genre_names` json DEFAULT NULL,
  `user_rating` float DEFAULT NULL,
  `poster` text,
  `original_language` varchar(20) DEFAULT NULL,
  `trailer` text,
  `trailer_thumbnail` text,
  `is_watch` tinyint(1) DEFAULT '0',
  `modified_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_movie` (`user_id`,`folder_id`,`imdb_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_folder` (`folder_id`),
  KEY `idx_imdb` (`imdb_id`),
  CONSTRAINT `movies_ibfk_1` FOREIGN KEY (`folder_id`) REFERENCES `folders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `movies_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `movies` (`id`, `user_id`, `folder_id`, `imdb_id`, `tmdb_type`, `title`, `original_title`, `plot_overview`, `type`, `year`, `genre_names`, `user_rating`, `poster`, `original_language`, `trailer`, `trailer_thumbnail`, `is_watch`, `modified_time`, `created_at`) VALUES
(1,	8,	2,	'tt41810573',	'movie',	'Die Die Delta Pi II: The Burnt One',	'Die Die Delta Pi II: The Burnt One',	'Thirteen years after the last Delta Pi massacre a new group of sorority sisters decide to get the Delta Pi sorority up and running again. Little do they know that a new killer has emerged taking out the sisters one by one. Will th...',	'movie',	2026,	'[\"Horror\"]',	0,	'https://m.media-amazon.com/images/M/MV5BM2IxNGFmNjktZDI3Yi00YWU2LTkzZGQtNWU3ZjM2Mjk1ZDdmXkEyXkFqcGc@._V1_QL75_UX380_CR0,0,380,562_.jpg',	'English',	'',	'',	0,	'2026-07-14 15:47:24',	'2026-07-14 15:47:24'),
(2,	8,	5,	'tt11737520',	'series',	'One Piece',	'One Piece',	'With his straw hat and ragtag crew, young pirate Monkey D. Luffy goes on an epic voyage for treasure.',	'series',	2023,	'[\"Action\", \"Adventure\", \"Comedy\"]',	8.3,	'https://m.media-amazon.com/images/M/MV5BNDk5MDFlYjYtZjQ5ZS00ZjhkLWJkYmMtYzhmZjkyOWExY2M3XkEyXkFqcGc@._V1_QL75_UX380_CR0,0,380,562_.jpg',	'English',	'',	'',	0,	'2026-07-14 16:01:30',	'2026-07-14 16:01:30'),
(3,	8,	7,	'tt9430698',	'movie',	'One Piece: Stampede',	'One Piece: Stampede',	'The Straw Hat crew are invited to the world\'s biggest pirate event to join the hunt for Gol D. Roger\'s lost treasure.',	'movie',	2019,	'[\"Animation\", \"Action\", \"Adventure\"]',	7.5,	'https://m.media-amazon.com/images/M/MV5BY2FlYzRmZGMtM2Y5OC00NzFhLTgyNDAtZDk1YjdkZTlmMjE3XkEyXkFqcGc@._V1_SX300.jpg',	'Japanese, English',	'',	'',	0,	'2026-07-14 16:04:10',	'2026-07-14 16:01:30'),
(4,	6,	11,	'tt37287335',	'movie',	'Obsession',	'Obsession',	'After breaking the mysterious \"One Wish Willow\" to win his crush\'s heart, a hopeless romantic finds himself getting exactly what he asked for but soon discovers that some desires come at a dark, sinister price.',	'movie',	2026,	'[\"Horror\", \"Romance\", \"Thriller\"]',	8,	'https://m.media-amazon.com/images/M/MV5BYzc1NWUwMDgtNGZlMS00ZmYzLWIzMzktNmMxMmY1MTUzNWExXkEyXkFqcGc@._V1_QL75_UX380_CR0,0,380,562_.jpg',	'English',	'',	'',	0,	'2026-07-17 12:08:59',	'2026-07-17 12:08:59'),
(5,	36,	20,	'tt22084616',	'movie',	'Spider-Man: Brand New Day',	'Spider-Man: Brand New Day',	'A forgotten Peter Parker lives alone as a full-time Spider-Man until mounting pressure triggers a dangerous change and a powerful new enemy emerges.',	'movie',	2026,	'[\"Action\", \"Adventure\", \"Fantasy\"]',	0,	'https://m.media-amazon.com/images/M/MV5BOWNjYWM3NWItOGE0ZS00MWRjLThiZWEtYjc4ZmNmMmU5ZTVmXkEyXkFqcGc@._V1_QL75_UX380_CR0,0,380,562_.jpg',	'English',	'',	'',	1,	'2026-08-02 15:51:46',	'2026-08-02 15:49:41')
ON DUPLICATE KEY UPDATE `id` = VALUES(`id`), `user_id` = VALUES(`user_id`), `folder_id` = VALUES(`folder_id`), `imdb_id` = VALUES(`imdb_id`), `tmdb_type` = VALUES(`tmdb_type`), `title` = VALUES(`title`), `original_title` = VALUES(`original_title`), `plot_overview` = VALUES(`plot_overview`), `type` = VALUES(`type`), `year` = VALUES(`year`), `genre_names` = VALUES(`genre_names`), `user_rating` = VALUES(`user_rating`), `poster` = VALUES(`poster`), `original_language` = VALUES(`original_language`), `trailer` = VALUES(`trailer`), `trailer_thumbnail` = VALUES(`trailer_thumbnail`), `is_watch` = VALUES(`is_watch`), `modified_time` = VALUES(`modified_time`), `created_at` = VALUES(`created_at`);

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `google_id` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `name` varchar(150) NOT NULL,
  `bio` varchar(300) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `profile_picture` text,
  `banner_image` text,
  `profile_views` int DEFAULT '0',
  `total_likes` int DEFAULT '0',
  `is_profile_public` tinyint(1) DEFAULT '1',
  `login_provider` enum('google') DEFAULT 'google',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `google_id` (`google_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `unique_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `users` (`id`, `google_id`, `username`, `name`, `bio`, `email`, `profile_picture`, `banner_image`, `profile_views`, `total_likes`, `is_profile_public`, `login_provider`, `is_active`, `created_at`, `last_login_at`) VALUES
(1,	'106807914882090036233',	'ashishsharma1',	'ASHISH SHARMA',	NULL,	'wwwviveksharma45@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocLNI1sMJQ7JnodHYQXJCRHWzxWnXCEXWaKNARLmjQMXGGxmQe2I2w=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-10 10:15:32',	'2026-07-17 12:34:45'),
(6,	'103563881910804552526',	'ashishsharmab.tech(cs)2ndsem6',	'ASHISH SHARMA B.TECH (CS) 2nd Sem',	NULL,	'2101270100023@iimtindia.net',	'https://lh3.googleusercontent.com/a/ACg8ocKrgbFyVO99dIwTrSBXVGPYxCo2hua9F3cHlrlWrTiPStN1fg=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-10 10:23:55',	'2026-07-17 12:34:45'),
(8,	'110606198271411636244',	'ashishsharma8',	'Ashish sharma',	NULL,	'ashish01sharma98@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocIGPIVsbebYrzKsYDKZKYpS-FFFST6DsDQZhTC6bXrfSMuAZg=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-14 14:00:46',	'2026-07-17 12:34:45'),
(10,	'111213963462442238895',	'kmaya10',	'K Maya',	NULL,	'mk7722605@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocJmz-TZVIpWCZy7yJeOqDKbCKG_0T60_jB_NM7EKknhn6zl3g=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-15 12:31:34',	'2026-07-17 12:34:45'),
(11,	'116296854765254353772',	'danny11',	'Danny',	NULL,	'd13037273@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocICxVUPTL7Qe0P9d70Zg5EdpkXCYy9uvxqWZgNKEIZQ5LZnjg=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-16 01:33:07',	'2026-07-17 12:34:45'),
(12,	'111065431325188766325',	'витя12',	'Витя',	NULL,	'v22205093@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocJUqRGjLNUFajM6JRQxHX-zByrIPifhSsoIg6weDgIpIWT90w=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-16 15:48:27',	'2026-07-17 12:34:45'),
(13,	'110281087708976139042',	'المهيبالزريقي13',	'المهيب الزريقي',	NULL,	'alzryqyalmhyb@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocLXksW3fCSUlVByq8DylPYjA04BWkN5Qo5eGFvtBYkQ8BcsGw=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-16 21:08:43',	'2026-07-17 12:34:45'),
(14,	'112328607684570919326',	'alanñn14',	'Alanñn',	NULL,	'alanrarackal@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocK8QpGQ6C77bNHiC_w6eJ9UcZOTlDADVFR-GJR7QhkjzeIZtkfh=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-17 01:53:28',	'2026-07-17 12:34:45'),
(15,	'109448877854318705520',	'ayşe15',	'Ayşe',	NULL,	'zekicim57@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocIJuH-gCEeJk1VcIaLYH2cfd61tqfq6zLTixrtihSSC4SGDIw=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-17 03:52:04',	'2026-07-17 12:34:45'),
(17,	'100677122263884516108',	'rubeesanjeev121',	'Vivek Shrama',	NULL,	'rubeesanjeev121@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocI0pabi4VsHWiE-vLYbiaFjVPAQGKDO8BNk55kNK3Vc8an3VpE=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-25 14:19:32',	'2026-07-25 14:19:32'),
(18,	'101747534130151642800',	'vivekksharmaa35',	'Vivek Sharma',	NULL,	'vivekksharmaa35@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocJL-A8_YzQqiJBYmssXP0g_0JP7ViuGVKbrFbfcadUMD7CfhGWm=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-25 14:19:51',	'2026-07-25 14:19:51'),
(19,	'114925128014948203352',	'maliknoor7769',	'Malik Muhammad Noor',	NULL,	'maliknoor7769@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocLoIyqgHIe3qqtnUP6fuW39Hh6X0TkaHS1JWAJCfMD1lNwTJw=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-26 07:16:08',	'2026-07-26 07:16:08'),
(20,	'111356292852772383349',	'vosnm88',	'VOSNM',	NULL,	'vosnm88@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocIgpYhOvA99G55vHCw2QrXyJcAEgFB6OyW2ZRKQK9sg7o0LqA4=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-27 14:38:31',	'2026-07-27 14:38:31'),
(21,	'107208628827024909543',	'jessicapatrick58540',	'Jessica Patrick',	NULL,	'jessicapatrick.58540@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocKSYEKC3OvzJ9Vy6Vhii__ojLz44-3VwYOoFTV_ZCw324J7mQ=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-28 06:19:59',	'2026-07-28 06:19:59'),
(22,	'105095711528737491249',	'mariandouglas66512',	'Marian Douglas',	NULL,	'mariandouglas.66512@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocJqXW72qKgQSH1CjOePJC3D2hDU8ktui-qBNzFuPYWnQVfFEA=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-28 06:22:01',	'2026-07-28 06:22:01'),
(23,	'113952907070632354220',	'asacf42hjukolrdgpxbanelvl01',	'Nuage Laboratoire',	NULL,	'asacf42hjukolrdgpxbane-lvl-01@cloudtestlabaccounts.com',	'https://lh3.googleusercontent.com/a/ACg8ocJJdZWrYPKMkTcHzP1ly3aZESAjaeI6aDQyjDwAiv45VGSZ2g=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-28 07:07:00',	'2026-07-28 07:07:00'),
(24,	'106449440510666473525',	'baldeznicolas9',	'Nicolas Baldez',	NULL,	'baldeznicolas9@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocISUAXtR4uXu3TnqnDcr93M7xJQSfobgBy_HUeKAUs3sFawz7_k=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-28 23:48:50',	'2026-07-28 23:48:50'),
(25,	'109265659512167721914',	'passionsosweet',	'Passion Nichcole and Taylor',	NULL,	'passionsosweet@gmail.com',	'',	NULL,	0,	0,	1,	'google',	1,	'2026-07-29 15:37:20',	'2026-07-29 15:37:20'),
(26,	'105125248780519636509',	'dragoslavfiric',	'Dragoslav Firic',	NULL,	'dragoslav.firic@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocI5_vcF-qDQy714decF3cRa30bFBmHlwYcvFrMhQnPCgwSNoM4u=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-29 15:53:14',	'2026-07-29 15:53:14'),
(27,	'101434439849198798755',	'andrejkobylanskij1',	'Андрей Кобылянский',	NULL,	'andrejkobylanskij1@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocICLQgD2ISDp9246-pHrfn1J64NWWdVMv7wQf6UEZTTVXMCqQ=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-07-30 13:29:14',	'2026-07-30 13:29:14'),
(28,	'107422192037766289364',	'm90358926',	'Mayalama',	NULL,	'm90358926@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocKoCDse_IKcBYrbhZzxypo03e6S-bRdvisEGTNH4NEOHY500w=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-08-01 06:01:47',	'2026-08-01 06:01:47'),
(29,	'101814419851960824813',	'salmanf131995',	'Salman',	NULL,	'salmanf131995@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocJ-h2lR2kgw3jHtQdvM3RVXZcg09oeR8ztEOjZnDvqgtRwhS1o=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-08-01 09:01:45',	'2026-08-01 09:01:45'),
(30,	'107156974291755439752',	'jaggipulkit31',	'jaggi pulkit',	NULL,	'jaggipulkit31@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocKM5EVWThC48T00pSm70bKeEhWGFjBYoq5GxxBBfK-Zu4rp_bzJ=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-08-01 10:06:07',	'2026-08-01 10:06:07'),
(31,	'109264072942740213582',	'shumailabalouch890',	'Shumaila Khan',	NULL,	'shumailabalouch890@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocKReL2YdW-eJ9mpBjNKKjk2ns1VxPeWKZjOL5oKYevsWSAUIw=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-08-01 13:06:57',	'2026-08-01 13:06:57'),
(32,	'104410974583500076198',	'saifullahkhan20024',	'Saifullah Khan',	NULL,	'saifullahkhan20024@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocIHy9OP5StPXhqJTuHcHLTeNquFxpliDp5hhTyoHux3FlOZgb0=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-08-02 11:59:47',	'2026-08-02 11:59:47'),
(33,	'104289695451320907827',	'bischoffoli1978',	'Oli Bischoff',	NULL,	'bischoffoli1978@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocIt5SUuukrcneYbO8li8PrU4LHBZEIdB3cZtp--XmRS0Lssnw=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-08-02 12:04:10',	'2026-08-02 12:04:10'),
(34,	'106011332105606156119',	'farmankhan700700',	'Farman Khan',	NULL,	'farmankhan700700@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocLTdJK2XhG8ewt_uLPvgjp6WiiHUOwksgFah40BcZFHDl2Eqw=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-08-02 12:04:33',	'2026-08-02 12:04:33'),
(35,	'114815219926561184767',	'cshameer733',	'Shameer C',	NULL,	'cshameer733@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocJ56e_icD-nLpIwmBz_c3NlxB7YQB7VyNcLlaE459gC6bz0XQ=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-08-02 14:24:37',	'2026-08-02 14:24:37'),
(36,	'102119612834034609720',	'shahzadbhayo257',	'Shahzad bhayo',	NULL,	'shahzadbhayo257@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocIiMVM8SQK9oOdNz04PbCg2qQI2k8eL_rj0MjRj6jS5cNOGFQ=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-08-02 15:47:26',	'2026-08-02 15:47:26'),
(37,	'110638568030354714126',	'dossantosevandropinheiro',	'Evandro pinheiro Dos santos',	NULL,	'dossantosevandropinheiro@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocIQ87DyuuYyNFI_I0R9g_IApPZQQhUriQQ12ZSFWFbV0TUfSM5d=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-08-07 01:30:10',	'2026-08-07 01:30:10'),
(38,	'111837122357627744969',	'psychodoglady62',	'Rita Johnson',	NULL,	'psychodoglady62@gmail.com',	'https://lh3.googleusercontent.com/a/ACg8ocJVHWgbWwgCIPEGHbLzSEdjF0qkPu0lk2R6aVyJBTkUfvJgKQ=s96-c',	NULL,	0,	0,	1,	'google',	1,	'2026-08-10 09:30:26',	'2026-08-10 09:30:26')
ON DUPLICATE KEY UPDATE `id` = VALUES(`id`), `google_id` = VALUES(`google_id`), `username` = VALUES(`username`), `name` = VALUES(`name`), `bio` = VALUES(`bio`), `email` = VALUES(`email`), `profile_picture` = VALUES(`profile_picture`), `banner_image` = VALUES(`banner_image`), `profile_views` = VALUES(`profile_views`), `total_likes` = VALUES(`total_likes`), `is_profile_public` = VALUES(`is_profile_public`), `login_provider` = VALUES(`login_provider`), `is_active` = VALUES(`is_active`), `created_at` = VALUES(`created_at`), `last_login_at` = VALUES(`last_login_at`);

-- 2026-08-10 19:02:51 UTC
