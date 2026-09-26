import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/core/router.dart';
import 'package:live/data/store.dart';
import 'package:live/main.dart';

import 'outils.dart';

void main() {
  setUpAll(chargerPolices);

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

    // Les écrans traduits ensuite.
    for (final (route, texte) in const [
      ('/accueil', 'For you'),
      ('/explorer', 'Money and daily life'),
      ('/market', 'Popular categories'),
      ('/produit/p1', 'Handover'),
      ('/mes-ventes', 'My sales'),
      ('/vendre', 'What are you selling?'),
      ('/moi', 'Followers'),
      ('/parametres', 'Security'),
      ('/appels', 'Calls'),
    ]) {
      routeur.go(route);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull, reason: route);
      expect(find.text(texte), findsWidgets, reason: route);
    }
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
