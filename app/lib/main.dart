import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'data/depots/depots.dart';
import 'data/depots/depots_drift.dart';
import 'data/local/base_locale.dart';
import 'data/store.dart';
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
  // Écran de lancement natif (blanc, logo au centre) retiré dès la première
  // image de Flutter, qui affiche le même logo : pas de saut visible.
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => FlutterNativeSplash.remove(),
  );
}

/// L'application. Le mode sombre suit le réglage « Apparence » (Système,
/// Clair, Sombre) ; en « Système », il suit le téléphone. Au changement de
/// mode, toute l'application est reconstruite avec les couleurs du mode.
class LiveApp extends ConsumerStatefulWidget {
  const LiveApp({super.key});

  @override
  ConsumerState<LiveApp> createState() => _LiveAppState();
}

class _LiveAppState extends ConsumerState<LiveApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Démonstration et tests : « ?apparence=sombre » dans l'adresse.
    final demande = Uri.base.queryParameters['apparence'];
    if (const {'systeme', 'clair', 'sombre'}.contains(demande)) {
      Future.microtask(
        () => ref.read(liveProvider.notifier).choisirApparence(demande!),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Le téléphone passe en mode sombre ou clair : on suit, en « Système ».
  @override
  void didChangePlatformBrightness() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final apparence = ref.watch(liveProvider.select((e) => e.apparence));
    final sombre = switch (apparence) {
      'sombre' => true,
      'clair' => false,
      _ =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark,
    };
    LiveColors.sombre = sombre;
    return MaterialApp.router(
      key: ValueKey(sombre),
      title: 'Live — prototype',
      debugShowCheckedModeBanner: false,
      theme: liveTheme(sombre: sombre),
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
