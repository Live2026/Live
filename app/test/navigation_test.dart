import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/core/router.dart';
import 'package:live/main.dart';
import 'package:live/shared/widgets.dart';

Future<void> _ouvrir(WidgetTester tester, Size taille) async {
  tester.view.physicalSize = taille;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  routeur.go('/bienvenue');
  await tester.pumpWidget(const ProviderScope(child: LiveApp()));
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
    routeur.go('/produit/p1');
    await tester.pumpWidget(const ProviderScope(child: LiveApp()));
    await tester.pumpAndSettle();
    final barre = tester.getSize(find.byType(BarreAction));
    expect(barre.height, lessThan(120));
    expect(find.text('Stockage').hitTestable(), findsOneWidget);
  });
}
