import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/groups/data/providers.dart';
import 'package:plan_c_frontend/features/groups/domain/models/assistent_quedada.dart';

// Retorna quedadaId → llista d'assistents amb nom i foto.
// Primer obté els IDs des de /quedada/activitat/:id, després fa crides
// paral·leles a /usuari/:id/perfil per als que no tinguin dades inline.
final assistentsPerActivitatProvider = FutureProvider.autoDispose
    .family<Map<String, List<AssistentQuedadaModel>>, String>(
  (ref, activitatId) async {
    try {
      final dio = ref.watch(dioProvider);
      final response = await dio.get('/quedada/activitat/$activitatId');
      final quedades = response.data as List;
      final result = <String, List<AssistentQuedadaModel>>{};

      for (final q in quedades) {
        final qMap = q as Map<String, dynamic>;
        final qId = qMap['id']?.toString() ?? '';
        if (qId.isEmpty) continue;

        final rawList = (qMap['assistents'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .toList();

        // Crida paral·lela al perfil de cada assistent per obtenir nom i foto.
        final perfils = await Future.wait(
          rawList.map((a) async {
            final userId = a['usuariId']?.toString() ?? '';
            if (userId.isEmpty) return <String, String?>{};
            // Si el backend ja inclou les dades inline no cal la crida extra.
            final usuariNode = a['usuari'] as Map<String, dynamic>?;
            final nomInline = a['nomUsuari']?.toString()
                ?? usuariNode?['nomUsuari']?.toString();
            final fotoInline = a['fotoPerfil']?.toString()
                ?? usuariNode?['fotoPerfil']?.toString();
            if (nomInline != null && nomInline.isNotEmpty) {
              return {'nom': nomInline, 'foto': fotoInline};
            }
            try {
              final r = await dio.get('/usuari/$userId/perfil');
              if (r.statusCode == 200) {
                return {
                  'nom': r.data['name']?.toString(),
                  'foto': r.data['fotoPerfil']?.toString(),
                };
              }
            } catch (_) {}
            return <String, String?>{};
          }),
        );

        result[qId] = List.generate(rawList.length, (i) {
          final a = rawList[i];
          final p = perfils[i];
          return AssistentQuedadaModel(
            id: a['usuariId']?.toString() ?? '',
            nomUsuari: p['nom'] ?? a['usuariId']?.toString() ?? '',
            fotoPerfil: p['foto'],
            estat: a['estat']?.toString() ?? 'PENDENT_CONFIRMACIO',
            esCreador: a['rol']?.toString() == 'ADMINISTRADOR',
          );
        });
      }

      return result;
    } catch (_) {
      return {};
    }
  },
);
