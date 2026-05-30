import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../model/activitat.dart';
import '../model/amic_assistent.dart';
import '../model/qualitat_aire.dart';

abstract class ActivitatsDataSource {
  Future<List<Activitat>> getActivitats();
  Future<Activitat> getActivitatById(String id);
  Future<QualitatAire?> getQualitatAire(String id);
  Future<List<AmicAssistentModel>> getAmicsAssistents(String activitatId, String usuariId);
  Future<List<Activitat>> getActivitatsByUserId(String userId);
}

class ActivitatsRemoteDataSource implements ActivitatsDataSource {
  @override
  Future<List<Activitat>> getActivitats() async {
    final avui = DateTime.now();
    final unMes = avui.add(const Duration(days: 30));
    final dataFiMin = avui.toIso8601String().split('T').first;
    final dataIniciMax = unMes.toIso8601String().split('T').first;

    final uri = Uri.parse('${AppConfig.baseUrl}activitats/mapa').replace(
      queryParameters: {
        'dataFiMin': dataFiMin,
        'dataIniciMax': dataIniciMax,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Error carregant activitats: ${response.statusCode} - ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw Exception('La resposta del backend no és una llista');
    }

    final ara = DateTime.now();

    final activitats = decoded
        .map((json) => Activitat.fromJson(json as Map<String, dynamic>))
        .toList();

    final activitatsDisponibles = activitats
        .where((activitat) => !activitat.dataFi.isBefore(ara))
        .toList();

    return activitatsDisponibles;
  }

  @override
  Future<Activitat> getActivitatById(String id) async {
    final uri = Uri.parse('${AppConfig.baseUrl}activitats/$id/preview');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Error carregant activitat $id: ${response.statusCode} - ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('La resposta del backend no és un objecte vàlid');
    }

    return Activitat.fromJson(decoded);
  }

  @override
  Future<QualitatAire?> getQualitatAire(String id) async {
    final uri = Uri.parse('${AppConfig.baseUrl}activitats/$id/qualitat-aire');
    final response = await http.get(uri);

    if (response.statusCode != 200) return null;

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return null;
    if (decoded['qualitatAire'] == null && !decoded.containsKey('aqi')) return null;
    if (decoded.containsKey('qualitatAire') && decoded['qualitatAire'] == null) return null;

    return QualitatAire.fromJson(decoded);
  }

  @override
  Future<List<AmicAssistentModel>> getAmicsAssistents(
    String activitatId,
    String usuariId,
  ) async {
    final uri = Uri.parse('${AppConfig.baseUrl}activitats/$activitatId/amics-assistents');
    final response = await http.get(uri, headers: {'usuari-id': usuariId});

    if (response.statusCode != 200) return [];

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return [];

    final amicsList = decoded['amics'];
    if (amicsList is! List) return [];

    return amicsList
        .whereType<Map<String, dynamic>>()
        .map(AmicAssistentModel.fromJson)
        .toList();
  }

  @override
  Future<List<Activitat>> getActivitatsByUserId(String userId) async {
    final uri = Uri.parse('${AppConfig.baseUrl}usuari/activitats');
    final response = await http.get(uri, headers: {'usuari-id': userId});

    if (response.statusCode != 200) {
      throw Exception(
        'Error carregant activitats per a l\'usuari $userId: ${response.statusCode} - ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    final List<dynamic> dataList = decoded['data'] as List<dynamic>;


    return dataList
        .map<Activitat>((json) => Activitat.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}