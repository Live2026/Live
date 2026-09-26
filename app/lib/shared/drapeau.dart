import 'dart:math';

import 'package:flutter/material.dart';

/// Drapeau des pays de la CEMAC, dessiné (les drapeaux en emoji ne
/// s'affichent pas sur tous les téléphones ni dans la police embarquée).
class Drapeau extends StatelessWidget {
  const Drapeau(this.code, {super.key, this.largeur = 28});

  /// Code ISO 3166 : CG, GA, CM, TD, CF, GQ.
  final String code;
  final double largeur;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: SizedBox(
          width: largeur,
          height: largeur * 2 / 3,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x22000000), width: 0.5),
              borderRadius: BorderRadius.circular(3),
            ),
            child: CustomPaint(painter: _PeintreDrapeau(code)),
          ),
        ),
      ),
    );
  }
}

class _PeintreDrapeau extends CustomPainter {
  _PeintreDrapeau(this.code);
  final String code;

  static const _vert = Color(0xFF009543);
  static const _jaune = Color(0xFFFBDE4A);
  static const _rouge = Color(0xFFDC241F);
  static const _bleu = Color(0xFF002664);

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint();
    void bande(Rect r, Color c) => canvas.drawRect(r, p..color = c);
    void horizontales(List<Color> cs) {
      final h = s.height / cs.length;
      for (final (i, c) in cs.indexed) {
        bande(Rect.fromLTWH(0, i * h, s.width, h + 0.5), c);
      }
    }

    void verticales(List<Color> cs) {
      final w = s.width / cs.length;
      for (final (i, c) in cs.indexed) {
        bande(Rect.fromLTWH(i * w, 0, w + 0.5, s.height), c);
      }
    }

    switch (code) {
      case 'CG':
        // Diagonale : vert en haut à gauche, bande jaune, rouge en bas.
        bande(Offset.zero & s, _jaune);
        canvas.drawPath(
          Path()
            ..moveTo(0, 0)
            ..lineTo(s.width * 0.65, 0)
            ..lineTo(0, s.height)
            ..close(),
          p..color = _vert,
        );
        canvas.drawPath(
          Path()
            ..moveTo(s.width, 0)
            ..lineTo(s.width, s.height)
            ..lineTo(s.width * 0.35, s.height)
            ..close(),
          p..color = _rouge,
        );
      case 'GA':
        horizontales(const [_vert, _jaune, Color(0xFF3A75C4)]);
      case 'CM':
        verticales(const [Color(0xFF007A5E), Color(0xFFCE1126), _jaune]);
        _etoile(canvas, s.center(Offset.zero), s.height * 0.22, _jaune);
      case 'TD':
        verticales(const [_bleu, Color(0xFFFECB00), Color(0xFFC60C30)]);
      case 'CF':
        horizontales(const [_bleu, Colors.white, Color(0xFF289728), _jaune]);
        bande(
          Rect.fromLTWH(s.width * 0.42, 0, s.width * 0.16, s.height),
          const Color(0xFFD21034),
        );
        _etoile(
          canvas,
          Offset(s.width * 0.18, s.height * 0.12),
          s.height * 0.1,
          _jaune,
        );
      case 'GQ':
        horizontales(const [
          Color(0xFF3E9A00),
          Colors.white,
          Color(0xFFE32118),
        ]);
        canvas.drawPath(
          Path()
            ..moveTo(0, 0)
            ..lineTo(s.width * 0.22, s.height / 2)
            ..lineTo(0, s.height)
            ..close(),
          p..color = const Color(0xFF0073CE),
        );
      default:
        bande(Offset.zero & s, const Color(0xFFD7DCE4));
    }
  }

  void _etoile(Canvas canvas, Offset c, double r, Color couleur) {
    final chemin = Path();
    for (var i = 0; i < 10; i++) {
      final rayon = i.isEven ? r : r * 0.4;
      final a = -pi / 2 + i * pi / 5;
      final pt = c + Offset(cos(a) * rayon, sin(a) * rayon);
      i == 0 ? chemin.moveTo(pt.dx, pt.dy) : chemin.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(chemin..close(), Paint()..color = couleur);
  }

  @override
  bool shouldRepaint(_PeintreDrapeau ancien) => ancien.code != code;
}
