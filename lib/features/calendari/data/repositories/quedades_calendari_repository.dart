import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:plan_c_frontend/core/config/api_config.dart';
import 'package:plan_c_frontend/features/calendari/data/models/quedada_apuntada_model.dart';

class QuedadesCalendariRepository {
  Future<List<QuedadaApuntadaModel>> getQuedadesApuntades(String userId) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/activitats/apuntades');
    final response = await http.get(uri, headers: {
      'usuari-id': userId,
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map(QuedadaApuntadaModel.tryFromJson)
          .whereType<QuedadaApuntadaModel>()
          .toList();
    }
    throw Exception('Error ${response.statusCode} obtenint quedades apuntades');
  }
}
