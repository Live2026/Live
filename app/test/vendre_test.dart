import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/core/router.dart';
import 'package:live/main.dart';

import 'outils.dart';

void main() {
  setUpAll(chargerPolices);
  testWidgets('vendre un produit : 6 étapes jusqu’à Félicitations', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    sansAnimations(tester);
    routeur.go('/vendre');
    await tester.pumpWidget(const ProviderScope(child: LiveApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Téléphones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajouter une photo'));
    await tester.pumpAndSettle();
    expect(find.text('Couverture'), findsOneWidget);
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Samsung A10');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '30000');
    await tester.pumpAndSettle();
    expect(find.text('Vous recevez'), findsOneWidget);
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    expect(find.text('Publier'), findsOneWidget);
    await tester.tap(find.textContaining('Je certifie'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Publier'));
    await tester.pumpAndSettle();
    expect(find.text('Félicitations !'), findsOneWidget);
  });

  testWidgets('un numéro de téléphone dans le titre est refusé (R-MKT-02)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    sansAnimations(tester);
    routeur.go('/vendre');
    await tester.pumpWidget(const ProviderScope(child: LiveApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mode'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajouter une photo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).first,
      'Robe appelez 06 123 45 67',
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Retirez le numéro'), findsOneWidget);
  });
}
