import '../model/activitat.dart';
import '../model/amic_assistent.dart';
import '../model/qualitat_aire.dart';

abstract class ActivitatsRepository {
  Future<List<Activitat>> getActivitats();
  Future<Activitat> getActivitatById(String id);
  Future<QualitatAire?> getQualitatAire(String id);
  Future<List<AmicAssistentModel>> getAmicsAssistents(String activitatId, String usuariId);
  Future<List<Activitat>> getActivitatsByUserId(String userId);
}