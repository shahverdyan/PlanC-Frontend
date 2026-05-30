import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:plan_c_frontend/features/groups/data/datasources/validation_remote_data_source.dart';
import 'package:plan_c_frontend/features/groups/domain/models/validation_result.dart';

void main() {
  group('ValidationRemoteDataSource.validateAttendance', () {
    test('retorna ValidationResult quan la resposta és 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'POST');
        expect(
          request.url.toString(),
          contains('activitats/quedades/q1/validar-assistencia'),
        );
        expect(request.headers['Content-Type'], 'application/json');
        expect(request.headers['usuari-id'], 'u1');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['usuariId'], 'u1');
        expect(body['latitud'], 41.0);
        expect(body['longitud'], 2.0);

        return http.Response(
          jsonEncode({'estat': 'VALIDADA', 'distancia': 12.0, 'success': true}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final dataSource = ValidationRemoteDataSource(mockClient);

      final result = await dataSource.validateAttendance(
        quedadaId: 'q1',
        usuariId: 'u1',
        latitud: 41.0,
        longitud: 2.0,
      );

      expect(result, isA<ValidationResult>());
      expect(result.estat, 'VALIDADA');
      expect(result.distancia, 12.0);
      expect(result.success, isTrue);
    });

    test('retorna ValidationResult quan la resposta és 201', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'estat': 'VALIDADA', 'distancia': 5.0, 'success': true}),
          201,
        );
      });

      final dataSource = ValidationRemoteDataSource(mockClient);

      final result = await dataSource.validateAttendance(
        quedadaId: 'q1',
        usuariId: 'u1',
        latitud: 0,
        longitud: 0,
      );

      expect(result.estat, 'VALIDADA');
      expect(result.distancia, 5.0);
    });

    test(
      'llença Exception amb prefix "distance:" quan 400 inclou distancia',
      () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            jsonEncode({
              'message': 'Massa lluny',
              'distancia': 543.7,
            }),
            400,
          );
        });

        final dataSource = ValidationRemoteDataSource(mockClient);

        expect(
          () => dataSource.validateAttendance(
            quedadaId: 'q1',
            usuariId: 'u1',
            latitud: 41.0,
            longitud: 2.0,
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('distance:544'),
            ),
          ),
        );
      },
    );

    test(
      'llença Exception amb el missatge del back quan 400 sense distancia',
      () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            jsonEncode({'message': 'Ets massa lluny de l\'activitat'}),
            400,
          );
        });

        final dataSource = ValidationRemoteDataSource(mockClient);

        expect(
          () => dataSource.validateAttendance(
            quedadaId: 'q1',
            usuariId: 'u1',
            latitud: 41.0,
            longitud: 2.0,
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Ets massa lluny de l\'activitat'),
            ),
          ),
        );
      },
    );

    test(
      'llença Exception genèric quan 400 amb cos no JSON',
      () async {
        final mockClient = MockClient((request) async {
          return http.Response('no es json', 400);
        });

        final dataSource = ValidationRemoteDataSource(mockClient);

        expect(
          () => dataSource.validateAttendance(
            quedadaId: 'q1',
            usuariId: 'u1',
            latitud: 0,
            longitud: 0,
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Ets fora del rang'),
            ),
          ),
        );
      },
    );

    test('llença Exception amb el codi quan status no és 200/201/400', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal error', 500);
      });

      final dataSource = ValidationRemoteDataSource(mockClient);

      expect(
        () => dataSource.validateAttendance(
          quedadaId: 'q1',
          usuariId: 'u1',
          latitud: 0,
          longitud: 0,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('500'),
          ),
        ),
      );
    });
  });
}
