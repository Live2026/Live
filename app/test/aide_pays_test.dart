import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/core/router.dart';
import 'package:live/data/mock.dart';
import 'package:live/data/store.dart';
import 'package:live/main.dart';
import 'package:live/shared/hors_connexion.dart';

import 'outils.dart';

Future<ProviderContainer> _ouvrir(WidgetTester tester, String route) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  sansAnimations(tester);
  final c = ProviderContainer();
  addTearDown(c.dispose);
  routeur.go(route);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: c, child: const LiveApp()),
  );
  await tester.pumpAndSettle();
  return c;
}

void main() {
  test('opérateurs Mobile Money propres à chaque pays', () {
    expect(villeLive('Brazzaville').operateurs, [
      'MTN Mobile Money',
      'Airtel Money',
    ]);
    expect(villeLive('Libreville').operateurs, contains('Moov Money'));
    expect(villeLive('Douala').operateurs, contains('Orange Money'));
    expect(villeLive('Inconnue').ville, 'Brazzaville');
  });

  test('une demande au support est numérotée et gardée', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final id = c.read(liveProvider.notifier).ecrireSupport('Paiement', 'x');
    expect(id, 'SP-10421');
    expect(c.read(liveProvider).demandesSupport.single.$2, 'Paiement');
  });

  testWidgets('au Gabon, le paiement propose Airtel et Moov, pas MTN', (
    tester,
  ) async {
    final c = await _ouvrir(tester, '/bienvenue');
    c.read(liveProvider.notifier)
      ..choisirPays('Libreville')
      ..preparerPaiement(
        const PaiementEnCours(
          type: TypePaiement.facture,
          montant: 18450,
          libelle: 'Facture',
          beneficiaire: 'SEEG',
          cibleId: 'f1',
        ),
      );
    routeur.go('/payer');
    await tester.pumpAndSettle();
    expect(find.text('Moov Money'), findsOneWidget);
    expect(find.text('Airtel Money'), findsOneWidget);
    expect(find.text('MTN Mobile Money'), findsNothing);
  });

  testWidgets('hors connexion : bandeau sur toutes les pages', (tester) async {
    addTearDown(() => horsConnexion.value = false);
    await _ouvrir(tester, '/market');
    expect(find.textContaining('Hors connexion'), findsNothing);
    horsConnexion.value = true;
    await tester.pumpAndSettle();
    expect(find.textContaining('Hors connexion'), findsOneWidget);
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Hors connexion'), findsNothing);
  });

  testWidgets('écrire au support puis retrouver la demande', (tester) async {
    await _ouvrir(tester, '/aide/ecrire');
    await tester.tap(find.text('Commande'));
    await tester.enterText(
      find.byType(TextField),
      'Commande LV-00482 non reçue depuis trois jours.',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Envoyer au support'));
    await tester.pumpAndSettle();
    expect(find.text('Commande · SP-10421'), findsOneWidget);
  });
}
