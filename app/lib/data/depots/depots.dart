import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Couche « dépôt » (docs/26, §2) : les écrans et `LiveStore` ne parlent
/// jamais directement à Drift ni à Supabase. Chaque dépôt a une version en
/// mémoire (tests, démonstration) et une version Drift (`depots_drift.dart`),
/// branchée au démarrage dans `main.dart`.

/// Réglages de l'utilisateur, par clé.
abstract class DepotParametres {
  Future<String?> lire(String cle);
  Future<void> ecrire(String cle, String valeur);
}

/// Brouillon d'annonce ou de demande.
class BrouillonLocal {
  const BrouillonLocal({
    required this.id,
    required this.type,
    required this.titre,
    required this.contenu,
    required this.misAJour,
  });
  final String id;
  final String type;
  final String titre;

  /// Formulaire en JSON.
  final String contenu;
  final DateTime misAJour;
}

abstract class DepotBrouillons {
  Stream<List<BrouillonLocal>> observer();
  Future<void> enregistrer(BrouillonLocal b);
  Future<void> supprimer(String id);
}

/// Favoris : (type, identifiant).
abstract class DepotFavoris {
  Future<Set<String>> tous(String type);
  Future<void> basculer(String type, String id, {required bool present});
}

/// Action en attente d'envoi.
class EnvoiLocal {
  const EnvoiLocal(this.id, this.type, this.contenu, this.tentatives);
  final String id;
  final String type;
  final String contenu;
  final int tentatives;
}

/// File d'envoi (docs/26, §4) : jamais pour l'argent, qui exige le réseau.
abstract class DepotFileEnvoi {
  /// Ajoute une action et renvoie sa clé d'idempotence.
  Future<String> ajouter(String type, String contenu);
  Future<List<EnvoiLocal>> enAttente();
  Future<void> envoye(String id);
  Future<void> echec(String id);
}

/// Clé d'idempotence créée sur l'appareil : horodatage puis aléa.
String cleIdempotence() {
  final t = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
  final a = Random.secure().nextInt(1 << 32).toRadixString(16).padLeft(8, '0');
  return '$t-$a';
}

// ---- Versions en mémoire (tests, démonstration) ----

class DepotParametresMemoire implements DepotParametres {
  final _valeurs = <String, String>{};

  @override
  Future<String?> lire(String cle) async => _valeurs[cle];

  @override
  Future<void> ecrire(String cle, String valeur) async =>
      _valeurs[cle] = valeur;
}

class DepotBrouillonsMemoire implements DepotBrouillons {
  final _brouillons = <String, BrouillonLocal>{};
  late final _flux = StreamController<List<BrouillonLocal>>.broadcast(
    onListen: _publier,
  );

  void _publier() => _flux.add(
    _brouillons.values.toList()
      ..sort((a, b) => b.misAJour.compareTo(a.misAJour)),
  );

  @override
  Stream<List<BrouillonLocal>> observer() => _flux.stream;

  @override
  Future<void> enregistrer(BrouillonLocal b) async {
    _brouillons[b.id] = b;
    _publier();
  }

  @override
  Future<void> supprimer(String id) async {
    _brouillons.remove(id);
    _publier();
  }
}

class DepotFavorisMemoire implements DepotFavoris {
  final _favoris = <String>{};

  @override
  Future<Set<String>> tous(String type) async => {
    for (final f in _favoris)
      if (f.startsWith('$type:')) f.substring(type.length + 1),
  };

  @override
  Future<void> basculer(String type, String id, {required bool present}) async {
    present ? _favoris.add('$type:$id') : _favoris.remove('$type:$id');
  }
}

class DepotFileEnvoiMemoire implements DepotFileEnvoi {
  final _file = <String, (String, String, int, String)>{};

  @override
  Future<String> ajouter(String type, String contenu) async {
    final id = cleIdempotence();
    _file[id] = (type, contenu, 0, 'en_attente');
    return id;
  }

  @override
  Future<List<EnvoiLocal>> enAttente() async => [
    for (final MapEntry(key: id, value: (t, c, n, e)) in _file.entries)
      if (e == 'en_attente') EnvoiLocal(id, t, c, n),
  ];

  @override
  Future<void> envoye(String id) async {
    final (t, c, n, _) = _file[id]!;
    _file[id] = (t, c, n, 'envoye');
  }

  @override
  Future<void> echec(String id) async {
    final (t, c, n, _) = _file[id]!;
    // Trois échecs : l'action passe en échec et l'utilisateur est prévenu.
    _file[id] = (t, c, n + 1, n + 1 >= 3 ? 'echec' : 'en_attente');
  }
}

// ---- Fournisseurs Riverpod : mémoire par défaut, Drift dans main.dart ----

final depotParametresProvider = Provider<DepotParametres>(
  (_) => DepotParametresMemoire(),
);
final depotBrouillonsProvider = Provider<DepotBrouillons>(
  (_) => DepotBrouillonsMemoire(),
);
final depotFavorisProvider = Provider<DepotFavoris>(
  (_) => DepotFavorisMemoire(),
);
final depotFileEnvoiProvider = Provider<DepotFileEnvoi>(
  (_) => DepotFileEnvoiMemoire(),
);
