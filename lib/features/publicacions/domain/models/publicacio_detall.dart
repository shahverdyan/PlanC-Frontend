class AutorPublicacio {
  final String id;
  final String nomUsuari;
  final String? fotoPerfil;

  const AutorPublicacio({
    required this.id,
    required this.nomUsuari,
    this.fotoPerfil,
  });

  factory AutorPublicacio.fromJson(Map<String, dynamic> json) {
    return AutorPublicacio(
      id: json['id'] as String? ?? '',
      nomUsuari: json['nomUsuari'] as String? ?? '',
      fotoPerfil: json['fotoPerfil'] as String?,
    );
  }
}

class Multimedia {
  final String id;
  final String url;
  final String? tipus;

  const Multimedia({
    required this.id,
    required this.url,
    this.tipus,
  });

  factory Multimedia.fromJson(Map<String, dynamic> json) {
    return Multimedia(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      tipus: json['tipus'] as String?,
    );
  }
}

class Mencio {
  final String id;
  final String nomUsuari;
  final String? fotoPerfil;

  const Mencio({
    required this.id,
    required this.nomUsuari,
    this.fotoPerfil,
  });

  factory Mencio.fromJson(Map<String, dynamic> json) {
    return Mencio(
      id: json['id'] as String? ?? '',
      nomUsuari: json['nomUsuari'] as String? ?? 'Usuari',
      fotoPerfil: json['fotoPerfil'] as String?,
    );
}
}

class PublicacioDetall {
  final String id;
  final AutorPublicacio autor;
  final List<Multimedia> imatges;
  final List<Mencio> mencions;
  final String descripcio;
  final int likesCount;
  final bool isLikedByMe;
  final int commentsCount;
  final bool isGuardada;
  /// Indica si l'usuari autenticat és l'autor d'aquesta publicació.
  /// Retornat per GET /publicacio/:id (camp `esAutor`).
  final bool esAutor;
  final DateTime dataCreacio;

  const PublicacioDetall({
    required this.id,
    required this.autor,
    required this.imatges,
    required this.mencions,
    required this.descripcio,
    required this.likesCount,
    required this.isLikedByMe,
    required this.commentsCount,
    required this.isGuardada,
    required this.esAutor,
    required this.dataCreacio,
  });

  factory PublicacioDetall.fromJson(Map<String, dynamic> json) {
    // Comptadors: el backend pot retornar-los directament o aniuats.
    final comptadors = json['comptadors'] as Map<String, dynamic>?;

    return PublicacioDetall(
      id: json['id'] as String? ?? '',
      autor: json['autor'] != null
          ? AutorPublicacio.fromJson(json['autor'] as Map<String, dynamic>)
          : const AutorPublicacio(id: '', nomUsuari: ''),
      imatges: (json['multimedia'] as List<dynamic>?)
              ?.map((e) => Multimedia(
                    id: e['id'] as String? ?? '',
                    url: e['url'] as String? ?? '',
                    tipus: e['tipus'] as String?,
                  ))
              .toList() ??
          [],
      mencions: (json['mencions'] as List<dynamic>?)
              ?.map((e) => Mencio.fromJson(e as Map<String, dynamic>))
              .toList() ?? const [],
      descripcio: json['textDescripcio'] as String? ?? '',
      likesCount: json['likesCount'] as int? ??
          comptadors?['magrades'] as int? ??
          0,
      isLikedByMe: json['isLikedByMe'] as bool?
          ?? json['likedByMe'] as bool?
          ?? json['liked'] as bool?
          ?? json['isMagrada'] as bool?
          ?? json['mAgrada'] as bool?
          ?? false,
      commentsCount: json['commentsCount'] as int? ??
          comptadors?['comentaris'] as int? ??
          0,
      isGuardada: json['isGuardada'] as bool? ?? json['guardada'] as bool? ?? false,
      esAutor: json['esAutor'] as bool? ?? false,
      dataCreacio: json['dataCreacio'] != null
          ? DateTime.parse(json['dataCreacio'].toString())
          : DateTime.now(),
    );
  }
}
