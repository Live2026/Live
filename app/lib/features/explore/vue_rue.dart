part of 'explore_screen.dart';

/// E-CAR-02 — Vue rue (Google Street View dans l'application réelle) :
/// panorama qu'on fait glisser du doigt, boussole, avancer dans la rue.
class EcranVueRue extends StatefulWidget {
  const EcranVueRue({super.key, required this.lieu});
  final String lieu;

  @override
  State<EcranVueRue> createState() => _EcranVueRueState();
}

class _EcranVueRueState extends State<EcranVueRue> {
  final _defilement = ScrollController();
  var _pas = 0;
  var _cap = 0.0;

  @override
  void initState() {
    super.initState();
    _defilement.addListener(() {
      final max = _defilement.position.maxScrollExtent;
      if (max > 0) setState(() => _cap = _defilement.offset / max * 360);
    });
  }

  @override
  void dispose() {
    _defilement.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          LayoutBuilder(
            builder: (context, c) => SingleChildScrollView(
              controller: _defilement,
              scrollDirection: Axis.horizontal,
              child: CustomPaint(
                size: Size(c.maxWidth * 3, c.maxHeight),
                painter: _Panorama(graine: widget.lieu.hashCode + _pas),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    BoutonVerre(
                      icone: Icons.arrow_back_rounded,
                      libelle: context.t.retour,
                      onTap: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xAA000000),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.lieu,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              context.t.explorerVueRueGlissezPourRegarder,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Semantics(
                      label: context.t.explorerBoussoleCap(_cap.round()),
                      child: Transform.rotate(
                        angle: -_cap * math.pi / 180,
                        child: const CircleAvatar(
                          backgroundColor: LiveColors.surface,
                          child: Icon(
                            Icons.navigation_rounded,
                            color: LiveColors.erreur,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Center(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: LiveColors.surface,
                  foregroundColor: LiveColors.encre,
                  minimumSize: const Size(0, 48),
                ),
                onPressed: () => setState(() => _pas++),
                icon: const Icon(Icons.keyboard_double_arrow_up_rounded),
                label: Text(context.t.explorerAvancerDansLaRue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rue de Brazzaville dessinée : ciel, façades colorées, enseignes, poteaux,
/// chaussée en perspective. La graine change la rue à chaque pas.
class _Panorama extends CustomPainter {
  _Panorama({required this.graine});
  final int graine;

  static const _enseignes = [
    'ALIMENTATION',
    'PHARMACIE',
    'COIFFURE',
    'MOBILE MONEY',
    'QUINCAILLERIE',
    'BOULANGERIE',
    'TÉLÉPHONES',
    'BAR-DANCING',
  ];

  @override
  void paint(Canvas canvas, Size s) {
    final h = math.Random(graine);
    final horizon = s.height * 0.58;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s.width, horizon),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF7FB3E0), Color(0xFFDCEBF7)],
        ).createShader(Rect.fromLTWH(0, 0, s.width, horizon)),
    );
    // Façades.
    var x = 0.0;
    while (x < s.width) {
      final w = 90 + h.nextDouble() * 140;
      final haut = s.height * (0.18 + h.nextDouble() * 0.22);
      final couleur = [
        const Color(0xFFE9C46A),
        const Color(0xFFF4A261),
        const Color(0xFF84A98C),
        const Color(0xFFE5E5E5),
        const Color(0xFF90BE6D),
        const Color(0xFFCDB4DB),
      ][h.nextInt(6)];
      final rect = Rect.fromLTWH(x, horizon - haut, w - 6, haut);
      canvas.drawRect(rect, Paint()..color = couleur);
      // Toit de tôle.
      canvas.drawRect(
        Rect.fromLTWH(x - 4, horizon - haut - 8, w + 2, 8),
        Paint()..color = const Color(0xFF8D8D8D),
      );
      // Porte et fenêtres.
      canvas.drawRect(
        Rect.fromLTWH(x + w * 0.4, horizon - haut * 0.45, w * 0.2, haut * 0.45),
        Paint()..color = const Color(0xFF5C4033),
      );
      for (final fx in [0.12, 0.7]) {
        canvas.drawRect(
          Rect.fromLTWH(x + w * fx, horizon - haut * 0.8, w * 0.16, haut * 0.2),
          Paint()..color = const Color(0xFF4A6FA5),
        );
      }
      // Enseigne.
      if (h.nextBool()) {
        final t = TextPainter(
          text: TextSpan(
            text: _enseignes[h.nextInt(_enseignes.length)],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: w - 16);
        final fond = Rect.fromLTWH(x + 4, horizon - haut + 6, w - 14, 20);
        canvas.drawRect(fond, Paint()..color = const Color(0xFFB91C1C));
        t.paint(canvas, Offset(x + 10, horizon - haut + 9));
      }
      // Poteau électrique.
      if (h.nextInt(3) == 0) {
        canvas.drawRect(
          Rect.fromLTWH(
            x + w - 4,
            horizon - s.height * 0.42,
            4,
            s.height * 0.42,
          ),
          Paint()..color = const Color(0xFF5B4636),
        );
      }
      x += w;
    }
    // Trottoir de terre et chaussée.
    canvas.drawRect(
      Rect.fromLTWH(0, horizon, s.width, s.height * 0.06),
      Paint()..color = const Color(0xFFB5835A),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, horizon + s.height * 0.06, s.width, s.height),
      Paint()..color = const Color(0xFF5F6368),
    );
    final ligne = Paint()
      ..color = Colors.white70
      ..strokeWidth = 4;
    for (var lx = 0.0; lx < s.width; lx += 80) {
      canvas.drawLine(
        Offset(lx, s.height * 0.82),
        Offset(lx + 40, s.height * 0.82),
        ligne,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _Panorama ancien) => ancien.graine != graine;
}
