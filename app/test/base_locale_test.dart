import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live/data/depots/depots.dart';
import 'package:live/data/depots/depots_drift.dart';
import 'package:live/data/local/base_locale.dart';
import 'package:live/data/store.dart';

void main() {
  late BaseLocale base;

  setUp(() => base = BaseLocale(NativeDatabase.memory()));
  tearDown(() => base.close());

  test('réglages : lecture, écriture, remplacement', () async {
    final p = DepotParametresDrift(base);
    expect(await p.lire('pays'), isNull);
    await p.ecrire('pays', 'Libreville');
    await p.ecrire('pays', 'Douala');
    expect(await p.lire('pays'), 'Douala');
  });

  test('brouillons : le plus récent en premier, suppression', () async {
    final b = DepotBrouillonsDrift(base);
    final flux = b.observer();
    await b.enregistrer(
      BrouillonLocal(
        id: 'b1',
        type: 'produit',
        titre: 'Samsung A10',
        contenu: '{"prix":30000}',
        misAJour: DateTime(2026, 9, 24),
      ),
    );
    await b.enregistrer(
      BrouillonLocal(
        id: 'b2',
        type: 'bien',
        titre: 'Studio Poto-Poto',
        contenu: '{}',
        misAJour: DateTime(2026, 9, 25),
      ),
    );
    expect((await flux.first).map((x) => x.id), ['b2', 'b1']);
    await b.supprimer('b2');
    expect((await flux.first).map((x) => x.id), ['b1']);
  });

  test('favoris : par type, ajout et retrait', () async {
    final f = DepotFavorisDrift(base);
    await f.basculer('bien', 'b3', present: true);
    await f.basculer('produit', 'p1', present: true);
    expect(await f.tous('bien'), {'b3'});
    await f.basculer('bien', 'b3', present: false);
    expect(await f.tous('bien'), isEmpty);
  });

  test('file d’envoi : ordre, envoi, trois échecs', () async {
    final e = DepotFileEnvoiDrift(base);
    final a = await e.ajouter('avis', '{"note":5}');
    final b = await e.ajouter('message', '{"texte":"Bonjour"}');
    expect(a, isNot(b));
    expect((await e.enAttente()).map((x) => x.id), [a, b]);
    await e.envoye(a);
    for (var i = 0; i < 3; i++) {
      await e.echec(b);
    }
    expect(await e.enAttente(), isEmpty);
  });

  test('les versions en mémoire se comportent comme Drift', () async {
    final p = DepotParametresMemoire();
    await p.ecrire('devise', 'USD');
    expect(await p.lire('devise'), 'USD');
    final e = DepotFileEnvoiMemoire();
    final id = await e.ajouter('avis', '{}');
    await e.echec(id);
    expect((await e.enAttente()).single.tentatives, 1);
  });

  test('réglages et favoris survivent à la fermeture de l’application', () async {
    ProviderContainer ouvrir() => ProviderContainer(
      overrides: [
        depotParametresProvider.overrideWithValue(DepotParametresDrift(base)),
        depotFavorisProvider.overrideWithValue(DepotFavorisDrift(base)),
      ],
    );
    final avant = ouvrir();
    avant.read(liveProvider.notifier)
      ..choisirPays('Douala')
      ..choisirDevise('CAD')
      ..basculerFavori('b1');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    avant.dispose();

    final apres = ouvrir();
    addTearDown(apres.dispose);
    apres.read(liveProvider);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    final etat = apres.read(liveProvider);
    expect(etat.pays, 'Douala');
    expect(etat.devise, 'CAD');
    expect(etat.favoris, containsAll(['b1', 'b3']));
  });
}
