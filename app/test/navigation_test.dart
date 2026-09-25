import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/core/router.dart';
import 'package:live/main.dart';
import 'package:live/shared/widgets.dart';

import 'outils.dart';

Future<void> _ouvrir(WidgetTester tester, Size taille) async {
  tester.view.physicalSize = taille;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  sansAnimations(tester);
  routeur.go('/bienvenue');
  await tester.pumpWidget(const ProviderScope(child: LiveApp()));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Découvrir sans compte'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Découvrir sans compte'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('grand écran : barre latérale accessible et navigable', (
    tester,
  ) async {
    final semantique = tester.ensureSemantics();
    await _ouvrir(tester, const Size(1280, 800));
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.bySemanticsLabel('Explorer'), findsWidgets);
    await tester.tap(find.text('Explorer'));
    await tester.pumpAndSettle();
    expect(find.text('Bonnes affaires près de vous'), findsOneWidget);
    semantique.dispose();
  });

  testWidgets('téléphone : barre d\'onglets en bas', (tester) async {
    await _ouvrir(tester, const Size(360, 780));
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('grand écran : la barre d\'action ne masque pas la page', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    sansAnimations(tester);
    routeur.go('/produit/p1');
    await tester.pumpWidget(const ProviderScope(child: LiveApp()));
    await tester.pumpAndSettle();
    final barre = tester.getSize(find.byType(BarreAction));
    expect(barre.height, lessThan(120));
    expect(find.text('Protection').hitTestable(), findsOneWidget);
  });

  testWidgets('grand écran : une page secondaire garde la barre latérale', (
    tester,
  ) async {
    await _ouvrir(tester, const Size(1280, 800));
    routeur.push('/mes-ventes');
    await tester.pumpAndSettle();
    expect(find.text('Mes ventes'), findsWidgets);
    await tester.tap(find.text('Explorer'));
    await tester.pumpAndSettle();
    expect(find.text('Bonnes affaires près de vous'), findsOneWidget);
  });

  testWidgets('grand écran : messages en deux panneaux', (tester) async {
    await _ouvrir(tester, const Size(1280, 800));
    routeur.push('/messages');
    await tester.pumpAndSettle();
    // La liste et la conversation ouverte sont visibles ensemble.
    expect(find.byTooltip('Rechercher'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    // La loupe déploie le champ de recherche dans l'en-tête.
    await tester.tap(find.byTooltip('Rechercher'));
    await tester.pumpAndSettle();
    expect(find.text('Rechercher une conversation'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
