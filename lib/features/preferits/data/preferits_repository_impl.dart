import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/publicacions/domain/models/post_preview.dart';
import 'package:plan_c_frontend/features/preferits/data/preferits_remote_data_source.dart';
import 'package:plan_c_frontend/features/preferits/domain/preferits_repository.dart';

class PreferitsRepositoryImpl implements PreferitsRepository {
  final PreferitsRemoteDataSource remoteDataSource;

  PreferitsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Activitat>> getActivitatsGuardades({
    required String usuariId,
  }) {
    return remoteDataSource.getActivitatsGuardades(usuariId: usuariId);
  }

  @override
  Future<void> guardarActivitat({
    required String activitatId,
    required String usuariId,
  }) {
    return remoteDataSource.guardarActivitat(
      activitatId: activitatId,
      usuariId: usuariId,
    );
  }

  @override
  Future<void> desguardarActivitat({
    required String activitatId,
    required String usuariId,
  }) {
    return remoteDataSource.desguardarActivitat(
      activitatId: activitatId,
      usuariId: usuariId,
    );
  }

  @override
  Future<List<PostPreview>> getPublicacionsGuardades({
    required String usuariId,
  }) {
    return remoteDataSource.getPublicacionsGuardades(usuariId: usuariId);
  }
}