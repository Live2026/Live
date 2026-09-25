import 'package:flutter/material.dart';

/// Classes de taille de fenêtre (Material Design 3) : voir docs/ecrans/00, section 8.
enum Taille { compacte, moyenne, etendue }

Taille tailleDe(BuildContext context) {
  final largeur = MediaQuery.sizeOf(context).width;
  if (largeur >= 840) return Taille.etendue;
  if (largeur >= 600) return Taille.moyenne;
  return Taille.compacte;
}

extension TailleX on BuildContext {
  Taille get taille => tailleDe(this);
  bool get grandEcran => taille != Taille.compacte;
}

/// Deux colonnes sur grand écran (principale à gauche, secondaire à droite),
/// une seule colonne empilée sur téléphone. Même contenu, même ordre.
class DeuxColonnes extends StatelessWidget {
  const DeuxColonnes({
    super.key,
    required this.principale,
    required this.secondaire,
    this.ratio = 3 / 2,
    this.espace = 24,
  });

  final List<Widget> principale;
  final List<Widget> secondaire;
  final double ratio;
  final double espace;

  @override
  Widget build(BuildContext context) {
    if (!context.grandEcran) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [...principale, ...secondaire],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: (ratio * 100).round(),
          child: ListView(
            padding: EdgeInsets.fromLTRB(24, 16, espace / 2, 24),
            children: principale,
          ),
        ),
        Expanded(
          flex: 100,
          child: ListView(
            padding: EdgeInsets.fromLTRB(espace / 2, 16, 24, 24),
            children: secondaire,
          ),
        ),
      ],
    );
  }
}

/// Grille qui remplit toute la largeur : autant de colonnes que possible,
/// chaque carte gardant une largeur maximale lisible. Les lignes restent
/// pleines quand c'est possible (6 cartes : 3 + 3 plutôt que 5 + 1), et
/// jamais une carte seule sur la dernière ligne.
class GrilleAdaptative extends StatelessWidget {
  const GrilleAdaptative({
    super.key,
    required this.largeurMax,
    required this.enfants,
    this.hauteur,
    this.espacement = 12,
  });

  final double largeurMax;
  final List<Widget> enfants;

  /// Hauteur fixe des cellules ; si nulle, chaque ligne prend la hauteur de son contenu.
  final double? hauteur;
  final double espacement;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, contraintes) {
        final colonnes = _colonnes(
          (contraintes.maxWidth / largeurMax).ceil().clamp(1, 8),
          enfants.length,
        );
        final largeur =
            (contraintes.maxWidth - espacement * (colonnes - 1)) / colonnes;
        return Wrap(
          spacing: espacement,
          runSpacing: espacement,
          children: [
            for (final e in enfants)
              SizedBox(width: largeur, height: hauteur, child: e),
          ],
        );
      },
    );
  }
}

/// Nombre de colonnes : un diviseur du nombre de cartes proche du maximum
/// si possible, sinon le maximum sans laisser une carte seule.
int _colonnes(int max, int n) {
  if (n <= max) return max;
  for (var c = max; c >= (max * 0.6).ceil() && c > 1; c--) {
    if (n % c == 0) return c;
  }
  var c = max;
  while (c > 2 && n % c == 1) {
    c--;
  }
  return c;
}

/// Colonne centrée de largeur lisible pour les écrans de confirmation
/// (paiement réussi, identité vérifiée, retrait envoyé) : sur ordinateur,
/// le bouton final ne s'étire pas sur toute la largeur.
class Etroit extends StatelessWidget {
  const Etroit({super.key, required this.child, this.largeur = 560});
  final Widget child;
  final double largeur;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: largeur),
      child: child,
    ),
  );
}
