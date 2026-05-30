import 'package:plan_c_frontend/features/gustos/domain/models/categoria_cultural.dart';

abstract class GustosRepository {
  Future<List<CategoriaCultural>> getCategories();
  Future<List<CategoriaCultural>> getUserGustos(String userId);
  Future<void> addGust(String userId, String categoriaId);
  Future<void> removeGust(String userId, String categoriaId);
}
