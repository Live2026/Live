import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'base_locale.g.dart';

/// Base locale de Live (Drift, SQLite) : ce que le téléphone garde pour aller
/// vite, fonctionner hors connexion et ne rien perdre (docs/26, §3).
/// Elle ne décide jamais d'un solde : l'argent reste sur le serveur.

/// Réglages de l'utilisateur : ville, devise, économie de données, intérêts.
@DataClassName('Parametre')
class Parametres extends Table {
  TextColumn get cle => text()();
  TextColumn get valeur => text()();

  @override
  Set<Column> get primaryKey => {cle};
}

/// Annonces, demandes et avis en cours d'écriture (NF-03).
@DataClassName('Brouillon')
class Brouillons extends Table {
  TextColumn get id => text()();

  /// `produit`, `bien`, `service`, `publication`…
  TextColumn get type => text()();
  TextColumn get titre => text()();

  /// Contenu du formulaire, en JSON.
  TextColumn get contenu => text()();
  DateTimeColumn get misAJour => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Annonces enregistrées (produits, biens, services, contenus).
@DataClassName('Favori')
class Favoris extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  DateTimeColumn get ajoute => dateTime()();

  @override
  Set<Column> get primaryKey => {type, id};
}

/// File d'envoi : actions faites sans réseau, rejouées au retour du réseau.
/// L'identifiant sert de clé d'idempotence côté serveur (docs/26, §4).
@DataClassName('Envoi')
class FileEnvoi extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();

  /// Données de l'action, en JSON.
  TextColumn get contenu => text()();
  IntColumn get tentatives => integer().withDefault(const Constant(0))();

  /// `en_attente`, `envoye` ou `echec`.
  TextColumn get etat => text().withDefault(const Constant('en_attente'))();
  DateTimeColumn get cree => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Parametres, Brouillons, Favoris, FileEnvoi])
class BaseLocale extends _$BaseLocale {
  /// Base sur un exécuteur donné (tests : `NativeDatabase.memory()`).
  BaseLocale(super.executeur);

  /// Base de l'appareil : fichier `live.sqlite` sur téléphone et ordinateur,
  /// stockage du navigateur (OPFS ou IndexedDB) sur le web.
  BaseLocale.appareil()
    : super(
        driftDatabase(
          name: 'live',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (m) => m.createAll());
}
