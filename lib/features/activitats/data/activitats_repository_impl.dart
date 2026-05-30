import '../model/activitat.dart';
import '../model/amic_assistent.dart';
import '../model/qualitat_aire.dart';
import 'activitats_data_source.dart';
import 'activitats_repository.dart';

class ActivitatsRepositoryImpl implements ActivitatsRepository {
  final ActivitatsDataSource dataSource;

  ActivitatsRepositoryImpl(this.dataSource);

  @override
  Future<List<Activitat>> getActivitats() async {
    return await dataSource.getActivitats();
  }

  @override
  Future<Activitat> getActivitatById(String id) async {
    return await dataSource.getActivitatById(id);
  }

  @override
  Future<QualitatAire?> getQualitatAire(String id) async {
    return await dataSource.getQualitatAire(id);
  }

  @override
  Future<List<AmicAssistentModel>> getAmicsAssistents(
    String activitatId,
    String usuariId,
  ) async {
    return await dataSource.getAmicsAssistents(activitatId, usuariId);
  }

  @override
  Future<List<Activitat>> getActivitatsByUserId(String userId) async {
    return await dataSource.getActivitatsByUserId(userId);
  }
}