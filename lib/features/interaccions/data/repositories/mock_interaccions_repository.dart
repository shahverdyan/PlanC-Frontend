import '../../domain/models/comentari.dart';

class MockInteraccionsRepository {
  // Base de datos simulada en memoria
  final List<Comentari> _comentarisFalsos = [
    Comentari(
      id: 'c1',
      publicacioId: 'pub_1', // Este ID coincidirá con el que pidamos luego
      usuariId: 'u1',
      nomUsuari: 'MariaG',
      text: 'Quina bona pinta té aquesta activitat! Hi aniré segur.',
      dataCreacio: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Comentari(
      id: 'c2',
      publicacioId: 'pub_1',
      usuariId: 'u2',
      nomUsuari: 'Joan99',
      text: 'Sabeu si queden entrades disponibles per a demà?',
      dataCreacio: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    Comentari(
      id: 'c3',
      publicacioId: 'pub_1',
      usuariId: 'u3',
      nomUsuari: 'Laura_Cult',
      text: 'Jo hi vaig anar l\'any passat i va ser espectacular. L\'organització és de 10. Molt recomanable per anar-hi en grup.',
      dataCreacio: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  Future<List<Comentari>> getComentaris(String publicacioId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Retorna tots els comentaris independentment del publicacioId
    // perquè el mock funcioni amb qualsevol ID de prova.
    return _comentarisFalsos;
  }
}