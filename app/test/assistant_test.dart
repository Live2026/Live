import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/core/router.dart';
import 'package:live/data/store.dart';
import 'package:live/main.dart';

import 'outils.dart';

void main() {
  testWidgets('assistant : un fichier joint se lit après accord sur le prix', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    sansAnimations(tester);
    routeur.go('/ia/assistant');
    final c = ProviderContainer();
    addTearDown(c.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: c, child: const LiveApp()),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('que puis-je faire pour vous'), findsOneWidget);

    await tester.tap(find.byTooltip('Joindre un fichier'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fichier'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contrat_bail_Moungali.pdf'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Envoyer'));
    await tester.pumpAndSettle();

    final avant = c.read(liveProvider).credits;
    expect(find.text('Lire pour 5 crédits'), findsOneWidget);
    await tester.tap(find.text('Lire pour 5 crédits'));
    await tester.pumpAndSettle();
    expect(c.read(liveProvider).credits, avant - 5);
    expect(find.textContaining('contrat de bail'), findsOneWidget);
  });

  testWidgets(
    'assistant : une demande écrite reçoit une réponse et des actions',
    (tester) async {
      tester.view.physicalSize = const Size(400, 860);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      sansAnimations(tester);
      routeur.go('/ia/assistant');
      await tester.pumpWidget(const ProviderScope(child: LiveApp()));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField),
        'Un plombier demain matin',
      );
      await tester.pump();
      await tester.tap(find.byTooltip('Envoyer'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Serge, plombier vérifié'), findsOneWidget);
      expect(find.text('Réserver Serge demain 8 h'), findsOneWidget);
    },
  );
}
