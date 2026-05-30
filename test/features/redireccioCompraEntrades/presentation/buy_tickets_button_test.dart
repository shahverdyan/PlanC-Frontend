import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plan_c_frontend/features/redireccioCompraEntrades/presentation/widgets/buy_tickets_button.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

void main() {
  group('BuyTicketsButton', () {
    testWidgets('mostra enllaç no disponible si la URL és buida i no és gratuïta',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ca'),
            home: Scaffold(
              body: BuyTicketsButton(url: '', preu: 10.0),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Enllaç no disponible'), findsOneWidget);
      expect(find.text('Entrada gratuïta, no cal inscripció'), findsNothing);
    });

    testWidgets("mostra missatge gratuït si l'activitat és gratuïta",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ca'),
            home: Scaffold(
              body: BuyTicketsButton(
                url: '',
                preu: 0,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Entrada gratuïta, no cal inscripció'), findsOneWidget);
      expect(find.text('Enllaç no disponible'), findsNothing);
    });

    testWidgets('mostra botó "Comprar entrades" si la URL és vàlida',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('ca'),
            home: Scaffold(
              body: BuyTicketsButton(
                url: 'https://entrades.exemple.cat/concert',
                preu: 15.0,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Comprar entrades'), findsOneWidget);
      expect(find.text('Entrada gratuïta, no cal inscripció'), findsNothing);
      expect(find.text('Enllaç no disponible'), findsNothing);
    });
  });
}