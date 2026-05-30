class AutorValoracio {
  final String id;
  final String nomUsuari;
  final String? fotoPerfil;

  const AutorValoracio({
    required this.id,
    required this.nomUsuari,
    this.fotoPerfil,
  });

  factory AutorValoracio.fromJson(Map<String, dynamic> json) => AutorValoracio(
        id: json['id'] as String,
        nomUsuari: json['nomUsuari'] as String,
        fotoPerfil: json['fotoPerfil'] as String?,
      );
}

class Valoracio {
  final String id;
  final int puntuacio;
  final String comentari;
  final DateTime dataValoracio;
  final AutorValoracio autor;
  final bool esMeva;

  const Valoracio({
    required this.id,
    required this.puntuacio,
    required this.comentari,
    required this.dataValoracio,
    required this.autor,
    required this.esMeva,
  });

  factory Valoracio.fromJson(Map<String, dynamic> json) => Valoracio(
        id: json['id'] as String,
        puntuacio: json['puntuacio'] as int,
        comentari: json['comentari'] as String? ?? '',
        dataValoracio: DateTime.parse(json['dataValoracio'] as String),
        autor: AutorValoracio.fromJson(json['autor'] as Map<String, dynamic>),
        esMeva: json['esMeva'] as bool? ?? false,
      );
}

class ValoracionsResponse {
  final double mitjana;
  final int total;
  final List<Valoracio> valoracions;
  final bool hasMore;

  const ValoracionsResponse({
    required this.mitjana,
    required this.total,
    required this.valoracions,
    required this.hasMore,
  });

  factory ValoracionsResponse.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>;
    return ValoracionsResponse(
      mitjana: (json['mitjana'] as num).toDouble(),
      total: json['total'] as int,
      valoracions: (json['valoracions'] as List)
          .map((v) => Valoracio.fromJson(v as Map<String, dynamic>))
          .toList(),
      hasMore: meta['hasMore'] as bool? ?? false,
    );
  }
}
