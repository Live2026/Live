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

  test('tontine : cagnotte = cotisation × membres ; la cotisation est notée', () {
    final t = tontineParId('t1');
    expect(t.cagnotte, 10000 * 8);
    expect(t.beneficiaire, 'Merveille K.');
    final id = payer(TypePaiement.cotisation, t.montant, 'Cotisation', t.id);
    expect(id, startsWith('TO-'));
    expect(etat().cotisations, contains('t1'));
    expect(etat().paiement, isNull);
  });

  test('achat groupé, facture et recharge sont mémorisés', () {
    payer(TypePaiement.achatGroupe, 17500, 'Riz', 'ag1');
    payer(TypePaiement.facture, 18450, 'E2C', 'f1');
    expect(etat().groupes, {'ag1'});
    expect(etat().facturesPayees, contains('f1'));
  });

  test('diaspora : paiement pour un proche et transfert dans « Mes envois »', () {
    payer(TypePaiement.pourUnProche, 91350, 'Loyer pour Maman Céline', 'Loyer');
    final id = payer(TypePaiement.transfert, 66907, 'Transfert à Frère Jordy', 'tr-1');
    expect(id, startsWith('TR-'));
    expect(etat().envois, [
      'Transfert à Frère Jordy',
      'Loyer pour Maman Céline',
    ]);
  });

  test('achat groupé : le prix de groupe est inférieur au prix normal', () {
    for (final a in achatsGroupes) {
      expect(a.prixGroupe, lessThan(a.prix));
      expect(a.inscrits, lessThan(a.objectif));
    }
  });
}
