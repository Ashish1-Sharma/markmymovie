import 'package:markmymovie/core/constants/tmdb_constants.dart';

/// A single streaming/rental/purchase provider (e.g. Netflix, Prime Video).
/// Transient — fetched live from TMDB, never persisted locally.
class WatchProviderOption {
  final String providerName;
  final String? logoPath;

  WatchProviderOption({required this.providerName, this.logoPath});

  factory WatchProviderOption.fromJson(Map<String, dynamic> json) {
    final path = json['logo_path'] as String?;
    return WatchProviderOption(
      providerName: json['provider_name'] as String? ?? '',
      logoPath:
          (path != null && path.isNotEmpty)
              ? '${TmdbConstants.logoImageBase}$path'
              : null,
    );
  }
}

/// Watch-provider availability for a single region (e.g. "IN"), grouped by
/// how the title can be watched.
class WatchProviderResult {
  final List<WatchProviderOption> flatrate; // subscription streaming
  final List<WatchProviderOption> rent;
  final List<WatchProviderOption> buy;
  final String? link; // TMDB's JustWatch attribution link for this title

  WatchProviderResult({
    this.flatrate = const [],
    this.rent = const [],
    this.buy = const [],
    this.link,
  });

  bool get isEmpty => flatrate.isEmpty && rent.isEmpty && buy.isEmpty;

  factory WatchProviderResult.empty() => WatchProviderResult();

  factory WatchProviderResult.fromRegionJson(Map<String, dynamic>? json) {
    if (json == null) return WatchProviderResult.empty();

    List<WatchProviderOption> parseList(String key) {
      final list = json[key] as List<dynamic>?;
      if (list == null) return const [];
      return list
          .map((e) => WatchProviderOption.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return WatchProviderResult(
      flatrate: parseList('flatrate'),
      rent: parseList('rent'),
      buy: parseList('buy'),
      link: json['link'] as String?,
    );
  }
}
