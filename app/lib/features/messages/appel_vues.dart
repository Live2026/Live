part of 'appel_en_cours.dart';

/// Texte clair posé sur le fond sombre de l'appel.
const _clair = TextStyle(color: LiveColors.brumeClaire);

/// Appel audio (ou vidéo qui sonne) : grande photo, nom, état, ondes qui
/// s'élargissent tant que ça sonne.
class _Portrait extends StatefulWidget {
  const _Portrait({
    required this.nom,
    required this.couleur,
    required this.statut,
    required this.sonne,
  });
  final String nom;
  final Color couleur;
  final String statut;
  final bool sonne;

  @override
  State<_Portrait> createState() => _PortraitState();
}

class _PortraitState extends State<_Portrait>
    with SingleTickerProviderStateMixin {
  late final _ondes = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final calme = MediaQuery.disableAnimationsOf(context);
    if (widget.sonne && !calme) {
      if (!_ondes.isAnimating) _ondes.repeat();
    } else {
      _ondes.stop();
    }
  }

  @override
  void didUpdateWidget(_Portrait ancien) {
    super.didUpdateWidget(ancien);
    if (!widget.sonne) _ondes.stop();
  }

  @override
  void dispose() {
    _ondes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(widget.couleur, LiveColors.nuit, 0.55)!,
            LiveColors.nuit,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            SizedBox(
              width: 200,
              height: 200,
              child: AnimatedBuilder(
                animation: _ondes,
                builder: (context, child) => CustomPaint(
                  painter: _Ondes(widget.sonne ? _ondes.value : -1),
                  child: child,
                ),
                child: Center(
                  child: Avatar(
                    nom: widget.nom,
                    couleur: widget.couleur,
                    taille: 112,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.nom,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _clair.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(widget.statut, style: _clair.copyWith(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: LiveColors.brumeClaire,
                ),
                const SizedBox(width: 6),
                Text(t.appelChiffre, style: _clair.copyWith(fontSize: 12.5)),
              ],
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 150),
              child: Text(
                t.appelNeDonnezJamais,
                textAlign: TextAlign.center,
                style: _clair.copyWith(fontSize: 12, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Ondes extends CustomPainter {
  _Ondes(this.avance);

  /// Avancement de 0 à 1 ; négatif : pas d'ondes.
  final double avance;

  @override
  void paint(Canvas canvas, Size size) {
    if (avance < 0) return;
    final centre = size.center(Offset.zero);
    for (final decalage in [0.0, 0.5]) {
      final a = (avance + decalage) % 1;
      canvas.drawCircle(
        centre,
        56 + a * 44,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = LiveColors.brumeClaire.withValues(alpha: (1 - a) * 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(_Ondes ancien) => ancien.avance != avance;
}

/// Image de l'autre (simulée dans le prototype) : dégradé de sa couleur et
/// ses initiales en grand.
class _ImageSimulee extends StatelessWidget {
  const _ImageSimulee({required this.nom, required this.couleur});
  final String nom;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.2),
          radius: 1.1,
          colors: [couleur, Color.lerp(couleur, LiveColors.nuit, 0.8)!],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: 220,
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
    );
  }
}

/// Ma propre image, en petit dans un coin.
class _Vignette extends StatelessWidget {
  const _Vignette({required this.avant});
  final bool avant;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 96,
        height: 136,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: avant
                ? const [Color(0xFF334155), Color(0xFF0F172A)]
                : const [Color(0xFF14532D), Color(0xFF052E16)],
          ),
          border: Border.all(color: Colors.white24),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(8),
        child: Text(
          context.t.appelVous,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

/// Participants d'un appel en groupe, en grille (moi compris).
class _GrilleAppel extends StatelessWidget {
  const _GrilleAppel({
    required this.participants,
    required this.video,
    required this.micro,
  });
  final List<(String, Color)> participants;
  final bool video;
  final bool micro;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final tous = [(t.appelVous, LiveColors.bleu), ...participants];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 64, 8, 120),
        child: LayoutBuilder(
          builder: (context, c) {
            final colonnes = c.maxWidth > 700 ? 3 : 2;
            final lignes = (tous.length / colonnes).ceil();
            return GridView.count(
              crossAxisCount: colonnes,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio:
                  (c.maxWidth / colonnes) / (c.maxHeight / lignes - 8),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final (i, (nom, couleur)) in tous.indexed)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (video)
                          _ImageSimulee(nom: nom, couleur: couleur)
                        else
                          ColoredBox(
                            color: Color.lerp(couleur, LiveColors.nuit, 0.7)!,
                            child: Center(
                              child: Avatar(
                                nom: nom,
                                couleur: couleur,
                                taille: 56,
                              ),
                            ),
                          ),
                        Positioned(
                          left: 8,
                          bottom: 8,
                          right: 8,
                          child: Row(
                            children: [
                              if (i == 0 && !micro)
                                const Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: Icon(
                                    Icons.mic_off_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  nom,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// En haut : réduire, nom et durée pendant un appel vidéo ou de groupe.
class _Haut extends StatelessWidget {
  const _Haut({required this.titre, this.statut, required this.onReduire});
  final String titre;
  final String? statut;
  final VoidCallback onReduire;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            color: Colors.white,
            onPressed: onReduire,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          ),
          if (statut != null)
            Expanded(
              child: Text(
                '$titre · $statut',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  shadows: [Shadow(blurRadius: 6)],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Réseau faible : on garde l'appel en baissant la qualité, ou on passe en
/// audio (utile avec peu de données).
class _BandeauReseau extends StatelessWidget {
  const _BandeauReseau({required this.onAudio, required this.onFermer});
  final VoidCallback onAudio;
  final VoidCallback onFermer;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(
              Icons.signal_cellular_alt_1_bar_rounded,
              color: LiveColors.orangeVif,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    t.appelReseauFaible,
                    style: const TextStyle(color: Colors.white, fontSize: 12.5),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: LiveColors.orangeVif,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: onAudio,
                  child: Text(t.appelPasserAudio),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: t.fermer,
            color: Colors.white,
            onPressed: onFermer,
            icon: const Icon(Icons.close_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}
