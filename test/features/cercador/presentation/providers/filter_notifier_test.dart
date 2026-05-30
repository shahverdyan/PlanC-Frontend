import 'package:flutter_test/flutter_test.dart';
import 'package:plan_c_frontend/features/cercador/presentation/providers/filter_provider.dart';

void main() {
  group('FilterState', () {
    test('should have default values', () {
      const state = FilterState();
 
      expect(state.dataInici, isNull);
      expect(state.dataFi, isNull);
      expect(state.gratuit, isNull);
      expect(state.preuMax, isNull);
      expect(state.radiKm, isNull);
      expect(state.categories, isEmpty);
    });
 
    test('teFiltresActius returns false when no filters set', () {
      const state = FilterState();
      expect(state.teFiltresActius, isFalse);
    });
 
    test('teFiltresActius returns true when gratuit is set', () {
      const state = FilterState(gratuit: true);
      expect(state.teFiltresActius, isTrue);
    });
 
    test('teFiltresActius returns true when dataInici is set', () {
      const state = FilterState(dataInici: '2026-04-01');
      expect(state.teFiltresActius, isTrue);
    });
 
    test('teFiltresActius returns true when categories are set', () {
      const state = FilterState(categories: ['cat-1']);
      expect(state.teFiltresActius, isTrue);
    });
 
    test('teFiltresActius returns true when radiKm is set', () {
      const state = FilterState(radiKm: 25);
      expect(state.teFiltresActius, isTrue);
    });
  });
 
  group('FilterState.copyWith', () {
    test('should update gratuit', () {
      const original = FilterState();
      final updated = original.copyWith(gratuit: true);
 
      expect(updated.gratuit, isTrue);
      expect(updated.dataInici, isNull);
    });
 
    test('should update dataInici and dataFi', () {
      const original = FilterState();
      final updated = original.copyWith(
        dataInici: '2026-04-01',
        dataFi: '2026-04-15',
      );
 
      expect(updated.dataInici, '2026-04-01');
      expect(updated.dataFi, '2026-04-15');
    });
 
    test('should clear dates when clearDates is true', () {
      const original = FilterState(
        dataInici: '2026-04-01',
        dataFi: '2026-04-15',
      );
      final updated = original.copyWith(clearDates: true);
 
      expect(updated.dataInici, isNull);
      expect(updated.dataFi, isNull);
    });
 
    test('should clear gratuit when clearGratuit is true', () {
      const original = FilterState(gratuit: true);
      final updated = original.copyWith(clearGratuit: true);
 
      expect(updated.gratuit, isNull);
    });
 
    test('should clear preuMax when clearPreuMax is true', () {
      const original = FilterState(preuMax: 20.0);
      final updated = original.copyWith(clearPreuMax: true);
 
      expect(updated.preuMax, isNull);
    });
 
    test('should update categories', () {
      const original = FilterState();
      final updated = original.copyWith(categories: ['cat-1', 'cat-2']);
 
      expect(updated.categories, ['cat-1', 'cat-2']);
    });
 
    test('should preserve other fields when updating one', () {
      const original = FilterState(
        gratuit: true,
        radiKm: 15,
        dataInici: '2026-04-01',
      );
      final updated = original.copyWith(preuMax: 25.0);
 
      expect(updated.gratuit, isTrue);
      expect(updated.radiKm, 15);
      expect(updated.dataInici, '2026-04-01');
      expect(updated.preuMax, 25.0);
    });
  });
 
  group('FilterState.netejar', () {
    test('should reset all filters to default', () {
      const state = FilterState(
        dataInici: '2026-04-01',
        dataFi: '2026-04-15',
        gratuit: true,
        preuMax: 50.0,
        radiKm: 25,
        categories: ['cat-1'],
      );
      final cleaned = state.netejar();
 
      expect(cleaned.dataInici, isNull);
      expect(cleaned.dataFi, isNull);
      expect(cleaned.gratuit, isNull);
      expect(cleaned.preuMax, isNull);
      expect(cleaned.radiKm, isNull);
      expect(cleaned.categories, isEmpty);
      expect(cleaned.teFiltresActius, isFalse);
    });
  });
}
