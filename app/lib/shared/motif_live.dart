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
/// espaces de Live au trait, légèrement tournés, sur toute la surface.
/// Dessiné (pas d'image à télécharger), net à toutes les tailles.
class MotifLive extends StatelessWidget {
  const MotifLive({super.key, this.intensite = 1});

  /// 1 pour l'accueil ; plus bas derrière les cartes du démarrage.
  final double intensite;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PeintreMotif(intensite),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _PeintreMotif extends CustomPainter {
  _PeintreMotif(this.intensite);
  final double intensite;

  static const _pas = 76.0;
  static const _taille = 26.0;

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFFFBF8F3));
    final lignes = (s.height / _pas).ceil() + 1;
    final colonnes = (s.width / _pas).ceil() + 1;
    for (var l = 0; l < lignes; l++) {
      for (var c = 0; c < colonnes; c++) {
        final icone = _traits[(l * 5 + c * 3) % _traits.length];
        final orange = (l + c * 2) % 3 == 0;
        final couleur = (orange ? LiveColors.orange : LiveColors.bleu)
            .withValues(alpha: (orange ? 0.20 : 0.13) * intensite);
        final centre = Offset(
          c * _pas + (l.isOdd ? _pas / 2 : 0),
          l * _pas + _pas / 2,
        );
        final angle = (((l * 7 + c * 11) % 9) - 4) * 0.09;
        final texte = TextPainter(
          text: TextSpan(
            text: String.fromCharCode(icone.codePoint),
            style: TextStyle(
              fontFamily: icone.fontFamily,
              package: icone.fontPackage,
              fontSize: _taille,
              color: couleur,
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
  bool shouldRepaint(_PeintreMotif ancien) => ancien.intensite != intensite;
}

/// Médaillon d'accueil, comme le cercle de dessins de WhatsApp : le logo au
/// centre, les espaces de Live au trait tout autour, posé sur le motif.
class IllustrationLive extends StatelessWidget {
  const IllustrationLive({super.key, this.taille = 200});
  final double taille;

  @override
  Widget build(BuildContext context) {
    final r = taille / 2;
    const autour = 10;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: taille,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0x2213385C), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A041936),
                    blurRadius: 40,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
            ),
            for (var i = 0; i < autour; i++)
              Transform.translate(
                offset: Offset(
                  cos(-pi / 2 + i * 2 * pi / autour) * r * 0.7,
                  sin(-pi / 2 + i * 2 * pi / autour) * r * 0.7,
                ),
                child: Icon(
                  _traits[i],
                  size: taille * 0.12,
                  color: i.isEven ? LiveColors.bleu : LiveColors.orange,
                ),
              ),
            LogoLive(taille: taille * 0.28, nom: false),
          ],
        ),
      ),
    );
  }
}
