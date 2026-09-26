import 'dart:math';

import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'logo.dart';

/// Les dessins au trait du motif de Live : ce que l'on fait sur Live.
const _traits = [
  Icons.shopping_bag_outlined,
  Icons.home_work_outlined,
  Icons.handyman_outlined,
  Icons.podcasts_outlined,
  Icons.school_outlined,
  Icons.auto_awesome_outlined,
  Icons.local_shipping_outlined,
  Icons.qr_code_2_rounded,
  Icons.chat_bubble_outline_rounded,
  Icons.verified_user_outlined,
  Icons.favorite_border_rounded,
  Icons.storefront_outlined,
  Icons.phone_iphone_rounded,
  Icons.payments_outlined,
];

/// Motif de fond de Live, dans l'esprit des dessins de WhatsApp : les
/// espaces de Live au trait, d'une seule couleur, légèrement tournés.
/// Avec [rayonnant], les dessins se resserrent en cercle autour du centre de
/// la page et s'effacent vers les bords ; le centre reste libre pour le logo
/// (`LogoMotif`). Dessiné : rien à télécharger, net à toutes les tailles.
class MotifLive extends StatelessWidget {
  const MotifLive({super.key, this.intensite = 1, this.rayonnant = false});

  /// 1 pour l'accueil ; plus bas derrière les cartes du démarrage.
  final double intensite;
  final bool rayonnant;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PeintreMotif(intensite, rayonnant),
          size: Size.infinite,
        ),
      ),
    );
  }
}

/// Couleur unique du motif et du logo posé dedans.
const couleurMotif = LiveColors.bleu;

/// Fond du motif : blanc cassé chaud.
const fondMotif = Color(0xFFFBF8F3);

class _PeintreMotif extends CustomPainter {
  _PeintreMotif(this.intensite, this.rayonnant);
  final double intensite;
  final bool rayonnant;

  static const _pas = 62.0;
  static const _taille = 26.0;

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = fondMotif);
    if (!rayonnant) {
      _grille(canvas, s, _pas, _taille, (_) => 0.16 * intensite);
      return;
    }
    // Comme WhatsApp : un cercle serré de dessins autour du logo, et un
    // voile très léger de dessins sur le reste de la page.
    final (milieu, rayon) = geometrieMotif(s);
    final trou = rayonLogoMotif(s) + 10;
    _grille(canvas, s, _pas, _taille, (p) {
      final d = (p - milieu).distance;
      return d < rayon + 20 ? null : 0.07 * intensite;
    });
    final pas = (rayon / 4.6).clamp(30.0, 44.0);
    _grille(canvas, s, pas, pas * 0.6, (p) {
      final d = (p - milieu).distance;
      if (d < trou || d > rayon) return null;
      return (0.72 - 0.25 * (d / rayon)) * intensite;
    });
  }

  /// Une grille en quinconce de dessins ; [alpha] rend null pour sauter.
  void _grille(
    Canvas canvas,
    Size s,
    double pas,
    double taille,
    double? Function(Offset) alpha,
  ) {
    final lignes = (s.height / pas).ceil() + 1;
    final colonnes = (s.width / pas).ceil() + 1;
    for (var l = 0; l < lignes; l++) {
      for (var c = 0; c < colonnes; c++) {
        final centre = Offset(
          c * pas + (l.isOdd ? pas / 2 : 0),
          l * pas + pas / 2,
        );
        final a = alpha(centre);
        if (a == null) continue;
        final icone = _traits[(l * 5 + c * 3) % _traits.length];
        final angle = (((l * 7 + c * 11) % 9) - 4) * 0.12;
        final texte = TextPainter(
          text: TextSpan(
            text: String.fromCharCode(icone.codePoint),
            style: TextStyle(
              fontFamily: icone.fontFamily,
              package: icone.fontPackage,
              fontSize: taille,
              color: couleurMotif.withValues(alpha: a),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        canvas
          ..save()
          ..translate(centre.dx, centre.dy)
          ..rotate(angle);
        texte.paint(canvas, Offset(-texte.width / 2, -texte.height / 2));
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(_PeintreMotif ancien) =>
      ancien.intensite != intensite || ancien.rayonnant != rayonnant;
}

/// Centre et rayon du cercle de dessins : dans le haut de la page, pour
/// laisser le titre dessous et les boutons en bas (accueil de WhatsApp).
(Offset, double) geometrieMotif(Size s) {
  final rayon = min(s.width * 0.4, s.height * 0.24);
  return (Offset(s.width / 2, s.height * 0.32), rayon);
}

/// Rayon réservé au logo au centre du cercle.
double rayonLogoMotif(Size s) => (geometrieMotif(s).$2 * 0.42).clamp(46, 96);

/// Le vrai logo de Live (symbole et nom, comme en haut à gauche), assis au
/// centre du cercle de dessins, comme le téléphone au centre des dessins de
/// WhatsApp. À poser dans le même `Stack` que [MotifLive], sur toute sa
/// surface.
class LogoMotif extends StatelessWidget {
  const LogoMotif({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final (centre, _) = geometrieMotif(c.biggest);
        final r = rayonLogoMotif(c.biggest);
        return Stack(
          children: [
            Positioned(
              left: centre.dx - r,
              top: centre.dy - r,
              width: r * 2,
              height: r * 2,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: LogoLive(taille: r * 0.66),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
