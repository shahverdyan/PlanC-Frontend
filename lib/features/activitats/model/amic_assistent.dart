class QuedadaAmicModel {
  final String id;
  final String titol;
  final DateTime dataHoraTrobada;

  const QuedadaAmicModel({
    required this.id,
    required this.titol,
    required this.dataHoraTrobada,
  });

  factory QuedadaAmicModel.fromJson(Map<String, dynamic> json) {
    return QuedadaAmicModel(
      id: json['id']?.toString() ?? '',
      titol: json['titol']?.toString() ?? '',
      dataHoraTrobada: DateTime.parse(json['dataHoraTrobada'] as String),
    );
  }
}

class AmicAssistentModel {
  final String id;
  final String nomUsuari;
  final String? fotoPerfil;
  final QuedadaAmicModel quedada;

  const AmicAssistentModel({
    required this.id,
    required this.nomUsuari,
    this.fotoPerfil,
    required this.quedada,
  });

  factory AmicAssistentModel.fromJson(Map<String, dynamic> json) {
    return AmicAssistentModel(
      id: json['id']?.toString() ?? '',
      nomUsuari: json['nomUsuari']?.toString() ?? '',
      fotoPerfil: json['fotoPerfil']?.toString(),
      quedada: QuedadaAmicModel.fromJson(json['quedada'] as Map<String, dynamic>),
    );
  }
}
