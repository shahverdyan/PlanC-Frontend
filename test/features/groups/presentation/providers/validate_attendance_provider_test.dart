import 'package:flutter_test/flutter_test.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/validate_attendance_provider.dart';

void main() {
  group('ValidateAttendanceState', () {
    test('estat per defecte és idle i sense errorMessage', () {
      const state = ValidateAttendanceState();

      expect(state.status, ValidateAttendanceStatus.idle);
      expect(state.errorMessage, isNull);
    });

    test('crea estat amb status loading', () {
      const state = ValidateAttendanceState(
        status: ValidateAttendanceStatus.loading,
      );

      expect(state.status, ValidateAttendanceStatus.loading);
      expect(state.errorMessage, isNull);
    });

    test('crea estat validated', () {
      const state = ValidateAttendanceState(
        status: ValidateAttendanceStatus.validated,
      );

      expect(state.status, ValidateAttendanceStatus.validated);
    });

    test('crea estat error amb missatge', () {
      const state = ValidateAttendanceState(
        status: ValidateAttendanceStatus.error,
        errorMessage: 'Exception: distance:543',
      );

      expect(state.status, ValidateAttendanceStatus.error);
      expect(state.errorMessage, 'Exception: distance:543');
    });
  });

  group('ValidateAttendanceNotifier', () {
    test('estat inicial del notifier és idle', () {
      final notifier = ValidateAttendanceNotifier();

      expect(notifier.state.status, ValidateAttendanceStatus.idle);
      expect(notifier.state.errorMessage, isNull);

      notifier.dispose();
    });
  });
}
