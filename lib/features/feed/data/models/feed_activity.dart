import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/map/presentation/utils/categoria_normalizer.dart';

class FeedActivity {
  final String id;
  final String titol;
  final DateTime dataInici;
  final DateTime? dataFi;
  final bool esGratuit;
  final double? preu;
  final String categoriaNom;
  final String categoriaId;
  final String espaiNom;
  final String? espaiLocalitat;
  final String? imatgePrincipal;
  final int? distanciaMetres;

  const FeedActivity({
    required this.id,
    required this.titol,
    required this.dataInici,
    this.dataFi,
    required this.esGratuit,
    this.preu,
    required this.categoriaNom,
    required this.categoriaId,
    required this.espaiNom,
    this.espaiLocalitat,
    this.imatgePrincipal,
    this.distanciaMetres,
  });

  factory FeedActivity.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? raw) {
      if (raw == null) return DateTime.now();
      final d = DateTime.parse(raw);
      return DateTime(d.year, d.month, d.day, d.hour, d.minute);
    }

    final cat = json['categoria'] as Map<String, dynamic>?;
    final espai = json['espai'] as Map<String, dynamic>?;
    return FeedActivity(
      id: json['id']?.toString() ?? '',
      titol: json['titol'] as String? ?? '',
      dataInici: parseDate(json['dataInici'] as String?),
      dataFi: json['dataFi'] != null
          ? parseDate(json['dataFi'] as String?)
          : null,
      esGratuit: json['esGratuit'] as bool? ?? true,
      preu: (json['preu'] as num?)?.toDouble(),
      categoriaNom: cat?['nom'] as String? ?? '',
      categoriaId: cat?['id']?.toString() ?? '',
      espaiNom: espai?['nom'] as String? ?? '',
      espaiLocalitat: espai?['localitat'] as String?,
      imatgePrincipal: json['imatge'] as String?,
      distanciaMetres: (json['distanciaMetres'] as num?)?.toInt(),
    );
  }

  Activitat toActivitat() {
    return Activitat(
      id: id,
      titol: titol,
      descripcio: '',
      categoria: CategoriaNormalizer.normalize(categoriaNom),
      urlEntrades: '',
      nomEspai: espaiNom,
      adreca: '',
      localitat: espaiLocalitat ?? '',
      lat: 0.0,
      lng: 0.0,
      dataInici: dataInici,
      dataFi: dataFi ?? dataInici,
      esGratuit: esGratuit,
      preu: preu,
      imatge: imatgePrincipal,
    );
  }
}
