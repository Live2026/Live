import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/data/mock.dart';
import 'package:live/data/store.dart';

void main() {
  late ProviderContainer c;
  LiveStore store() => c.read(liveProvider.notifier);
  LiveState etat() => c.read(liveProvider);

  setUp(() => c = ProviderContainer());
  tearDown(() => c.dispose());

  test("coût d'entrée = avance + caution + commission", () {
    expect(bienParId('b1').coutEntree, 90000 * 3 + 90000 + 90000);
  });

  test('achat payé d\'avance puis confirmé', () {
    store().preparerPaiement(
      const PaiementEnCours(
        type: TypePaiement.commande,
        montant: 85000,
        libelle: 'iPhone',
        beneficiaire: 'Grâce Mode',
        cibleId: 'p1',
      ),
    );
    final id = store().paiementReussi();
    expect(etat().paiement, isNull);
    expect(etat().achats.single.statut, StatutCommande.acceptee);
    store().confirmerReception(id);
    expect(etat().achats.single.statut, StatutCommande.terminee);
  });

  test('payer à la remise : réservation puis paiement sur place', () {
    final id = store().reserverCommande(produitParId('p2'), 15000);
    expect(etat().achats.single.statut, StatutCommande.reservee);
    store().preparerPaiement(
      PaiementEnCours(
        type: TypePaiement.commande,
        montant: 15000,
        libelle: 'Robe',
        beneficiaire: 'Grâce Mode',
        cibleId: id,
        modeCommande: ModePaiement.remise,
      ),
    );
    expect(store().paiementReussi(), id);
    expect(etat().achats.single.statut, StatutCommande.terminee);
  });

  test('vente : le montant net (moins 6 %) est ajouté aux gains', () {
    final avant = etat().disponible;
    store().publier('Téléphone', 30000);
    final id = etat().ventes.first.id;
    store().accepterVente(id);
    store().remettreVente(id);
    expect(etat().disponible, avant + 30000 - 1800);
    expect(etat().ventes.first.statut, StatutCommande.terminee);
  });

  test('retrait refusé au-delà du disponible', () {
    final dispo = etat().disponible;
    expect(store().retirer(dispo + 1), isFalse);
    expect(store().retirer(50000), isTrue);
    expect(etat().disponible, dispo - 50000);
  });

  test('visite payée puis confirmée par QR', () {
    store().preparerPaiement(
      const PaiementEnCours(
        type: TypePaiement.visite,
        montant: 2000,
        libelle: 'Visite',
        beneficiaire: 'Agence',
        cibleId: 'b1',
        creneau: 'Mar 30 · 10:30',
      ),
    );
    final id = store().paiementReussi();
    store().confirmerVisite(id);
    expect(etat().visites.single.statut, StatutVisite.confirmee);
  });

  test('prestation : acompte, démarrage, fin', () {
    store().preparerPaiement(
      const PaiementEnCours(
        type: TypePaiement.acompte,
        montant: 10000,
        libelle: 'Acompte',
        beneficiaire: 'Serge',
        cibleId: 's1',
      ),
    );
    final id = store().paiementReussi();
    store().avancerPrestation(id);
    expect(etat().prestations.single.statut, StatutPrestation.demarree);
    store().avancerPrestation(id);
    expect(etat().prestations.single.statut, StatutPrestation.terminee);
  });

  test(
    'crédits : 20 offerts, achat du pack de 500 FCFA, dépense et recrédit',
    () {
      expect(etat().credits, 20);
      store().preparerPaiement(
        const PaiementEnCours(
          type: TypePaiement.credits,
          montant: 500,
          libelle: '50 Crédits Live',
          beneficiaire: 'Live',
          cibleId: 'p500',
        ),
      );
      store().paiementReussi();
      expect(etat().credits, 70);
      expect(store().depenserCredits(20), isTrue);
      expect(etat().credits, 50);
      expect(store().depenserCredits(51), isFalse);
      expect(etat().credits, 50);
      store().recrediter(20);
      expect(etat().credits, 70);
    },
  );

  test('les packs respectent 1 crédit = 10 FCFA au minimum', () {
    for (final p in packs) {
      expect(p.credits * 10, greaterThanOrEqualTo(p.prix));
    }
    expect(packs.first.prix, 500);
  });

  test('un document généré est conservé dans « Mes documents »', () {
    final id = store().ajouterDocument('cv', 'CV · Comptable', [
      ('GRÂCE', 'Comptable'),
    ]);
    expect(etat().documents.single.id, id);
  });

  test('refuser une commande la retire (acheteur remboursé)', () {
    expect(etat().ventes.any((v) => v.id == 'LV-00479'), isTrue);
    store().refuserVente('LV-00479', 'Rupture de stock');
    expect(etat().ventes.any((v) => v.id == 'LV-00479'), isFalse);
  });

  test('bloquer retire l’abonnement ; débloquer ; sourdine et cloche', () {
    expect(etat().suivis, contains('kimbembe'));
    store().bloquer('kimbembe');
    expect(etat().suivis, isNot(contains('kimbembe')));
    expect(etat().bloques, contains('kimbembe'));
    store().debloquer('kimbembe');
    expect(etat().bloques, isNot(contains('kimbembe')));
    store().basculerSourdine('grace');
    expect(etat().sourdine, contains('grace'));
    store().basculerCloche('kimbembe');
    expect(etat().cloches, isNot(contains('kimbembe')));
    store().retirerAbonne('jordy');
    expect(etat().retires, contains('jordy'));
  });
}
