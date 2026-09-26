import 'dart:math';

import 'package:flutter/material.dart';

/// Drapeau des pays proposés à la saisie du numéro, dessiné (les drapeaux en emoji ne
/// s'affichent pas sur tous les téléphones ni dans la police embarquée).
class Drapeau extends StatelessWidget {
  const Drapeau(this.code, {super.key, this.largeur = 28});

  /// Code ISO 3166 (voir `paysTelephone`).
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

    // Bande diagonale du coin bas gauche au coin haut droit, d'épaisseur
    // relative [e] (RD Congo).
    void diagonale(double e, Color c) => canvas.drawPath(
      Path()
        ..moveTo(0, s.height)
        ..lineTo(0, s.height * (1 - e * 1.6))
        ..lineTo(s.width * (1 - e), 0)
        ..lineTo(s.width, 0)
        ..lineTo(s.width, s.height * e * 1.6)
        ..lineTo(s.width * e, s.height)
        ..close(),
      p..color = c,
    );

    // Triangle au bord gauche, de profondeur relative [l].
    void triangle(double l, Color c) => canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(s.width * l, s.height / 2)
        ..lineTo(0, s.height)
        ..close(),
      p..color = c,
    );

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
      case 'CD':
        // Bleu ciel, diagonale rouge bordée de jaune, étoile jaune.
        bande(Offset.zero & s, const Color(0xFF007FFF));
        diagonale(0.34, _jaune);
        diagonale(0.22, const Color(0xFFCE1021));
        _etoile(
          canvas,
          Offset(s.width * 0.18, s.height * 0.24),
          s.height * 0.16,
          _jaune,
        );
      case 'AO':
        horizontales(const [Color(0xFFCC092F), Colors.black]);
        _etoile(canvas, s.center(Offset.zero), s.height * 0.2, _jaune);
      case 'ST':
        horizontales(const [_vert, _jaune, _jaune, _vert]);
        triangle(0.3, _rouge);
        for (final x in [0.5, 0.72]) {
          _etoile(
            canvas,
            Offset(s.width * x, s.height / 2),
            s.height * 0.13,
            Colors.black,
          );
        }
      case 'RW':
        horizontales(const [
          Color(0xFF00A1DE),
          Color(0xFF00A1DE),
          Color(0xFFFAD201),
          Color(0xFF20603D),
        ]);
        canvas.drawCircle(
          Offset(s.width * 0.8, s.height * 0.24),
          s.height * 0.12,
          p..color = const Color(0xFFFAD201),
        );
      case 'BI':
        // Rouge en haut et en bas, vert sur les côtés, croix blanche.
        bande(Offset.zero & s, const Color(0xFF1EB53A));
        for (final haut in [true, false]) {
          canvas.drawPath(
            Path()
              ..moveTo(0, haut ? 0 : s.height)
              ..lineTo(s.width, haut ? 0 : s.height)
              ..lineTo(s.width / 2, s.height / 2)
              ..close(),
            p..color = const Color(0xFFCE1126),
          );
        }
        final trait = Paint()
          ..color = Colors.white
          ..strokeWidth = s.height * 0.14;
        canvas
          ..drawLine(Offset.zero, Offset(s.width, s.height), trait)
          ..drawLine(Offset(s.width, 0), Offset(0, s.height), trait)
          ..drawCircle(
            s.center(Offset.zero),
            s.height * 0.28,
            p..color = Colors.white,
          );
      case 'CI':
        verticales(const [Color(0xFFF77F00), Colors.white, Color(0xFF009E60)]);
      case 'SN':
        verticales(const [Color(0xFF00853F), Color(0xFFFDEF42), _rouge]);
        _etoile(
          canvas,
          s.center(Offset.zero),
          s.height * 0.16,
          const Color(0xFF00853F),
        );
      case 'ML':
        verticales(const [Color(0xFF14B53A), Color(0xFFFCD116), _rouge]);
      case 'BF':
        horizontales(const [Color(0xFFEF2B2D), Color(0xFF009E49)]);
        _etoile(canvas, s.center(Offset.zero), s.height * 0.18, _jaune);
      case 'BJ':
        bande(Offset.zero & s, const Color(0xFFE8112D));
        bande(
          Rect.fromLTWH(0, 0, s.width, s.height / 2),
          const Color(0xFFFCD116),
        );
        bande(
          Rect.fromLTWH(0, 0, s.width * 0.4, s.height),
          const Color(0xFF008751),
        );
      case 'TG':
        horizontales(const [
          Color(0xFF006A4E),
          Color(0xFFFFCE00),
          Color(0xFF006A4E),
          Color(0xFFFFCE00),
          Color(0xFF006A4E),
        ]);
        bande(
          Rect.fromLTWH(0, 0, s.height * 0.6, s.height * 0.6),
          const Color(0xFFD21034),
        );
        _etoile(
          canvas,
          Offset(s.height * 0.3, s.height * 0.3),
          s.height * 0.16,
          Colors.white,
        );
      case 'NE':
        horizontales(const [
          Color(0xFFE05206),
          Colors.white,
          Color(0xFF0DB02B),
        ]);
        canvas.drawCircle(
          s.center(Offset.zero),
          s.height * 0.11,
          p..color = const Color(0xFFE05206),
        );
      case 'GN':
        verticales(const [
          Color(0xFFCE1126),
          Color(0xFFFCD116),
          Color(0xFF009460),
        ]);
      case 'NG':
        verticales(const [Color(0xFF008751), Colors.white, Color(0xFF008751)]);
      case 'GH':
        horizontales(const [
          Color(0xFFCE1126),
          Color(0xFFFCD116),
          Color(0xFF006B3F),
        ]);
        _etoile(canvas, s.center(Offset.zero), s.height * 0.16, Colors.black);
      case 'FR':
        verticales(const [Color(0xFF002395), Colors.white, Color(0xFFED2939)]);
      case 'CN':
        bande(Offset.zero & s, const Color(0xFFEE1C25));
        _etoile(
          canvas,
          Offset(s.width * 0.17, s.height * 0.3),
          s.height * 0.16,
          const Color(0xFFFFFF00),
        );
        for (final (x, y) in [
          (0.33, 0.12),
          (0.4, 0.24),
          (0.4, 0.4),
          (0.33, 0.52),
        ]) {
          _etoile(
            canvas,
            Offset(s.width * x, s.height * y),
            s.height * 0.05,
            const Color(0xFFFFFF00),
          );
        }
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
