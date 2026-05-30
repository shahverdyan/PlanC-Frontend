import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/search_result.dart';
import '../models/profile_search_result.dart';
import '../../../../core/config/app_config.dart';
// ignore_for_file: use_null_aware_elements

class SearchRemoteDataSource {
  final http.Client client;

  const SearchRemoteDataSource(this.client);

  Future<SearchResults> cercaPredictiva({
    required String terme,
    String tipus = 'tots',
    String? usuariId,
  }) async {
    final queryParams = {
      'terme': terme,
      'tipus': tipus,
      if (usuariId != null) 'usuariId': usuariId,
    };

    final uri = Uri.parse('${AppConfig.baseUrl}explorador/predictiva')
        .replace(queryParameters: queryParams);

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>;

      final activitats = (data['activitats'] as List)
          .map((e) => ActivitySearchResult.fromJson(e as Map<String, dynamic>))
          .toList();

      final espais = (data['espais'] as List)
          .map((e) => SpaceSearchResult.fromJson(e as Map<String, dynamic>))
          .toList();

      return SearchResults(activitats: activitats, espais: espais);
    } else {
      throw Exception('Error cercant activitats: ${response.statusCode}');
    }
  }

  Future<SearchResults> cercarAmbFiltres({
    String? dataInici,
    String? dataFi,
    bool? gratuit,
    double? preuMax,
    double? latitud,
    double? longitud,
    double? radiKm,
    List<String>? categories,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}explorador/cerca');

    final body = <String, dynamic>{
      if (dataInici != null) 'dataInici': dataInici,
      if (dataFi != null) 'dataFi': dataFi,
      if (gratuit != null) 'gratuit': gratuit,
      if (preuMax != null) 'preuMax': preuMax,
      if (latitud != null) 'latitud': latitud,
      if (longitud != null) 'longitud': longitud,
      if (radiKm != null) 'radiKm': radiKm,
      if (categories != null && categories.isNotEmpty) 'categories': categories,
    };

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] as List;

      final activitats = data
          .map((e) => ActivitySearchResult.fromJson(e as Map<String, dynamic>))
          .toList();

      return SearchResults(activitats: activitats, espais: const []);
    } else {
      throw Exception('Error aplicant filtres: ${response.statusCode}');
    }
  }

  Future<List<ProfileSearchResult>> searchProfiles({
    required String query,
    required String userId,
  }) async {
    if (query.length < 2) return const [];
    if (userId.isEmpty) return const [];

    final uri = Uri.parse('${AppConfig.baseUrl}usuari/cerca')
        .replace(queryParameters: {'q': query});

    final response = await client.get(
      uri,
      headers: {
        'usuari-id': userId,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 502) {
      throw Exception('502: El servidor està arrancant');
    }
    if (response.statusCode != 200) {
      throw Exception(
          'Error cercant perfils: ${response.statusCode} - ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return const [];
    final usuaris = decoded['usuaris'] as List?;
    if (usuaris == null || usuaris.isEmpty) return const [];

    return usuaris
        .map((e) => ProfileSearchResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> obtenirHistorial(String usuariId) async {
    final uri =
        Uri.parse('${AppConfig.baseUrl}explorador/historial/$usuariId');

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return List<String>.from(json['data'] as List);
    } else {
      throw Exception('Error obtenint historial: ${response.statusCode}');
    }
  }

  Future<AirQualitySearchResult> cercaQualitatAire({
    required double lat,
    required double lng,
    double? radi,
    int? aqiMax,
  }) async {
    final queryParams = <String, String>{
      'lat': lat.toString(),
      'lng': lng.toString(),
      if (radi != null) 'radi': radi.toInt().toString(),
      if (aqiMax != null) 'aqiMax': aqiMax.toString(),
    };

    final uri = Uri.parse('${AppConfig.baseUrl}activitats/cerca/qualitat-aire')
        .replace(queryParameters: queryParams);

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List rawData;
      if (decoded is List) {
        rawData = decoded;
      } else if (decoded is Map<String, dynamic>) {
        rawData = (decoded['data'] as List?) ?? (decoded['estacions'] as List?) ?? [];
      } else {
        rawData = const [];
      }

      final estacions = rawData
          .whereType<Map<String, dynamic>>()
          .map(AirQualityStation.fromJson)
          .where((s) => s.activitats.isNotEmpty)
          .toList();
      return AirQualitySearchResult(estacions: estacions);
    }

    throw Exception('airQuality:${response.statusCode}');
  }
}