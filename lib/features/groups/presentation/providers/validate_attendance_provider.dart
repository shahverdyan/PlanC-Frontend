import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:plan_c_frontend/features/groups/data/datasources/validation_remote_data_source.dart';

enum ValidateAttendanceStatus { idle, loading, validated, error }

class ValidateAttendanceState {
  final ValidateAttendanceStatus status;
  final String? errorMessage;

  const ValidateAttendanceState({
    this.status = ValidateAttendanceStatus.idle,
    this.errorMessage,
  });
}

final validateAttendanceProvider = StateNotifierProvider.family<
    ValidateAttendanceNotifier, ValidateAttendanceState, String>(
  (ref, quedadaId) => ValidateAttendanceNotifier(),
);

class ValidateAttendanceNotifier extends StateNotifier<ValidateAttendanceState> {
  ValidateAttendanceNotifier() : super(const ValidateAttendanceState());

  Future<void> validate({
    required String quedadaId,
    required String usuariId,
    required double latitud,
    required double longitud,
  }) async {
    state = const ValidateAttendanceState(
      status: ValidateAttendanceStatus.loading,
    );

    try {
      final dataSource = ValidationRemoteDataSource(http.Client());
      await dataSource.validateAttendance(
        quedadaId: quedadaId,
        usuariId: usuariId,
        latitud: latitud,
        longitud: longitud,
      );
      state = const ValidateAttendanceState(
        status: ValidateAttendanceStatus.validated,
      );
    } catch (e) {
      state = ValidateAttendanceState(
        status: ValidateAttendanceStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
