import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/core/router.dart';
import 'package:live/main.dart';

import 'outils.dart';

void main() {
  setUpAll(chargerPolices);

  Future<void> ouvrir(WidgetTester tester, String route) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    sansAnimations(tester);
    routeur.go('/messages');
    await tester.pumpWidget(const ProviderScope(child: LiveApp()));
    await tester.pumpAndSettle();
    routeur.push(route);
    await tester.pumpAndSettle();
  }

  testWidgets('appel vidéo : sonnerie, décroché, micro coupé, raccrocher', (
    tester,
  ) async {
    await ouvrir(tester, '/appel?avec=Gr%C3%A2ce%20Mode&video=1');
    expect(find.text('Sonnerie…'), findsOneWidget);
    expect(find.text('Chiffré de bout en bout'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Sonnerie…'), findsNothing);
    expect(find.text('Vous'), findsOneWidget); // ma vignette

    await tester.tap(find.bySemanticsLabel('Micro'));
    await tester.pump();
    expect(
      tester.getSemantics(find.bySemanticsLabel('Micro')),
      matchesSemantics(
        label: 'Micro',
        isButton: true,
        hasToggledState: true,
        isToggled: true,
      ),
    );

    // Le réseau faiblit : on passe en audio.
    await tester.pump(const Duration(seconds: 6));
    expect(find.text('Passer en audio'), findsOneWidget);
    await tester.tap(find.text('Passer en audio'));
    await tester.pump();
    expect(find.text('Vous'), findsNothing);

    await tester.tap(find.bySemanticsLabel('Raccrocher'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Appel terminé'), findsOneWidget);
  });

  testWidgets('appel reçu : accepter, puis appel en groupe avec un invité', (
    tester,
  ) async {
    await ouvrir(tester, '/appel?avec=Gr%C3%A2ce%20Mode&video=1&entrant=1');
    expect(find.text('Appel vidéo Live entrant'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Accepter'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('0:02'), findsNothing); // minuteur dans l'en-tête
    expect(find.textContaining('Grâce Mode · 0:02'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Ajouter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Merveille'));
    await tester.pumpAndSettle();
    expect(find.text('Merveille'), findsOneWidget); // tuile de la grille
    expect(find.text('Vous'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Raccrocher'));
    await tester.pumpAndSettle();
  });

  testWidgets('historique des appels et appel depuis une conversation', (
    tester,
  ) async {
    await ouvrir(tester, '/appels');
    expect(find.text('Agence Les Palmiers'), findsOneWidget);
    await tester.tap(find.text('Manqués'));
    await tester.pumpAndSettle();
    expect(find.text('Maman'), findsNothing);

    routeur.go('/conversation');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Appel audio'));
    await tester.pumpAndSettle();
    expect(find.text('Sonnerie…'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Raccrocher'));
    await tester.pumpAndSettle();
  });
}
