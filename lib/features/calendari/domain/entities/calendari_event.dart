class CalendariEvent {
  final String titol;
  final String ubicacio;
  final String descripcio;
  final DateTime dataInici;
  final DateTime dataFi;
  final int? alertaMinuts;

  const CalendariEvent({
    required this.titol,
    required this.ubicacio,
    required this.descripcio,
    required this.dataInici,
    required this.dataFi,
    this.alertaMinuts,
  });

  CalendariEvent copyWith({
    String? titol,
    String? ubicacio,
    String? descripcio,
    DateTime? dataInici,
    DateTime? dataFi,
    int? alertaMinuts,
    bool clearAlerta = false,
  }) {
    return CalendariEvent(
      titol: titol ?? this.titol,
      ubicacio: ubicacio ?? this.ubicacio,
      descripcio: descripcio ?? this.descripcio,
      dataInici: dataInici ?? this.dataInici,
      dataFi: dataFi ?? this.dataFi,
      alertaMinuts: clearAlerta ? null : (alertaMinuts ?? this.alertaMinuts),
    );
  }
}
