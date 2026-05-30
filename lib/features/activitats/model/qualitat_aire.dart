class QualitatAire {
  final int aqi;
  final String estacio;
  final double distanciaKm;

  const QualitatAire({
    required this.aqi,
    required this.estacio,
    required this.distanciaKm,
  });

  factory QualitatAire.fromJson(Map<String, dynamic> json) {
    return QualitatAire(
      aqi: json['aqi'] as int,
      estacio: json['estacio'] as String,
      distanciaKm: (json['distanciaKm'] as num).toDouble(),
    );
  }
}
