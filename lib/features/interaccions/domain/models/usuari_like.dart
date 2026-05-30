/// Mini-model per a cada usuari que ha donat m'agrada a una publicació.
class UsuariLike {
  final String id;
  final String nomUsuari;
  final String? fotoPerfil;

  const UsuariLike({
    required this.id,
    required this.nomUsuari,
    this.fotoPerfil,
  });

  factory UsuariLike.fromJson(Map<String, dynamic> json) {
    // El backend pot retornar la info de l'usuari directament o aniuada
    // en un camp 'usuari'. Suportem ambdós formats i diversos noms de camp.
    final nested = json['usuari'] as Map<String, dynamic>?;
    final src = nested ?? json;

    return UsuariLike(
      id: src['id'] as String? ??
          src['usuariId'] as String? ??
          json['usuariId'] as String? ??
          '',
      nomUsuari: src['nomUsuari'] as String? ??
          src['username'] as String? ??
          src['nom_usuari'] as String? ??
          src['name'] as String? ??
          'Usuari',
      fotoPerfil: src['fotoPerfil'] as String? ??
          src['profilePicture'] as String? ??
          src['foto_perfil'] as String?,
    );
  }
}
