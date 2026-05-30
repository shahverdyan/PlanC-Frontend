class Comentari {
  final String id;
  final String publicacioId;
  final String usuariId;
  final String nomUsuari;
  final String? fotoPerfil;
  final String text;
  final DateTime dataCreacio;
  /// Respostes niuades retornades pel backend (camp `respostes`).
  final List<Comentari> respostes;

  const Comentari({
    required this.id,
    required this.publicacioId,
    required this.usuariId,
    required this.nomUsuari,
    this.fotoPerfil,
    required this.text,
    required this.dataCreacio,
    this.respostes = const [],
  });

  factory Comentari.fromJson(Map<String, dynamic> json, {String publicacioId = ''}) {
    // El backend nesta la info de l'autor: { autor: { id, nomUsuari, fotoPerfil } }
    final autor = json['autor'] as Map<String, dynamic>?;
    final pid = json['publicacioId'] as String? ?? publicacioId;

    // Suport per al camp 'respostes' (o 'replies') del backend
    final respostesRaw = (json['respostes'] as List<dynamic>?)
        ?? (json['replies'] as List<dynamic>?)
        ?? [];

    return Comentari(
      id: json['id'] as String? ?? '',
      publicacioId: pid,
      usuariId: autor?['id'] as String? ?? '',
      nomUsuari: autor?['nomUsuari'] as String? ?? 'Usuari',
      fotoPerfil: autor?['fotoPerfil'] as String?,
      text: json['text'] as String? ?? '',
      dataCreacio: json['dataCreacio'] != null
          ? DateTime.parse(json['dataCreacio'].toString())
          : DateTime.now(),
      respostes: respostesRaw
          .map((e) => Comentari.fromJson(e as Map<String, dynamic>, publicacioId: pid))
          .toList(),
    );
  }
}
