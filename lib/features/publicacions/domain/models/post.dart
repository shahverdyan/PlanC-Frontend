/// Model lleuger per a cada element del feed de publicacions.
/// Mapeja la resposta de GET /publicacio/feed → data[] (via formatarPublicacioCompleta).
///
/// Camps retornats:
///   id, textDescripcio, dataCreacio, esEditada
///   autor { id, nomUsuari, fotoPerfil }
///   activitat { id, titol, dataInici, ... }
///   multimedia [ { id, url, tipus } ]
///   comptadors { magrades, comentaris }
class Post {
  final String id;
  final String autorId;
  final String nomAutor;
  final String? fotoPerfilAutor;
  final String? urlImatgePreview;
  final String descripcio;
  final int likesCount;
  final int commentsCount;
  final DateTime dataCreacio;
  final String? titolActivitat;

  const Post({
    required this.id,
    required this.autorId,
    required this.nomAutor,
    this.fotoPerfilAutor,
    this.urlImatgePreview,
    required this.descripcio,
    required this.likesCount,
    required this.commentsCount,
    required this.dataCreacio,
    this.titolActivitat,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final autor = json['autor'] as Map<String, dynamic>?;
    final multimedia = json['multimedia'] as List<dynamic>?;
    final comptadors = json['comptadors'] as Map<String, dynamic>?;
    final activitat = json['activitat'] as Map<String, dynamic>?;

    // Primera imatge de multimedia com a preview
    final primeraUrl = multimedia
        ?.map((m) => (m as Map<String, dynamic>)['url']?.toString() ?? '')
        .where((url) => url.isNotEmpty)
        .firstOrNull;

    return Post(
      id: json['id'] as String? ?? '',
      autorId: autor?['id'] as String? ?? '',
      nomAutor: autor?['nomUsuari'] as String? ?? '',
      fotoPerfilAutor: autor?['fotoPerfil'] as String?,
      urlImatgePreview: primeraUrl,
      descripcio: json['textDescripcio'] as String? ?? '',
      likesCount: comptadors?['magrades'] as int? ?? 0,
      commentsCount: comptadors?['comentaris'] as int? ?? 0,
      dataCreacio: json['dataCreacio'] != null
          ? DateTime.parse(json['dataCreacio'].toString())
          : DateTime.now(),
      titolActivitat: activitat?['titol'] as String?,
    );
  }
}
