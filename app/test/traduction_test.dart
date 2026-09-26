import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/core/router.dart';
import 'package:live/data/store.dart';
import 'package:live/main.dart';

import 'outils.dart';

void main() {
  testWidgets('en anglais, le démarrage et la navigation sont traduits', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    sansAnimations(tester);
    routeur.go('/bienvenue');
    await tester.pumpWidget(const ProviderScope(child: LiveApp()));
    await tester.pumpAndSettle();
    expect(find.text('Commencer'), findsOneWidget);

    ProviderScope.containerOf(tester.element(find.byType(LiveApp)))
        .read(liveProvider.notifier)
        .choisirLangue('en');
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Live'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);

    routeur.go('/telephone');
    await tester.pumpAndSettle();
    expect(find.text('Enter your phone number'), findsOneWidget);
    expect(find.text('Congo'), findsOneWidget);

    routeur.go('/accueil');
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
  });

  testWidgets('une langue pas encore traduite retombe sur le français', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    sansAnimations(tester);
    routeur.go('/bienvenue');
    await tester.pumpWidget(const ProviderScope(child: LiveApp()));
    ProviderScope.containerOf(tester.element(find.byType(LiveApp)))
        .read(liveProvider.notifier)
        .choisirLangue('ln');
    await tester.pumpAndSettle();
    expect(find.text('Bienvenue sur Live'), findsOneWidget);
  });
}
