import 'package:flutter_test/flutter_test.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';

void main() {
  group('Group model', () {
    test('should create a Group correctly', () {
      final group = Group(
        id: '1',
        title: 'Test Group',
        description: 'Test Description',
        minParticipants: 2,
        maxParticipants: 5,
        currentParticipants: 1,
        participantIds: const [],
        dateTime: DateTime.parse('2026-04-01T18:00:00.000Z'),
        activityId: 'activity-1',
        creatorId: 'user-1',
        createdAt: DateTime.parse('2026-03-31T12:00:00.000Z'),
      );

      expect(group.id, '1');
      expect(group.title, 'Test Group');
      expect(group.description, 'Test Description');
      expect(group.minParticipants, 2);
      expect(group.maxParticipants, 5);
      expect(group.currentParticipants, 1);
      expect(group.participantIds, isEmpty);
      expect(group.activityId, 'activity-1');
      expect(group.creatorId, 'user-1');
    });

    test('should parse fromJson correctly', () {
      final json = {
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
          {
            'usuariId': 'user-2',
            'rol': 'MEMBRE',
          },
        ],
      };

      final group = Group.fromJson(json);

      expect(group.id, '1');
      expect(group.title, 'Test Group');
      expect(group.description, 'Test Description');
      expect(group.minParticipants, 2);
      expect(group.maxParticipants, 5);
      expect(group.currentParticipants, 2);
      expect(group.participantIds, ['user-1', 'user-2']);
      expect(group.activityId, 'activity-1');
      expect(group.creatorId, 'user-1');
    });
  });
}