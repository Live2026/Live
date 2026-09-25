import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/core/router.dart';
import 'package:live/main.dart';

import 'outils.dart';

Future<void> _ouvrir(WidgetTester tester, String route) async {
  tester.view.physicalSize = const Size(1280, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  sansAnimations(tester);
  routeur.go(route);
  await tester.pumpWidget(const ProviderScope(child: LiveApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('quatre yeux : on ne valide pas sa propre demande', (
    tester,
  ) async {
    await _ouvrir(tester, '/admin/validations');
    // Trois demandes, dont celle de la direction générale elle-même.
    expect(find.text('Valider'), findsNWidgets(2));
    expect(
      find.text('Votre demande : un autre administrateur doit la valider.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Refuser').first);
    await tester.pumpAndSettle();
    expect(find.text('Refusée'), findsOneWidget);
    expect(find.text('Valider'), findsOneWidget);
  });

  testWidgets('connexion des agents : mot de passe puis code 2FA', (
    tester,
  ) async {
    await _ouvrir(tester, '/admin/connexion');
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    expect(
      find.text('Code de votre application d’authentification'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text('Tableau de bord'), findsWidgets);
  });
}
