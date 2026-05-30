import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plan_c_frontend/features/cercador/presentation/widgets/empty_search_state.dart';
import 'package:plan_c_frontend/features/cercador/domain/entities/search_result.dart';

// ============================================================
// Helper per wrapping widgets en tests
// ============================================================
Widget _wrapWithMaterial(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('ca'), Locale('es'), Locale('en')],
    home: Scaffold(body: child),
  );
}

// ============================================================
// TESTS
// ============================================================
void main() {
  // ==================== EmptySearchState (mode search) ====================

  group('EmptySearchState - search mode', () {
    testWidgets('should show search_off icon', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          const EmptySearchState(
            terme: 'xyz',
            type: EmptyResultType.search,
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('should show "no match" message', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          const EmptySearchState(
            terme: 'opera',
            type: EmptyResultType.search,
          ),
        ),
      );

      expect(find.text('No s\'ha trobat cap coincidència'), findsOneWidget);
    });

    testWidgets('should include search term in message', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          const EmptySearchState(
            terme: 'opera',
            type: EmptyResultType.search,
          ),
        ),
      );

      expect(find.textContaining('opera'), findsOneWidget);
    });

    testWidgets('should show category chips', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          const EmptySearchState(
            terme: 'test',
            type: EmptyResultType.search,
          ),
        ),
      );

      expect(find.text('Música'), findsOneWidget);
      expect(find.text('Teatre'), findsOneWidget);
      expect(find.text('Art'), findsOneWidget);
      expect(find.text('Cinema'), findsOneWidget);
    });

    testWidgets('should not show "Modificar filtres" button', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          const EmptySearchState(
            terme: 'test',
            type: EmptyResultType.search,
          ),
        ),
      );

      expect(find.text('Modificar filtres'), findsNothing);
    });

    testWidgets('should not show filter_alt_off icon', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          const EmptySearchState(
            terme: 'test',
            type: EmptyResultType.search,
          ),
        ),
      );

      expect(find.byIcon(Icons.filter_alt_off), findsNothing);
    });
  });

  // ==================== EmptySearchState (mode filter) ====================

  group('EmptySearchState - filter mode', () {
    testWidgets('should show filter_alt_off icon', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          EmptySearchState(
            type: EmptyResultType.filter,
            onModifyFilters: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.filter_alt_off), findsOneWidget);
    });

    testWidgets('should not show search_off icon', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          EmptySearchState(
            type: EmptyResultType.filter,
            onModifyFilters: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.search_off), findsNothing);
    });

    testWidgets('should show filter-specific title', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          EmptySearchState(
            type: EmptyResultType.filter,
            onModifyFilters: () {},
          ),
        ),
      );

      expect(
        find.text('Cap activitat coincideix amb els filtres'),
        findsOneWidget,
      );
    });

    testWidgets('should show suggestion to modify filters', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          EmptySearchState(
            type: EmptyResultType.filter,
            onModifyFilters: () {},
          ),
        ),
      );

      expect(find.textContaining('ampliar la distància'), findsOneWidget);
    });

    testWidgets('should show "Modificar filtres" button', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          EmptySearchState(
            type: EmptyResultType.filter,
            onModifyFilters: () {},
          ),
        ),
      );

      expect(find.text('Modificar filtres'), findsOneWidget);
    });

    testWidgets('should call onModifyFilters when button tapped',
        (tester) async {
      bool called = false;

      await tester.pumpWidget(
        _wrapWithMaterial(
          EmptySearchState(
            type: EmptyResultType.filter,
            onModifyFilters: () => called = true,
          ),
        ),
      );

      await tester.tap(find.text('Modificar filtres'));
      await tester.pump();

      expect(called, isTrue);
    });

    testWidgets('should not show category chips in filter mode',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          EmptySearchState(
            type: EmptyResultType.filter,
            onModifyFilters: () {},
          ),
        ),
      );

      expect(find.text('Música'), findsNothing);
      expect(find.text('Teatre'), findsNothing);
      expect(find.text('Art'), findsNothing);
      expect(find.text('Cinema'), findsNothing);
    });

    testWidgets('should not show button if onModifyFilters is null',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(
          const EmptySearchState(
            type: EmptyResultType.filter,
          ),
        ),
      );

      expect(find.text('Modificar filtres'), findsNothing);
    });
  });

  // ==================== Entity parsing ====================

  group('ActivitySearchResult.fromJson', () {
    test('should parse all fields including preu', () {
      final json = {
        'id': 'act-1',
        'titol': 'Concert de Jazz',
        'espai': {'nom': 'Palau'},
        'imatgeUrl': 'https://example.com/img.jpg',
        'preu': 15.5,
      };

      final result = ActivitySearchResult.fromJson(json);

      expect(result.id, 'act-1');
      expect(result.titol, 'Concert de Jazz');
      expect(result.espaiNom, 'Palau');
      expect(result.imatgeUrl, 'https://example.com/img.jpg');
      expect(result.preu, 15.5);
    });

    test('should handle null preu', () {
      final json = {
        'id': 'act-2',
        'titol': 'Exposició',
        'preu': null,
      };

      final result = ActivitySearchResult.fromJson(json);

      expect(result.preu, isNull);
    });

    test('should handle null espai', () {
      final json = {
        'id': 'act-3',
        'titol': 'Festival',
      };

      final result = ActivitySearchResult.fromJson(json);

      expect(result.espaiNom, isNull);
    });

    test('should parse integer preu as double', () {
      final json = {
        'id': 'act-4',
        'titol': 'Teatre',
        'preu': 10,
      };

      final result = ActivitySearchResult.fromJson(json);

      expect(result.preu, 10.0);
      expect(result.preu, isA<double>());
    });
  });

  group('SpaceSearchResult.fromJson', () {
    test('should parse all fields', () {
      final json = {
        'id': 'esp-1',
        'nom': 'MACBA',
        'imatgeUrl': 'https://example.com/macba.jpg',
      };

      final result = SpaceSearchResult.fromJson(json);

      expect(result.id, 'esp-1');
      expect(result.nom, 'MACBA');
      expect(result.imatgeUrl, 'https://example.com/macba.jpg');
    });

    test('should handle null imatgeUrl', () {
      final json = {
        'id': 'esp-2',
        'nom': 'Biblioteca',
      };

      final result = SpaceSearchResult.fromJson(json);

      expect(result.imatgeUrl, isNull);
    });
  });

  group('SearchResults', () {
    test('isEmpty should return true when no results', () {
      const results = SearchResults();

      expect(results.isEmpty, isTrue);
    });

    test('isEmpty should return false when has activitats', () {
      const results = SearchResults(
        activitats: [ActivitySearchResult(id: '1', titol: 'Test')],
      );

      expect(results.isEmpty, isFalse);
    });

    test('isEmpty should return false when has espais', () {
      const results = SearchResults(
        espais: [SpaceSearchResult(id: '1', nom: 'Test')],
      );

      expect(results.isEmpty, isFalse);
    });

    test('empty factory should create empty results', () {
      final results = SearchResults.empty();

      expect(results.isEmpty, isTrue);
      expect(results.activitats, isEmpty);
      expect(results.espais, isEmpty);
    });
  });
}