import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plan_c_frontend/features/groups/domain/models/group.dart';
import 'package:plan_c_frontend/features/groups/presentation/providers/validate_attendance_provider.dart';
import 'package:plan_c_frontend/features/groups/presentation/widgets/validate_attendance_button.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class _StubNotifier extends ValidateAttendanceNotifier {
  _StubNotifier(ValidateAttendanceState initial) {
    state = initial;
  }
}

Group _buildGroup({DateTime? meetTime}) {
  final dt = meetTime ?? DateTime.now().add(const Duration(minutes: 5));
  return Group(
    id: 'q1',
    title: 'Test',
    description: 'desc',
    minParticipants: 1,
    maxParticipants: 5,
    currentParticipants: 1,
    participantIds: const ['u1'],
    dateTime: dt,
    activityId: 'a1',
    creatorId: 'u1',
    createdAt: DateTime.now(),
  );
}

Widget _wrap({
  required Group group,
  required ValidateAttendanceState initialState,
  required bool isAttendanceConfirmed,
  required bool isAttendanceValidated,
  DateTime? trobada,
  DateTime? fi,
}) {
  final now = DateTime.now();
  return ProviderScope(
    overrides: [
      validateAttendanceProvider(group.id).overrideWith(
        (ref) => _StubNotifier(initialState),
      ),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ca'),
      home: Scaffold(
        body: ValidateAttendanceButton(
          group: group,
          currentUserId: 'u1',
          isAttendanceConfirmed: isAttendanceConfirmed,
          isAttendanceValidated: isAttendanceValidated,
          dataHoraTrobada: trobada ?? now.add(const Duration(minutes: 5)),
          dataFiActivitat: fi ?? now.add(const Duration(hours: 2)),
        ),
      ),
    ),
  );
}

void main() {
  group('ValidateAttendanceButton', () {
    testWidgets('no es renderitza si l\'assistència no està confirmada',
        (tester) async {
      final group = _buildGroup();
      await tester.pumpWidget(_wrap(
        group: group,
        initialState: const ValidateAttendanceState(),
        isAttendanceConfirmed: false,
        isAttendanceValidated: false,
      ));

      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.text('Validar assistència'), findsNothing);
    });

    testWidgets('no es renderitza si ja està validada', (tester) async {
      final group = _buildGroup();
      await tester.pumpWidget(_wrap(
        group: group,
        initialState: const ValidateAttendanceState(),
        isAttendanceConfirmed: true,
        isAttendanceValidated: true,
      ));

      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('mostra el botó "Validar assistència" dins de la finestra',
        (tester) async {
      final group = _buildGroup();
      await tester.pumpWidget(_wrap(
        group: group,
        initialState: const ValidateAttendanceState(),
        isAttendanceConfirmed: true,
        isAttendanceValidated: false,
      ));

      expect(find.text('Validar assistència'), findsOneWidget);
    });

    testWidgets('mostra el botó actiu fins i tot fora de la finestra horària',
        (tester) async {
      final group = _buildGroup();
      final now = DateTime.now();
      await tester.pumpWidget(_wrap(
        group: group,
        initialState: const ValidateAttendanceState(),
        isAttendanceConfirmed: true,
        isAttendanceValidated: false,
        trobada: now.add(const Duration(hours: 5)),
        fi: now.add(const Duration(hours: 7)),
      ));

      // El botó sempre es mostra actiu
      expect(find.text('Validar assistència'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // No hi ha text estàtic de "Fora del període"
      expect(find.text('Fora del període de l\'activitat'), findsNothing);
    });

    testWidgets('mostra spinner quan està en loading', (tester) async {
      final group = _buildGroup();
      await tester.pumpWidget(_wrap(
        group: group,
        initialState: const ValidateAttendanceState(
          status: ValidateAttendanceStatus.loading,
        ),
        isAttendanceConfirmed: true,
        isAttendanceValidated: false,
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('mostra "Assistència validada ✓" quan està validated',
        (tester) async {
      final group = _buildGroup();
      await tester.pumpWidget(_wrap(
        group: group,
        initialState: const ValidateAttendanceState(
          status: ValidateAttendanceStatus.validated,
        ),
        isAttendanceConfirmed: true,
        isAttendanceValidated: false,
      ));

      expect(find.text('Assistència validada ✓'), findsOneWidget);
    });

    testWidgets(
      'mostra missatge en vermell amb 200m quan error és "distance:"',
      (tester) async {
        final group = _buildGroup();
        await tester.pumpWidget(_wrap(
          group: group,
          initialState: const ValidateAttendanceState(
            status: ValidateAttendanceStatus.error,
            errorMessage: 'Exception: distance:543',
          ),
          isAttendanceConfirmed: true,
          isAttendanceValidated: false,
        ));

        final textFinder = find.textContaining('massa lluny');
        expect(textFinder, findsOneWidget);
        expect(find.textContaining('543 metres'), findsOneWidget);
        expect(find.textContaining('200 metres'), findsOneWidget);

        final Text textWidget = tester.widget<Text>(textFinder);
        final expectedColor = ThemeData().colorScheme.error;
        expect(textWidget.style?.color, expectedColor);
      },
    );

    testWidgets(
      'mostra missatge en vermell amb 200m quan error conté "lluny"',
      (tester) async {
        final group = _buildGroup();
        await tester.pumpWidget(_wrap(
          group: group,
          initialState: const ValidateAttendanceState(
            status: ValidateAttendanceStatus.error,
            errorMessage: 'Exception: Ets massa lluny de l\'activitat',
          ),
          isAttendanceConfirmed: true,
          isAttendanceValidated: false,
        ));

        final textFinder = find.textContaining('massa lluny');
        expect(textFinder, findsOneWidget);
        expect(find.textContaining('200 metres'), findsOneWidget);

        final Text textWidget = tester.widget<Text>(textFinder);
        final expectedColor = ThemeData().colorScheme.error;
        expect(textWidget.style?.color, expectedColor);
      },
    );

    testWidgets(
      'no es mostra cap SnackBar quan l\'error és de distància',
      (tester) async {
        final group = _buildGroup();
        await tester.pumpWidget(_wrap(
          group: group,
          initialState: const ValidateAttendanceState(
            status: ValidateAttendanceStatus.error,
            errorMessage: 'Exception: distance:543',
          ),
          isAttendanceConfirmed: true,
          isAttendanceValidated: false,
        ));
        await tester.pump();

        expect(find.byType(SnackBar), findsNothing);
      },
    );

    testWidgets(
      'mostra error genèric en vermell quan no és de distància',
      (tester) async {
        final group = _buildGroup();
        await tester.pumpWidget(_wrap(
          group: group,
          initialState: const ValidateAttendanceState(
            status: ValidateAttendanceStatus.error,
            errorMessage: 'Exception: Error inesperat',
          ),
          isAttendanceConfirmed: true,
          isAttendanceValidated: false,
        ));

        final textFinder = find.text('Error inesperat');
        expect(textFinder, findsOneWidget);

        final Text textWidget = tester.widget<Text>(textFinder);
        final expectedColor = ThemeData().colorScheme.error;
        expect(textWidget.style?.color, expectedColor);
      },
    );
  });
}