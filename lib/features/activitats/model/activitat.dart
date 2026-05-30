import 'package:plan_c_frontend/features/map/presentation/utils/categoria_normalizer.dart';

class Activitat {
  final String id;
  final String titol;
  final String descripcio;
  final String categoria;
  final String urlEntrades;
  final String nomEspai;
  final String adreca;
  final String localitat;
  final double lat;
  final double lng;
  final DateTime dataInici;
  final DateTime dataFi;
  final bool? esGratuit;
  final double? preu;
  final String? imatge;

  Activitat({
    required this.id,
    required this.titol,
    required this.descripcio,
    required this.categoria,
    required this.urlEntrades,
    required this.nomEspai,
    required this.adreca,
    required this.localitat,
    required this.lat,
    required this.lng,
    required this.dataInici,
    required this.dataFi,
    this.esGratuit,
    this.preu,
    this.imatge,
  });

  Activitat copyWith({bool? esGratuit, double? preu, String? imatge}) {
    return Activitat(
      id: id,
      titol: titol,
      descripcio: descripcio,
      categoria: categoria,
      urlEntrades: urlEntrades,
      nomEspai: nomEspai,
      adreca: adreca,
      localitat: localitat,
      lat: lat,
      lng: lng,
      dataInici: dataInici,
      dataFi: dataFi,
      esGratuit: esGratuit ?? this.esGratuit,
      preu: preu ?? this.preu,
      imatge: imatge ?? this.imatge,
    );
  }

  factory Activitat.fromJson(Map<String, dynamic> json) {
    return Activitat(
      id: json['id']?.toString() ?? '',
      titol: json['titol'] ?? '',
      descripcio: json['descripcio'] ?? '',
      categoria: CategoriaNormalizer.normalize(
        json['categoria']?['nom'] ?? '',
      ),
      urlEntrades: json['enllacCompra'] ?? '',
      nomEspai: json['espai']?['nom'] ?? '',
      adreca: json['espai']?['adreca'] ?? "",
      localitat: json['espai']?['localitat'] ?? "",
      dataInici: DateTime.tryParse(json['dataInici'] ?? '') ?? DateTime.now(),
      dataFi: DateTime.tryParse(json['dataFi'] ?? '') ?? DateTime.now(),
      lat: (json['latitud'] as num?)?.toDouble() ?? 0.0,
      lng: (json['longitud'] as num?)?.toDouble() ?? 0.0,
      esGratuit: json['esGratuit'] as bool?,
      preu: (json['preu'] as num?)?.toDouble(),
      imatge: (json['imatge'] ?? json['imatgeUrl']) as String?,
    );
  }
}