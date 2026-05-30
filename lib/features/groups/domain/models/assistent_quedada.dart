class AssistentQuedadaModel {
  final String id;
  final String nomUsuari;
  final String? fotoPerfil;
  final String estat; // CONFIRMAT | PENDENT_CONFIRMACIO | VALIDAT_GEOLOCALITZACIO
  final bool esCreador;

  const AssistentQuedadaModel({
    required this.id,
    required this.nomUsuari,
    this.fotoPerfil,
    required this.estat,
    required this.esCreador,
  });

  bool get esConfirmat =>
      estat == 'CONFIRMAT' || estat == 'VALIDAT_GEOLOCALITZACIO';
  bool get esValidat => estat == 'VALIDAT_GEOLOCALITZACIO';

  factory AssistentQuedadaModel.fromJson(Map<String, dynamic> json) {
    final usuari = json['usuari'] as Map<String, dynamic>?;
    return AssistentQuedadaModel(
      id: json['usuariId']?.toString() ?? json['id']?.toString() ?? '',
      nomUsuari: json['nomUsuari']?.toString() ??
          usuari?['nomUsuari']?.toString() ??
          json['usuariId']?.toString() ??
          '',
      fotoPerfil: json['fotoPerfil']?.toString() ??
          usuari?['fotoPerfil']?.toString(),
      estat: json['estat']?.toString() ?? 'PENDENT_CONFIRMACIO',
      esCreador: json['rol']?.toString() == 'ADMINISTRADOR',
    );
  }
}
