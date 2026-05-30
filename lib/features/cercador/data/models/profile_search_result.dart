class ProfileSearchResult {
  final String id;
  final String nomUsuari;
  final String? fotoPerfil;

  const ProfileSearchResult({
    required this.id,
    required this.nomUsuari,
    this.fotoPerfil,
  });

  factory ProfileSearchResult.fromJson(Map<String, dynamic> json) {
    final foto = json['fotoPerfil'] as String?;
    return ProfileSearchResult(
      id: (json['id'] ?? '') as String,
      nomUsuari: (json['nomUsuari'] ?? '') as String,
      fotoPerfil: (foto == null || foto.isEmpty) ? null : foto,
    );
  }
}
