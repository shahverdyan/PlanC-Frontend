class QuedadaApuntadaModel {
  final String quedadaId;
  final String activitatId;
  final String rol;
  final String estat;
  final String titolActivitat;
  final String categoriaNom;
  final String quedadaTitol;
  final DateTime dataHoraTrobada;
  final String estatActual;

  const QuedadaApuntadaModel({
    required this.quedadaId,
    required this.activitatId,
    required this.rol,
    required this.estat,
    required this.titolActivitat,
    required this.categoriaNom,
    required this.quedadaTitol,
    required this.dataHoraTrobada,
    required this.estatActual,
  });

  static QuedadaApuntadaModel? tryFromJson(Map<String, dynamic> json) {
    try {
      final quedada = json['quedada'] as Map<String, dynamic>?;
      final activitat = json['activitat'] as Map<String, dynamic>?;
      final categoria = activitat?['categoria'] as Map<String, dynamic>?;

      final dataStr = quedada?['dataHoraTrobada'] as String?;
      if (dataStr == null || dataStr.isEmpty) return null;
      final data = DateTime.tryParse(dataStr);
      if (data == null) return null;

      return QuedadaApuntadaModel(
        quedadaId: json['quedadaId'] as String? ?? '',
        activitatId: activitat?['id'] as String? ?? '',
        rol: json['rol'] as String? ?? 'MEMBRE',
        estat: json['estat'] as String? ?? 'PENDENT_CONFIRMACIO',
        titolActivitat: activitat?['titol'] as String? ?? '',
        categoriaNom: categoria?['nom'] as String? ?? '',
        quedadaTitol: quedada?['titol'] as String? ?? '',
        dataHoraTrobada: data,
        estatActual: quedada?['estatActual'] as String? ?? '',
      );
    } catch (_) {
      return null;
    }
  }
}
