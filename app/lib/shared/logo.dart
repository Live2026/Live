import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Logo de Live : le symbole et le nom, écrit « Live » (L majuscule).
class LogoLive extends StatelessWidget {
  const LogoLive({
    super.key,
    this.taille = 36,
    this.nom = true,
    this.couleur = LiveColors.bleu,
  });

  /// Hauteur du symbole ; le nom suit la même échelle.
  final double taille;

  /// Faux : le symbole seul (barre latérale repliée, favicon).
  final bool nom;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    final symbole = Image.asset(
      'assets/images/logo.png',
      width: taille,
      height: taille,
      semanticLabel: nom ? null : 'Live',
      // Apparition douce dès que l'image est chargée.
      frameBuilder: (context, enfant, image, synchrone) => synchrone
          ? enfant
          : AnimatedOpacity(
              opacity: image == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: enfant,
            ),
    );
    if (!nom) return symbole;
    return Semantics(
      label: 'Live',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          symbole,
          SizedBox(width: taille * 0.22),
          Text(
            'Live',
            style: TextStyle(
              fontSize: taille * 0.72,
              height: 1,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: couleur,
            ),
          ),
        ],
      ),
    );
  }
}
