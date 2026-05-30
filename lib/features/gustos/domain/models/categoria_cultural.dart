class CategoriaCultural {
  final String id;
  final String nom;
  final String descripcio;

  const CategoriaCultural({
    required this.id,
    required this.nom,
    required this.descripcio,
  });

  factory CategoriaCultural.fromJson(Map<String, dynamic> json) {
    return CategoriaCultural(
      id: json['id']?.toString() ?? '',
      nom: json['nom']?.toString() ?? '',
      descripcio: json['descripcio']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'descripcio': descripcio,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CategoriaCultural && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
