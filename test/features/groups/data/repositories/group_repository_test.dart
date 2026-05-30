import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plan_c_frontend/features/groups/data/repositories/group_repository_impl.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late GroupRepositoryImpl repository;

  setUp(() {
    mockDio = MockDio();
    repository = GroupRepositoryImpl(mockDio);
  });

  test('getGroupsByActivity returns parsed groups', () async {
    when(() => mockDio.get(any())).thenAnswer(
          (_) async => Response(
        requestOptions: RequestOptions(path: ''),
        data: [
          {
            'id': '1',
            'titol': 'Test Group',
            'descripcio': 'Test Description',
            'minimParticipants': 2,
            'maximParticipants': 5,
            'dataHoraTrobada': '2026-04-01T18:00:00.000Z',
            'activitatId': 'activity-1',
            'createdAt': '2026-03-31T12:00:00.000Z',
            'assistents': [
              {
                'usuariId': 'user-1',
                'rol': 'ADMINISTRADOR',
              },
            ],
          }
        ],
        statusCode: 200,
      ),
    );

    final result = await repository.getGroupsByActivity('activity-1');

    expect(result.length, 1);
    expect(result.first.title, 'Test Group');
    expect(result.first.creatorId, 'user-1');
  });
}