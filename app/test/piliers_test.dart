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

  String payer(TypePaiement type, int montant, String libelle, String cible) {
    store().preparerPaiement(
      PaiementEnCours(
        type: type,
        montant: montant,
        libelle: libelle,
        beneficiaire: 'Test',
        cibleId: cible,
      ),
    );
    return store().paiementReussi();
  }

  test(
    'tontine : cagnotte = cotisation × membres ; la cotisation est notée',
    () {
      final t = tontineParId('t1');
      expect(t.cagnotte, 10000 * 8);
      expect(t.beneficiaire, 'Merveille K.');
      final id = payer(TypePaiement.cotisation, t.montant, 'Cotisation', t.id);
      expect(id, startsWith('TO-'));
      expect(etat().cotisations, contains('t1'));
      expect(etat().paiement, isNull);
    },
  );

  test('achat groupé, facture et recharge sont mémorisés', () {
    payer(TypePaiement.achatGroupe, 17500, 'Riz', 'ag1');
    payer(TypePaiement.facture, 18450, 'E2C', 'f1');
    expect(etat().groupes, {'ag1'});
    expect(etat().facturesPayees, contains('f1'));
  });

  test(
    'diaspora : paiement pour un proche et transfert dans « Mes envois »',
    () {
      payer(
        TypePaiement.pourUnProche,
        91350,
        'Loyer pour Maman Céline',
        'Loyer',
      );
      final id = payer(
        TypePaiement.transfert,
        66907,
        'Transfert à Frère Jordy',
        'tr-1',
      );
      expect(id, startsWith('TR-'));
      expect(etat().envois, [
        'Transfert à Frère Jordy',
        'Loyer pour Maman Céline',
      ]);
    },
  );

  test('achat groupé : le prix de groupe est inférieur au prix normal', () {
    for (final a in achatsGroupes) {
      expect(a.prixGroupe, lessThan(a.prix));
      expect(a.inscrits, lessThan(a.objectif));
    }
  });

  test('devises : euro et franc CFA ouest-africain à parité fixe', () {
    final eur = deviseParCode('EUR');
    expect(eur.fixe, isTrue);
    expect(eur.versFcfa(100), 65596);
    expect(deviseParCode('XOF').versFcfa(5000), 5000);
    expect(deviseParCode('USD').fixe, isFalse);
    expect(deviseParCode('???').code, 'EUR');
    expect(eur.libelleTaux, '1 € = 655,957 FCFA');
    for (final d in devises) {
      expect(d.maximum, d.pas * 100);
    }
  });

  test('transfert : devise mémorisée, transfert reçu retiré', () {
    expect(etat().devise, 'EUR');
    store().choisirDevise('USD');
    expect(etat().devise, 'USD');
    store().retirerTransfert('r1');
    expect(etat().transfertsRetires, {'r1'});
    expect(transfertsRecus.first.fcfa, 98394);
  });
}
