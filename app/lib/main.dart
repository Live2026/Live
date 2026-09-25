import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'data/depots/depots.dart';
import 'data/depots/depots_drift.dart';
import 'data/local/base_locale.dart';
import 'shared/hors_connexion.dart';

/// Au démarrage, les dépôts passent de la mémoire à la base locale Drift
/// (docs/26) : réglages, favoris, brouillons et file d'envoi survivent à la
/// fermeture de l'application. Les tests gardent les dépôts en mémoire.
void main() {
  final base = BaseLocale.appareil();
  runApp(
    ProviderScope(
      overrides: [
        depotParametresProvider.overrideWithValue(DepotParametresDrift(base)),
        depotBrouillonsProvider.overrideWithValue(DepotBrouillonsDrift(base)),
        depotFavorisProvider.overrideWithValue(DepotFavorisDrift(base)),
        depotFileEnvoiProvider.overrideWithValue(DepotFileEnvoiDrift(base)),
      ],
      child: const LiveApp(),
    ),
  );
}

class LiveApp extends StatelessWidget {
  const LiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Live — prototype',
      debugShowCheckedModeBanner: false,
      theme: liveTheme(),
      routerConfig: routeur,
      builder: (context, child) => _BandeauPrototype(child: child!),
    );
  }
}

/// Bandeau permanent « Prototype ». L'application occupe toute la largeur de
/// l'écran : aucune colonne centrée, la mise en page s'adapte (core/adaptatif.dart).
class _BandeauPrototype extends StatelessWidget {
  const _BandeauPrototype({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Material(
          color: LiveColors.nuit,
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  'PROTOTYPE · aucune transaction réelle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                    color: LiveColors.brume,
                  ),
                ),
              ),
            ),
          ),
        ),
        const BandeauHorsConnexion(),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            // Nœud à part : sans lui, le navigateur masque aux lecteurs
            // d'écran les bandeaux posés au-dessus (hors connexion).
            child: Semantics(
              container: true,
              explicitChildNodes: true,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
