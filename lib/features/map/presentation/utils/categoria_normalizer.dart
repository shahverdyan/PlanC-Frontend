class CategoriaNormalizer {
  static const String exposicions = 'exposicions';
  static const String infantil = 'infantil';
  static const String teatre = 'teatre';
  static const String concerts = 'concerts';
  static const String festes = 'festes';
  static const String festivalsIMostres = 'festivals i mostres';
  static const String conferencies = 'conferencies';
  static const String rutesIVisites = 'rutes i visites';
  static const String altres = 'altres';

  static const List<String> categoriesValides = [
    exposicions,
    infantil,
    teatre,
    concerts,
    festes,
    festivalsIMostres,
    conferencies,
    rutesIVisites,
    altres,
  ];

  static String normalize(String categoria) {
    final c = categoria.trim().toLowerCase();

    if (c == exposicions) return exposicions;
    if (c == infantil) return infantil;
    if (c == teatre) return teatre;
    if (c == concerts) return concerts;
    if (c == festes) return festes;

    if (c == 'festivals-i-mostres' || c == 'festivals/mostres' || c == 'festivals i mostres') {
      return festivalsIMostres;
    }

    if (c == 'conferències' || c == 'conferencies') {
      return conferencies;
    }

    if (c == 'rutes-i-visites' || c == 'rutes/visites' || c == 'rutes i visites') {
      return rutesIVisites;
    }

    return altres;
  }
}