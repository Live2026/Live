import 'package:drift/drift.dart';

import '../local/base_locale.dart';
import 'depots.dart';

/// Dépôts sur la base locale Drift (docs/26, §3).

class DepotParametresDrift implements DepotParametres {
  DepotParametresDrift(this._base);
  final BaseLocale _base;

  @override
  Future<String?> lire(String cle) async {
    final ligne = await (_base.select(
      _base.parametres,
    )..where((p) => p.cle.equals(cle))).getSingleOrNull();
    return ligne?.valeur;
  }

  @override
  Future<void> ecrire(String cle, String valeur) => _base
      .into(_base.parametres)
      .insertOnConflictUpdate(
        ParametresCompanion.insert(cle: cle, valeur: valeur),
      );
}

class DepotBrouillonsDrift implements DepotBrouillons {
  DepotBrouillonsDrift(this._base);
  final BaseLocale _base;

  @override
  Stream<List<BrouillonLocal>> observer() =>
      (_base.select(
        _base.brouillons,
      )..orderBy([(b) => OrderingTerm.desc(b.misAJour)])).watch().map(
        (lignes) => [
          for (final b in lignes)
            BrouillonLocal(
              id: b.id,
              type: b.type,
              titre: b.titre,
              contenu: b.contenu,
              misAJour: b.misAJour,
            ),
        ],
      );

  @override
  Future<void> enregistrer(BrouillonLocal b) => _base
      .into(_base.brouillons)
      .insertOnConflictUpdate(
        BrouillonsCompanion.insert(
          id: b.id,
          type: b.type,
          titre: b.titre,
          contenu: b.contenu,
          misAJour: b.misAJour,
        ),
      );

  @override
  Future<void> supprimer(String id) =>
      (_base.delete(_base.brouillons)..where((b) => b.id.equals(id))).go();
}

class DepotFavorisDrift implements DepotFavoris {
  DepotFavorisDrift(this._base);
  final BaseLocale _base;

  @override
  Future<Set<String>> tous(String type) async {
    final lignes = await (_base.select(
      _base.favoris,
    )..where((f) => f.type.equals(type))).get();
    return {for (final f in lignes) f.id};
  }

  @override
  Future<void> basculer(String type, String id, {required bool present}) {
    if (present) {
      return _base
          .into(_base.favoris)
          .insertOnConflictUpdate(
            FavorisCompanion.insert(id: id, type: type, ajoute: DateTime.now()),
          );
    }
    return (_base.delete(
      _base.favoris,
    )..where((f) => f.type.equals(type) & f.id.equals(id))).go();
  }
}

class DepotFileEnvoiDrift implements DepotFileEnvoi {
  DepotFileEnvoiDrift(this._base);
  final BaseLocale _base;

  @override
  Future<String> ajouter(String type, String contenu) async {
    final id = cleIdempotence();
    await _base
        .into(_base.fileEnvoi)
        .insert(
          FileEnvoiCompanion.insert(
            id: id,
            type: type,
            contenu: contenu,
            cree: DateTime.now(),
          ),
        );
    return id;
  }

  @override
  Future<List<EnvoiLocal>> enAttente() async {
    final lignes =
        await (_base.select(_base.fileEnvoi)
              ..where((e) => e.etat.equals('en_attente'))
              ..orderBy([(e) => OrderingTerm.asc(e.cree)]))
            .get();
    return [
      for (final e in lignes) EnvoiLocal(e.id, e.type, e.contenu, e.tentatives),
    ];
  }

  @override
  Future<void> envoye(String id) =>
      (_base.update(_base.fileEnvoi)..where((e) => e.id.equals(id))).write(
        const FileEnvoiCompanion(etat: Value('envoye')),
      );

  @override
  Future<void> echec(String id) => _base.transaction(() async {
    final e = await (_base.select(
      _base.fileEnvoi,
    )..where((e) => e.id.equals(id))).getSingle();
    final n = e.tentatives + 1;
    await (_base.update(_base.fileEnvoi)..where((x) => x.id.equals(id))).write(
      FileEnvoiCompanion(
        tentatives: Value(n),
        etat: Value(n >= 3 ? 'echec' : 'en_attente'),
      ),
    );
  });
}
