import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../shared/demarrage.dart';
import 'adaptatif.dart';
import 'theme.dart';

/// Démarrage sur ordinateur (docs/ecrans/00, section 8), comme les écrans de
/// WhatsApp : une page blanche, la flèche de retour en haut à gauche, le
/// contenu dans une colonne centrée (sans carte), le bouton en bas de la colonne, puis les
/// liens utiles. Sur téléphone et tablette, la page seule.
class CadreDemarrage extends StatelessWidget {
  const CadreDemarrage({
    super.key,
    required this.chemin,
    required this.child,
    this.largeur = 460,
  });

  final String chemin;
  final Widget child;

  /// Largeur de la colonne (plus large pour la connexion par code QR).
  final double largeur;

  @override
  Widget build(BuildContext context) {
    // Tablette : la même page, dans une colonne lisible plutôt qu'étirée.
    if (context.taille == Taille.moyenne) {
      return ColoredBox(
        color: LiveColors.surface,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: child,
          ),
        ),
      );
    }
    if (context.taille != Taille.etendue) return child;
    final theme = Theme.of(context);
    final page = DansCarte(
      child: Theme(
        data: theme.copyWith(
          appBarTheme: theme.appBarTheme.copyWith(
            backgroundColor: LiveColors.surface,
            surfaceTintColor: LiveColors.surface,
          ),
          scaffoldBackgroundColor: LiveColors.surface,
          listTileTheme: const ListTileThemeData(
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
        ),
        child: child,
      ),
    );
    return Material(
      color: LiveColors.surface,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) => Column(
            children: [
              // La flèche de retour tout en haut à gauche, comme WhatsApp.
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: SizedBox(
                    height: 48,
                    child: Navigator.of(context).canPop()
                        ? const BackButton()
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: min(largeur, c.maxWidth - 48),
                    child: page,
                  ),
                ),
              ),
              _Pied(chemin: chemin),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bas de page : l'autre chemin (se connecter ou créer un compte), puis les
/// liens légaux et l'aide.
class _Pied extends StatelessWidget {
  const _Pied({required this.chemin});
  final String chemin;

  @override
  Widget build(BuildContext context) {
    final lien = switch (chemin) {
      '/langue' ||
      '/telephone' => ('Déjà un compte Live ?', 'Se connecter', '/connexion'),
      '/connexion' || '/connexion/qr' => (
        'Pas encore de compte ?',
        'Créer un compte',
        '/langue',
      ),
      _ => null,
    };
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (lien != null) ...[
          Text(lien.$1, style: const TextStyle(color: LiveColors.gris)),
          TextButton(
            onPressed: () => context.go(lien.$3),
            child: Text(lien.$2),
          ),
          const SizedBox(width: 16),
        ],
        for (final (nom, route) in const [
          ('Conditions d’utilisation', '/legal/cgu'),
          ('Confidentialité', '/legal/confidentialite'),
          ('Aide', '/aide'),
        ])
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
    );
  }
}
