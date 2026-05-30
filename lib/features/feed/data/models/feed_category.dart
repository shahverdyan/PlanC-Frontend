class FeedCategory {
  final String id;
  final String nom;
  final String? descripcio;

  const FeedCategory({
    required this.id,
    required this.nom,
    this.descripcio,
  });

  factory FeedCategory.fromJson(Map<String, dynamic> json) {
    return FeedCategory(
      id: json['id']?.toString() ?? '',
      nom: json['nom'] as String? ?? '',
      descripcio: json['descripcio'] as String?,
    );
  }
}
