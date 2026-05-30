import '../../../activitats/model/activitat.dart';

class ActivitySearchResult {
  final String id;
  final String titol;
  final String? espaiNom;
  final String? imatgeUrl;
  final double? preu;
  final bool? esGratuit;
  final double? distanciaKm;
  final Map<String, dynamic>? _rawJson;

  const ActivitySearchResult({
    required this.id,
    required this.titol,
    this.espaiNom,
    this.imatgeUrl,
    this.preu,
    this.esGratuit,
    this.distanciaKm,
    Map<String, dynamic>? rawJson,
  }) : _rawJson = rawJson;

  factory ActivitySearchResult.fromJson(Map<String, dynamic> json) {
    return ActivitySearchResult(
      id: json['id'] as String,
      titol: json['titol'] as String,
      espaiNom: json['espai']?['nom'] as String?,
      imatgeUrl: (json['imatgeUrl'] ?? json['imatge']) as String?,
      preu: (json['preu'] as num?)?.toDouble(),
      esGratuit: json['gratuit'] as bool?,
      distanciaKm: (json['distanciaKm'] as num?)?.toDouble(),
      rawJson: json,
    );
  }

  Activitat toActivitat() {
    return Activitat.fromJson(_rawJson ?? {'id': id, 'titol': titol});
  }
}

class SpaceSearchResult {
  final String id;
  final String nom;
  final String? imatgeUrl;

  const SpaceSearchResult({
    required this.id,
    required this.nom,
    this.imatgeUrl,
  });

  factory SpaceSearchResult.fromJson(Map<String, dynamic> json) {
    return SpaceSearchResult(
      id: json['id'] as String,
      nom: json['nom'] as String,
      imatgeUrl: json['imatgeUrl'] as String?,
    );
  }
}

class SearchResults {
  final List<ActivitySearchResult> activitats;
  final List<SpaceSearchResult> espais;

  const SearchResults({
    this.activitats = const [],
    this.espais = const [],
  });

  factory SearchResults.empty() => const SearchResults();

  bool get isEmpty => activitats.isEmpty && espais.isEmpty;
}

class AirQualityStation {
  final String estacioNom;
  final int aqi;
  final List<ActivitySearchResult> activitats;

  const AirQualityStation({
    required this.estacioNom,
    required this.aqi,
    this.activitats = const [],
  });

  factory AirQualityStation.fromJson(Map<String, dynamic> json) {
    final activitatsRaw =
        (json['activitats'] ?? json['activities'] ?? const []) as List;
    return AirQualityStation(
      estacioNom:
          (json['zone'] ?? json['estacio'] ?? json['nom'] ?? '') as String,
      aqi: (json['aqi'] as num? ?? 0).toInt(),
      activitats: activitatsRaw
          .whereType<Map<String, dynamic>>()
          .map(ActivitySearchResult.fromJson)
          .toList(),
    );
  }
}

class AirQualitySearchResult {
  final List<AirQualityStation> estacions;

  const AirQualitySearchResult({this.estacions = const []});
}