import '../models/comentari.dart';
import '../models/usuari_like.dart';
import '../.././../publicacions/domain/models/publicacio_detall.dart';

abstract class InteraccionsRepository {
  Future<PublicacioDetall> fetchPublicacioDetall(String publicacioId);
  Future<List<Comentari>> fetchComentaris(String publicacioId);
  Future<void> enviarComentari(String publicacioId, String text, {String? comentariPareId});
  Future<void> toggleMeGusta(String publicacioId);
  Future<List<UsuariLike>> fetchMeGustaList(String publicacioId);
  Future<bool> toggleGuardarPublicacio(String publicacioId);
  Future<bool> checkPublicacioGuardada(String publicacioId);
}
