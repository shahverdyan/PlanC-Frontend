import 'package:plan_c_frontend/features/amistats/domain/models/amistat.dart';

abstract class AmistatsRepository {
  Future<List<SolicitudAmistat>> obtenirAmistats({
    required String usuariId,
  });

  Future<List<SolicitudAmistat>> obtenirAmistatsPendents({
    required String usuariId,
  });

  Future<List<SolicitudAmistat>> obtenirSolicitudsEnviades({
    required String usuariId,
  });

  Future<void> enviarSolicitud({
    required String usuariId,
    required String altreUsuariId,
  });

  Future<void> cancelarSolicitud({
    required String usuariId,
    required String altreUsuariId,
  });

  Future<void> acceptarSolicitud({
    required String usuariId,
    required String altreUsuariId,
  });

  Future<void> rebutjarSolicitud({
    required String usuariId,
    required String altreUsuariId,
  });

  Future<void> eliminarAmistat({
    required String usuariId,
    required String altreUsuariId,
  });
}