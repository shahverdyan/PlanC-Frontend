class Notificacio {
  final String id;
  final String titol;
  final String cosText;
  final DateTime dataCreacio;
  final bool estaLlegida;
  final String tipus;
  final String? xatId;
  final String? xatNom;

  const Notificacio({
    required this.id,
    required this.titol,
    required this.cosText,
    required this.dataCreacio,
    required this.estaLlegida,
    required this.tipus,
    this.xatId,
    this.xatNom,
  });

  factory Notificacio.fromJson(Map<String, dynamic> json) {
    return Notificacio(
      id: json['id'] as String,
      titol: json['titol'] as String,
      cosText: json['cosText'] as String,
      dataCreacio: DateTime.parse(json['dataCreacio'] as String),
      estaLlegida: json['estaLlegida'] as bool,
      tipus: json['tipus'] as String,
      xatId: json['xatId'] as String?,
      xatNom: json['xatNom'] as String?,
    );
  }
}
