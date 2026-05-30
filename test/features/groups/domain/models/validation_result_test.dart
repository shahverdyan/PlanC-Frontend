import 'package:flutter_test/flutter_test.dart';
import 'package:plan_c_frontend/features/groups/domain/models/validation_result.dart';

void main() {
  group('ValidationResult model', () {
    test('crea ValidationResult amb constructor', () {
      const result = ValidationResult(
        estat: 'VALIDADA',
        distancia: 42.5,
        success: true,
      );

      expect(result.estat, 'VALIDADA');
      expect(result.distancia, 42.5);
      expect(result.success, isTrue);
    });

    test('fromJson parseja correctament tots els camps', () {
      final json = {
        'estat': 'VALIDADA',
        'distancia': 123.4,
        'success': true,
      };

      final result = ValidationResult.fromJson(json);

      expect(result.estat, 'VALIDADA');
      expect(result.distancia, 123.4);
      expect(result.success, isTrue);
    });

    test('fromJson aplica valors per defecte si falten camps', () {
      final result = ValidationResult.fromJson(<String, dynamic>{});

      expect(result.estat, '');
      expect(result.distancia, 0.0);
      expect(result.success, isTrue);
    });

    test('fromJson converteix distancia int a double', () {
      final json = {
        'estat': 'VALIDADA',
        'distancia': 50,
        'success': true,
      };

      final result = ValidationResult.fromJson(json);

      expect(result.distancia, isA<double>());
      expect(result.distancia, 50.0);
    });

    test('fromJson tracta success=false', () {
      final json = {
        'estat': 'NO_VALIDADA',
        'distancia': 500,
        'success': false,
      };

      final result = ValidationResult.fromJson(json);

      expect(result.success, isFalse);
      expect(result.estat, 'NO_VALIDADA');
    });
  });
}
