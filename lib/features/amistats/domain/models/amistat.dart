enum EstatAmistat {
  pendent,
  acceptada,
  rebutjada,
}

EstatAmistat estatAmistatFromString(String value) {
  switch (value.toUpperCase()) {
    case 'PENDENT':
      return EstatAmistat.pendent;
    case 'ACCEPTADA':
      return EstatAmistat.acceptada;
    case 'REBUTJADA':
      return EstatAmistat.rebutjada;
    default:
      throw Exception('Estat d’amistat desconegut: $value');
  }
}

String estatAmistatToApi(EstatAmistat estat) {
  switch (estat) {
    case EstatAmistat.pendent:
      return 'PENDENT';
    case EstatAmistat.acceptada:
      return 'ACCEPTADA';
    case EstatAmistat.rebutjada:
      return 'REBUTJADA';
  }
}

class Amistat {
  final String sollicitantId;
  final String receptorId;
  final DateTime dataSollicitud;
  final EstatAmistat estat;

  const Amistat({
    required this.sollicitantId,
    required this.receptorId,
    required this.dataSollicitud,
    required this.estat,
  });
}

// Model que retorna el backend per a sol·licituds pendents (rebudes i enviades)
class SolicitudAmistat {
  final String usuariId;
  final String nomUsuari;
  final String? fotoPerfil;

  const SolicitudAmistat({
    required this.usuariId,
    required this.nomUsuari,
    this.fotoPerfil,
  });
}