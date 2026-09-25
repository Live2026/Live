import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/core/router.dart';
import 'package:live/main.dart';

import 'outils.dart';

/// Tous les écrans du prototype, ouverts directement par leur adresse.
const routes = [
  '/bienvenue',
  '/telephone',
  '/connexion',
  '/code',
  '/profil',
  '/interets',
  '/pin',
  '/accueil',
  '/explorer',
  '/publier',
  '/ia',
  '/moi',
  '/pouvoirs',
  '/live-pro',
  '/verifier',
  '/espace/nouveau',
  '/espace/equipe',
  '/profil/moi',
  '/profil/merveille',
  '/boutique/grace',
  '/boutique/palmiers',
  '/parametres',
  '/notifications',
  '/notifications/preferences',
  '/donnees',
  '/recherche',
  '/alertes',
  '/market',
  '/produit/p1',
  '/produit/p9',
  '/commande/p1',
  '/suivi/LV-00482',
  '/vendre',
  '/mes-ventes',
  '/vente/LV-00471',
  '/vente/LV-00466/qr',
  '/immo',
  '/bien/b1',
  '/bien/b9',
  '/bien/b1/visite',
  '/visite/VI-00001',
  '/visite/VI-00001/offre',
  '/agence',
  '/agence/visite/dv1',
  '/services',
  '/services/demande',
  '/services/devis',
  '/services/devis/s1',
  '/prestation/PR-00001',
  '/pro/interventions',
  '/pro/devis/nouveau',
  '/pro/s1',
  '/pro/s5/reserver/sf7',
  '/publier/media',
  '/publier/bien',
  '/publier/service',
  '/publier/envois',
  '/avis/commande/LV-00482',
  '/probleme/commande/LV-00482',
  '/reclamation/RC-00001',
  '/ia/credits',
  '/ia/historique',
  '/ia/exercice',
  '/ia/documents',
  '/ia/business-plan',
  '/ia/tuteur',
  '/ia/service/cv',
  '/ia/service/lettre',
  '/ia/document/DOC-00001',
  '/payer',
  '/payer/attente',
  '/payer/ok',
  '/gains',
  '/retirer',
  '/recu/LV-00482',
  '/messages',
  '/conversation',
  '/admin',
  '/admin/kyc',
  '/admin/kyc/k1',
  '/admin/moderation',
  '/admin/litiges',
  '/admin/litiges/l1',
  '/admin/finance',
  '/admin/utilisateurs',
  '/admin/utilisateurs/u2',
  '/admin/configuration',
  '/scenarios',
];

void main() {
  setUpAll(chargerPolices);

  for (final largeur in [320.0, 360.0, 1280.0]) {
    testWidgets(
      'tous les écrans s’affichent sans erreur à ${largeur.toInt()} px',
      (tester) async {
        tester.view.physicalSize = Size(largeur, largeur > 600 ? 800 : 780);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        sansAnimations(tester);
        routeur.go('/bienvenue');
        await tester.pumpWidget(const ProviderScope(child: LiveApp()));
        await tester.pumpAndSettle();
        final erreurs = <String>[];
        for (final r in routes) {
          routeur.go(r);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 600));
          final e = tester.takeException();
          if (e != null) erreurs.add('$r : ${e.toString().split('\n').first}');
        }
        expect(erreurs, isEmpty, reason: erreurs.join('\n'));
      },
    );
  }
}
