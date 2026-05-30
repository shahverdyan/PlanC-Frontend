import 'package:plan_c_frontend/features/amistats/domain/models/amistat.dart';

class SolicitudAmistatModel {
  final String usuariId;
  final String nomUsuari;
  final String? fotoPerfil;

  const SolicitudAmistatModel({
    required this.usuariId,
    required this.nomUsuari,
    this.fotoPerfil,
  });

  factory SolicitudAmistatModel.fromJson(Map<String, dynamic> json) {
    return SolicitudAmistatModel(
      usuariId: json['id'].toString(),
      nomUsuari: json['nomUsuari']?.toString() ?? json['id'].toString(),
      fotoPerfil: json['fotoPerfil']?.toString(),
    );
  }

  SolicitudAmistat toDomain() => SolicitudAmistat(
        usuariId: usuariId,
        nomUsuari: nomUsuari,
        fotoPerfil: fotoPerfil,
      );
}