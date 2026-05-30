import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/features/groups/presentation/screens/group_form_screen.dart';
import 'package:plan_c_frontend/features/activitats/model/activitat.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';
// Añadimos el import de las traducciones
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

void main() {
  final now = DateTime.now();
  final testActivitat = Activitat(
    id: 'test-id',
    titol: 'Test Activity',
    descripcio: 'Test Description',
    categoria: 'Sport',
    nomEspai: 'Test Space',
    lat: 41.3851,
    lng: 2.1734,
    dataInici: now,
    dataFi: now.add(const Duration(hours: 2)),
    urlEntrades: 'https://example.com',
    adreca: '',
    localitat: '',
  );

  final testGroup = Group(
    id: '1',
    title: 'Test Group',
    description: 'Test Description',
    minParticipants: 2,
    maxParticipants: 5,
    currentParticipants: 1,
    participantIds: const ['user-1'],
    dateTime: DateTime.parse('2026-04-01T18:00:00.000Z'),
    activityId: 'activity-1',
    creatorId: 'user-1',
    createdAt: DateTime.parse('2026-03-31T12:00:00.000Z'),
  );

  group('GroupFormScreen - Create mode', () {
    testWidgets('renders correctly in create mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ca'),
            home: GroupFormScreen(
              activityId: 'activity-id-test',
              activitat: testActivitat,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(GroupFormScreen), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows create title in create mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ca'),
            home: GroupFormScreen(
              activityId: 'activity-id-test',
              activitat: testActivitat,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Crear Quedada'), findsOneWidget);
      expect(find.text('CREAR GRUP'), findsOneWidget);
    });

    testWidgets('submit button is disabled when form is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ca'),
            home: GroupFormScreen(
              activityId: 'activity-id-test',
              activitat: testActivitat,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });

  group('GroupFormScreen - Edit mode', () {
    testWidgets('renders correctly in edit mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ca'),
            home: GroupFormScreen(
              activityId: testGroup.activityId,
              activitat: testActivitat,
              groupToEdit: testGroup,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(GroupFormScreen), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows edit title in edit mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ca'),
            home: GroupFormScreen(
              activityId: testGroup.activityId,
              activitat: testActivitat,
              groupToEdit: testGroup,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Editar Quedada'), findsOneWidget);
      expect(find.text('GUARDAR CANVIS'), findsOneWidget);
    });

    testWidgets('pre-fills fields with group data in edit mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('ca'),
            home: GroupFormScreen(
              activityId: testGroup.activityId,
              activitat: testActivitat,
              groupToEdit: testGroup,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Group'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });
  });
}