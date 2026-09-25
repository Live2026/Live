import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/data/mock.dart';
import 'package:live/data/pouvoirs.dart';
import 'package:live/data/store.dart';

void main() {
  late ProviderContainer c;
  LiveStore store() => c.read(liveProvider.notifier);
  LiveState etat() => c.read(liveProvider);
  Set<String> actifs() => {
    for (final p in pouvoirs.where((p) => p.actifPour(etat()))) p.id,
  };

  setUp(() => c = ProviderContainer());
  tearDown(() => c.dispose());

  test('tout le monde commence en utilisateur simple (N1)', () {
    expect(etat().niveau, 1);
    expect(actifs(), {'C-ACHETER', 'C-PUBLIER-SOCIAL', 'C-VENDRE', 'C-IA'});
    expect(actifs(), isNot(contains('C-RETIRER')));
  });

  test(
    "vérifier son identité débloque retrait, services, immo et créateur",
    () {
      store().verifierIdentite();
      expect(etat().niveau, 2);
      expect(
        actifs(),
        containsAll([
          'C-RETIRER',
          'C-SERVICES',
          'C-IMMO-PARTICULIER',
          'C-CREATEUR',
        ]),
      );
      expect(actifs(), isNot(contains('C-IMMO-AGENCE')));
    },
  );

  test('créer un espace pro passe au niveau N3', () {
    store().verifierIdentite();
    store().creerEspace('Grâce Mode Bacongo', TypeEspace.boutique);
    expect(etat().niveau, 3);
    expect(etat().espaces.single.nom, 'Grâce Mode Bacongo');
    expect(actifs(), contains('C-IMMO-AGENCE'));
  });

  test("l'abonnement Live Pro débloque les statistiques avancées", () {
    store().preparerPaiement(
      const PaiementEnCours(
        type: TypePaiement.abonnement,
        montant: 5000,
        libelle: 'Live Pro',
        beneficiaire: 'Live',
        cibleId: 'pro',
      ),
    );
    store().paiementReussi();
    expect(etat().pro, isTrue);
    expect(actifs(), contains('C-STATS-AVANCEES'));
  });

  test(
    'une réclamation avance jusqu’à la décision de Live, sans aller au-delà',
    () {
      final id = store().ouvrirReclamation(
        'iPhone 11',
        'Produit différent',
        85000,
      );
      for (var i = 0; i < 5; i++) {
        store().avancerReclamation(id);
      }
      expect(etat().reclamations.single.etape, 3);
    },
  );

  test('réserver un service à prix fixe crée une prestation payée', () {
    store().preparerPaiement(
      const PaiementEnCours(
        type: TypePaiement.service,
        montant: 8000,
        libelle: 'Nattes collées',
        beneficiaire: 'Sandra',
        cibleId: 's5|sf7',
        creneau: 'Demain 10:00',
      ),
    );
    final id = store().paiementReussi();
    final p = etat().prestations.single;
    expect(p.id, id);
    expect(p.devis.total, 8000);
    expect(p.devis.prestataire.nom, 'Sandra');
  });

  test('suivre et enregistrer sont des bascules', () {
    store().basculerSuivi('electro');
    expect(etat().suivis, contains('electro'));
    store().basculerSuivi('electro');
    expect(etat().suivis, isNot(contains('electro')));
    store().basculerFavori('p1');
    expect(etat().favoris, contains('p1'));
  });

  test('les cartes d’une même catégorie partagent le même format', () {
    // Tous les biens ont un type et une icône, tous les produits une catégorie connue.
    final categories = {for (final (_, nom) in categoriesMarket) nom};
    expect(produits.every((p) => categories.contains(p.categorie)), isTrue);
    expect(biens.every((b) => b.type.libelle.isNotEmpty), isTrue);
  });
}
