import 'package:dio/dio.dart';
import 'package:plan_c_frontend/features/gustos/domain/models/categoria_cultural.dart';
import 'package:plan_c_frontend/features/gustos/domain/repositories/gustos_repository.dart';

class GustosRepositoryImpl implements GustosRepository {
  final Dio dio;

  GustosRepositoryImpl(this.dio);

  @override
  Future<List<CategoriaCultural>> getCategories() async {
    final response = await dio.get('/usuari/categories');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => CategoriaCultural.fromJson(e))
          .toList();
    }
    throw Exception('Error carregant categories');
  }

  @override
  Future<List<CategoriaCultural>> getUserGustos(String userId) async {
    final response = await dio.get(
      '/usuari/perfil/gustos',
      options: Options(headers: {'usuari-id': userId}),
    );
    if (response.statusCode == 200) {
      final categories = response.data['categories'] as List;
      return categories.map((e) => CategoriaCultural.fromJson(e)).toList();
    }
    throw Exception('Error carregant gustos');
  }

  @override
  Future<void> addGust(String userId, String categoriaId) async {
    final response = await dio.patch(
      '/usuari/perfil/gustos/$categoriaId',
      options: Options(headers: {'usuari-id': userId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error afegint gust');
    }
  }

  @override
  Future<void> removeGust(String userId, String categoriaId) async {
    final response = await dio.delete(
      '/usuari/perfil/gustos/$categoriaId',
      options: Options(headers: {'usuari-id': userId}),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error eliminant gust');
    }
  }
}
