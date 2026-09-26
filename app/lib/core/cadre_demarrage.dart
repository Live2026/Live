import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../shared/animations.dart';
import '../shared/demarrage.dart';
import '../shared/logo.dart';
import 'adaptatif.dart';
import 'theme.dart';

/// Démarrage sur ordinateur (docs/ecrans/00, section 8), inspiré de WhatsApp
/// Web : fond clair et calme, logo en haut à gauche, une carte centrée à
/// hauteur de son contenu, puis les liens utiles sous la carte. Rien d'autre
/// ne détourne l'attention du formulaire. Sur téléphone et tablette, la page
/// seule.
///
/// Image de fond facultative : déposer `assets/images/fond_demarrage.jpg`
/// (consignes dans docs/ecrans/00, section 8). Sans elle, le fond crème.
const imageFondDemarrage = 'assets/images/fond_demarrage.jpg';

/// L'image n'est demandée que si elle figure parmi les ressources : pas de
/// requête en échec (404) tant qu'elle n'a pas été déposée.
final Future<bool> _imagePresente =
    AssetManifest.loadFromAssetBundle(rootBundle).then(
      (m) => m.listAssets().contains(imageFondDemarrage),
      onError: (_) => false,
    );

class CadreDemarrage extends StatelessWidget {
  const CadreDemarrage({
    super.key,
    required this.chemin,
    required this.child,
    this.hauteur = 620,
    this.largeur = 560,
  });

  final String chemin;
  final Widget child;

  /// Hauteur de la carte, adaptée au contenu de chaque page (router.dart).
  final double hauteur;
  final double largeur;

  /// Fond crème très léger : chaleureux, accordé à l'orange de Live.
  static const fond = Color(0xFFF8F5EF);

  @override
  Widget build(BuildContext context) {
    if (context.taille != Taille.etendue) return child;
    final theme = Theme.of(context);
    final page = DansCarte(
      child: Theme(
        data: theme.copyWith(
          appBarTheme: theme.appBarTheme.copyWith(
            toolbarHeight: 48,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
          listTileTheme: const ListTileThemeData(
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
        ),
        child: child,
      ),
    );
    return Material(
      color: fond,
      child: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<bool>(
            future: _imagePresente,
            builder: (context, s) => s.data == true
                ? Image.asset(
                    imageFondDemarrage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  )
                : const SizedBox.shrink(),
          ),
          _contenu(page),
        ],
      ),
    );
  }

  Widget _contenu(Widget page) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, c) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: c.maxHeight),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(32, 22, 32, 0),
                    child: LogoLive(taille: 30),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: min(largeur, c.maxWidth - 48),
                  height: min(hauteur, max(420.0, c.maxHeight - 190)),
                  child: Apparition(child: _Carte(child: page)),
                ),
                const SizedBox(height: 22),
                _PiedCarte(chemin: chemin),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// La carte : bord fin, grand arrondi, ombre à peine visible.
class _Carte extends StatelessWidget {
  const _Carte({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFC5CCD6)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: child,
        ),
      ),
    );
  }
}

/// Sous la carte : l'autre chemin (se connecter ou créer un compte), la
/// promesse de protection, puis les liens légaux et l'aide.
class _PiedCarte extends StatelessWidget {
  const _PiedCarte({required this.chemin});
  final String chemin;

  @override
  Widget build(BuildContext context) {
    final lien = switch (chemin) {
      '/bienvenue' ||
      '/telephone' => ('Déjà un compte Live ?', 'Se connecter', '/connexion'),
      '/connexion' || '/connexion/qr' => (
        'Pas encore de compte ?',
        'Créer un compte',
        '/telephone',
      ),
      _ => null,
    };
    return Column(
      children: [
        if (lien != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(lien.$1, style: const TextStyle(fontSize: 15)),
              TextButton(
                onPressed: () => context.go(lien.$3),
                child: Text(
                  lien.$2,
                  style: const TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    decorationColor: LiveColors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline_rounded, size: 16, color: LiveColors.gris),
            SizedBox(width: 6),
            Text(
              'Votre argent reste protégé par Live jusqu’à la remise',
              style: TextStyle(color: LiveColors.gris),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (i, (nom, route)) in const [
              ('Conditions d’utilisation', '/legal/cgu'),
              ('Confidentialité', '/legal/confidentialite'),
              ('Aide', '/aide'),
            ].indexed) ...[
              if (i > 0)
                const Text('·', style: TextStyle(color: LiveColors.gris)),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: LiveColors.gris,
                  textStyle: const TextStyle(fontSize: 12.5),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                onPressed: () => context.push(route),
                child: Text(nom),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
