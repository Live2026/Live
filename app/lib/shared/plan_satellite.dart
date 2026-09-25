part of 'plan_ville.dart';

/// Vue satellite stylisée : toits, végétation, voies et fleuve vus du ciel.
/// Dans l'application réelle, ce fond vient de Google Maps (type satellite).
class _FondSatellite extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFF3F4A35));
    final hasard = math.Random(7);
    // Végétation et parcelles.
    for (var i = 0; i < 70; i++) {
      final c = Offset(
        hasard.nextDouble() * s.width,
        hasard.nextDouble() * s.height,
      );
      canvas.drawCircle(
        c,
        6 + hasard.nextDouble() * 22,
        Paint()
          ..color = Color.lerp(
            const Color(0xFF2F4A2A),
            const Color(0xFF5E6B45),
            hasard.nextDouble(),
          )!.withValues(alpha: 0.7),
      );
    }
    // Toits : tôles grises, rouilles et blanches, serrées près des axes.
    for (var i = 0; i < 520; i++) {
      final x = hasard.nextDouble() * s.width;
      final y = hasard.nextDouble() * s.height * 0.9;
      final w = 4 + hasard.nextDouble() * 9;
      final h = 4 + hasard.nextDouble() * 7;
      final teinte = [
        const Color(0xFF9CA3A8),
        const Color(0xFF8B5E3C),
        const Color(0xFFC9C3B6),
        const Color(0xFF6B7280),
      ][hasard.nextInt(4)];
      canvas.drawRect(Rect.fromLTWH(x, y, w, h), Paint()..color = teinte);
    }
    // Le fleuve Congo.
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
    canvas.drawPath(fleuve, Paint()..color = const Color(0xFF2B4C63));
    // Voies principales.
    final route = Paint()
      ..color = const Color(0xFFB9B2A5)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (final axe in _axes) {
      final p = Path()..moveTo(axe.first.dx * s.width, axe.first.dy * s.height);
      for (final o in axe.skip(1)) {
        p.lineTo(o.dx * s.width, o.dy * s.height);
      }
      canvas.drawPath(p, route);
    }
    // Noms des quartiers, en blanc ombré.
    for (final e in positionsQuartiers.entries) {
      final t = TextPainter(
        text: TextSpan(
          text: e.key,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            shadows: [Shadow(blurRadius: 3)],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      t.paint(
        canvas,
        Offset(e.value.dx * s.width - t.width / 2, e.value.dy * s.height + 18),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Grands axes, communs au plan et à la vue satellite.
const _axes = [
  [Offset(0.72, 0.02), Offset(0.6, 0.3), Offset(0.5, 0.55), Offset(0.38, 0.85)],
  [Offset(0.05, 0.5), Offset(0.45, 0.5), Offset(0.95, 0.55)],
  [Offset(0.2, 0.2), Offset(0.45, 0.45), Offset(0.7, 0.75)],
];

/// Itinéraire : trait bleu épais, bordé de blanc, avec pointillés du reste.
class _Trajet extends CustomPainter {
  _Trajet(this.points);
  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size s) {
    final p = Path()
      ..moveTo(points.first.dx * s.width, points.first.dy * s.height);
    for (final o in points.skip(1)) {
      p.lineTo(o.dx * s.width, o.dy * s.height);
    }
    canvas.drawPath(
      p,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 9
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      p,
      Paint()
        ..color = const Color(0xFF1A73E8)
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _Trajet ancien) => ancien.points != points;
}

/// Point bleu de la position GPS, avec un halo qui pulse.
class _MaPosition extends StatefulWidget {
  const _MaPosition();

  @override
  State<_MaPosition> createState() => _MaPositionState();
}

class _MaPositionState extends State<_MaPosition>
    with SingleTickerProviderStateMixin {
  late final _pulsation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulsation.stop();
    } else if (!_pulsation.isAnimating) {
      _pulsation.repeat();
    }
  }

  @override
  void dispose() {
    _pulsation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Ma position',
      child: SizedBox(
        width: 44,
        height: 44,
        child: AnimatedBuilder(
          animation: _pulsation,
          builder: (_, _) => Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 16 + 28 * _pulsation.value,
                height: 16 + 28 * _pulsation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A73E8)
                      .withValues(alpha: 0.3 * (1 - _pulsation.value)),
                ),
              ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A73E8),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(color: Color(0x55000000), blurRadius: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
