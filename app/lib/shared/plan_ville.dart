import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'animations.dart';

part 'plan_satellite.dart';

/// Fond de la carte : plan dessiné ou vue satellite.
enum ModeCarte { plan, satellite }

/// Position des quartiers de Brazzaville sur le plan (0 à 1, nord en haut).
const positionsQuartiers = <String, Offset>{
  'Djiri': Offset(0.72, 0.08),
  'Talangaï': Offset(0.62, 0.2),
  'Ouenzé': Offset(0.5, 0.33),
  'Mfilou': Offset(0.2, 0.45),
  'Moungali': Offset(0.44, 0.46),
  'Poto-Poto': Offset(0.58, 0.52),
  'Plateau': Offset(0.66, 0.66),
  'Bacongo': Offset(0.38, 0.72),
  'Makélékélé': Offset(0.22, 0.8),
};

/// Position d'une annonce : son quartier, légèrement décalée selon le rang
/// pour que deux repères du même quartier ne se recouvrent pas.
Offset positionDe(String quartier, int rang) {
  final base =
      positionsQuartiers[positionsQuartiers.keys.firstWhere(
        (q) => quartier.contains(q),
        orElse: () => 'Moungali',
      )]!;
  final angle = rang * 2.4;
  final r = rang == 0 ? 0.0 : 0.045;
  return Offset(base.dx + r * math.cos(angle), base.dy + r * math.sin(angle));
}

/// Repère posé sur le plan : une pastille avec un libellé court (prix).
class Repere {
  const Repere({
    required this.position,
    required this.libelle,
    required this.onTap,
    this.selectionne = false,
    this.couleur = LiveColors.bleu,
  });
  final Offset position;
  final String libelle;
  final VoidCallback onTap;
  final bool selectionne;
  final Color couleur;
}

/// Plan stylisé de Brazzaville (fleuve Congo, grands axes, quartiers) avec
/// des repères cliquables. Remplace une carte en ligne dans le prototype.
class PlanVille extends StatelessWidget {
  const PlanVille({
    super.key,
    required this.reperes,
    this.mode = ModeCarte.plan,
    this.trajet = const [],
    this.maPosition,
  });
  final List<Repere> reperes;
  final ModeCarte mode;

  /// Itinéraire dessiné sur la carte (points de 0 à 1).
  final List<Offset> trajet;

  /// Position GPS de l'utilisateur : point bleu qui pulse.
  final Offset? maPosition;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final taille = Size(c.maxWidth, c.maxHeight);
        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: mode == ModeCarte.plan ? _Fond() : _FondSatellite(),
              ),
            ),
            if (trajet.length > 1)
              Positioned.fill(child: CustomPaint(painter: _Trajet(trajet))),
            if (maPosition != null)
              Positioned(
                left: maPosition!.dx * taille.width - 22,
                top: maPosition!.dy * taille.height - 22,
                child: const _MaPosition(),
              ),
            for (final r in reperes)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: courbeDouce,
                left: r.position.dx * taille.width - 44,
                top: r.position.dy * taille.height - 16,
                child: _Pastille(repere: r),
              ),
          ],
        );
      },
    );
  }
}

class _Pastille extends StatelessWidget {
  const _Pastille({required this.repere});
  final Repere repere;

  @override
  Widget build(BuildContext context) {
    final r = repere;
    return Semantics(
      button: true,
      selected: r.selectionne,
      label: r.libelle,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: r.onTap,
        child: SizedBox(
          width: 88,
          child: Center(
            child: AnimatedScale(
              scale: r.selectionne ? 1.15 : 1,
              duration: const Duration(milliseconds: 200),
              curve: courbeDouce,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: r.selectionne
                      ? LiveColors.orangeVif
                      : LiveColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: r.selectionne ? LiveColors.orangeVif : r.couleur,
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33041936),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  r.libelle,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: r.selectionne ? Colors.white : r.couleur,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Fond extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFFEFF1EA));
    // Espaces verts.
    final vert = Paint()..color = const Color(0xFFDCE8D3);
    canvas.drawCircle(
      Offset(s.width * 0.3, s.height * 0.25),
      s.width * 0.12,
      vert,
    );
    canvas.drawCircle(
      Offset(s.width * 0.82, s.height * 0.35),
      s.width * 0.09,
      vert,
    );
    // Le fleuve Congo, au sud et à l'est.
    final fleuve = Path()
      ..moveTo(0, s.height * 0.92)
      ..quadraticBezierTo(
        s.width * 0.45,
        s.height * 0.86,
        s.width * 0.7,
        s.height * 0.9,
      )
      ..quadraticBezierTo(
        s.width * 0.9,
        s.height * 0.8,
        s.width,
        s.height * 0.45,
      )
      ..lineTo(s.width, s.height)
      ..lineTo(0, s.height)
      ..close();
    canvas.drawPath(fleuve, Paint()..color = const Color(0xFFBFD9EE));
    // Grands axes.
    final route = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final bord = Paint()
      ..color = LiveColors.brume
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final axes = [
      [
        const Offset(0.72, 0.02),
        const Offset(0.6, 0.3),
        const Offset(0.5, 0.55),
        const Offset(0.38, 0.85),
      ],
      [
        const Offset(0.05, 0.5),
        const Offset(0.45, 0.5),
        const Offset(0.95, 0.55),
      ],
      [
        const Offset(0.2, 0.2),
        const Offset(0.45, 0.45),
        const Offset(0.7, 0.75),
      ],
    ];
    for (final axe in axes) {
      final p = Path()..moveTo(axe.first.dx * s.width, axe.first.dy * s.height);
      for (final o in axe.skip(1)) {
        p.lineTo(o.dx * s.width, o.dy * s.height);
      }
      canvas.drawPath(p, bord);
      canvas.drawPath(p, route);
    }
    // Noms des quartiers.
    for (final e in positionsQuartiers.entries) {
      final t = TextPainter(
        text: TextSpan(
          text: e.key.toUpperCase(),
          style: const TextStyle(
            fontSize: 9.5,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: Color(0xFF8A94A3),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      t.paint(
        canvas,
        Offset(e.value.dx * s.width - t.width / 2, e.value.dy * s.height + 18),
      );
    }
    final fleuveNom = TextPainter(
      text: const TextSpan(
        text: 'Fleuve Congo',
        style: TextStyle(
          fontSize: 11,
          fontStyle: FontStyle.italic,
          color: Color(0xFF5B87AD),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    fleuveNom.paint(canvas, Offset(s.width * 0.08, s.height * 0.95));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
