import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'depots/depots.dart';
import 'etat.dart';

/// Garde sur l'appareil les réglages et les favoris de `LiveStore` (docs/26,
/// §3.1) : ville, devise, langue, économie de données, centres d'intérêt, annonces
/// enregistrées. Lus au démarrage, écrits à chaque changement.
mixin PersistanceLocale on Notifier<LiveState> {
  /// Clés modifiées depuis le démarrage : la lecture tardive ne les écrase pas.
  final _modifiees = <String>{};

  /// Lit la base locale juste après la construction de l'état.
  void chargerLocal() {
    // Dépôts lus tout de suite : `ref` ne s'utilise plus après une attente.
    final p = ref.read(depotParametresProvider);
    final depotFavoris = ref.read(depotFavorisProvider);
    Future.microtask(() async {
      try {
        final pays = await p.lire('pays');
        final devise = await p.lire('devise');
        final langue = await p.lire('langue');
        final economie = await p.lire('economie');
        final interets = await p.lire('interets');
        // Favoris suivis seulement après un premier changement : sinon on
        // garde la sélection de démonstration.
        final suivis = await p.lire('favoris_suivis');
        final favoris = await depotFavoris.tous('annonce');
        if (!ref.mounted) return;
        state = state.copyWith(
          pays: _modifiees.contains('pays') ? null : pays,
          devise: _modifiees.contains('devise') ? null : devise,
          langue: _modifiees.contains('langue') ? null : langue,
          economieDonnees: economie == null || _modifiees.contains('economie')
              ? null
              : economie == '1',
          interets: interets == null || _modifiees.contains('interets')
              ? null
              : interets.split('|').where((i) => i.isNotEmpty).toSet(),
          favoris: suivis == null || _modifiees.contains('favoris')
              ? null
              : favoris,
        );
      } on StateError {
        // Base fermée avant la fin de la lecture : on garde l'état courant.
      }
    });
  }

  void garder(String cle, String valeur) {
    _modifiees.add(cle);
    ref.read(depotParametresProvider).ecrire(cle, valeur);
  }

  /// À appeler après la mise à jour de `state.favoris`.
  void garderFavori(String id, {required bool present}) {
    final depot = ref.read(depotFavorisProvider);
    if (_modifiees.add('favoris')) {
      // Premier changement : on enregistre toute la sélection courante.
      ref.read(depotParametresProvider).ecrire('favoris_suivis', '1');
      for (final f in state.favoris) {
        depot.basculer('annonce', f, present: true);
      }
    }
    depot.basculer('annonce', id, present: present);
  }
}
