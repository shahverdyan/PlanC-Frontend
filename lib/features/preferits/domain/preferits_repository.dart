import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/publicacions/domain/models/post_preview.dart';

abstract class PreferitsRepository {
  Future<List<Activitat>> getActivitatsGuardades({
    required String usuariId,
  });

  Future<void> guardarActivitat({
    required String activitatId,
    required String usuariId,
  });

  Future<void> desguardarActivitat({
    required String activitatId,
    required String usuariId,
  });

  Future<List<PostPreview>> getPublicacionsGuardades({
    required String usuariId,
  });
}