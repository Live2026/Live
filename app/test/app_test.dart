import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/main.dart';

import 'outils.dart';

void main() {
  testWidgets("l'accueil s'ouvre et mène au fil", (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    sansAnimations(tester);

    await tester.pumpWidget(const ProviderScope(child: LiveApp()));
    await tester.pump();
    // Écran d'ouverture, puis la bienvenue.
    expect(find.text('La place de marché sociale'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('PROTOTYPE · aucune transaction réelle'), findsOneWidget);
    expect(find.text('Commencer'), findsOneWidget);

    await tester.ensureVisible(find.text('Découvrir sans compte'));
    await tester.tap(find.text('Découvrir sans compte'));
    await tester.pumpAndSettle();
    expect(find.text('Pour toi'), findsOneWidget);
    expect(find.text('Explorer'), findsOneWidget);
  });
}
