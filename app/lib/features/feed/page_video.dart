part of 'feed_screen.dart';

/// Une vidéo du fil, façon TikTok : barre d'actions à droite, auteur avec
/// bouton « suivre », légende, son, barre de progression et annonce liée.
class _PageVideo extends StatefulWidget {
  const _PageVideo({required this.pub});
  final Publication pub;

  @override
  State<_PageVideo> createState() => _PageVideoState();
}

class _PageVideoState extends State<_PageVideo> with TickerProviderStateMixin {
  var _carteOuverte = false;
  var _aime = false;
  var _enregistre = false;
  var _suivi = false;
  var _coeur = false;
  late final _progression = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  );
  late final _disque = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!MediaQuery.disableAnimationsOf(context)) {
      _progression.repeat();
      _disque.repeat();
    }
  }

  @override
  void dispose() {
    _progression.dispose();
    _disque.dispose();
    super.dispose();
  }

  void _doubleTape() {
    setState(() {
      _aime = true;
      _coeur = true;
    });
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _coeur = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pub;
    final (titre, prix, action, route, extra) = annonceDe(p);
    return GestureDetector(
      onDoubleTap: _doubleTape,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [p.couleur, Color.lerp(p.couleur, Colors.black, 0.85)!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white24,
                size: 120,
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x55000000),
                  Colors.transparent,
                  Colors.transparent,
                  Color(0x99000000),
                ],
                stops: [0, 0.18, 0.6, 1],
              ),
            ),
          ),
          Center(
            child: AnimatedScale(
              scale: _coeur ? 1 : 0,
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutBack,
              child: const Icon(
                Icons.favorite_rounded,
                color: Color(0xFFFF4D67),
                size: 110,
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 96,
            child: Column(
              children: [
                _Auteur(
                  pub: p,
                  suivi: _suivi,
                  onSuivre: () => setState(() => _suivi = true),
                ),
                const SizedBox(height: 18),
                _Action(
                  icone: _aime
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  texte: p.likes,
                  couleur: _aime ? const Color(0xFFFF4D67) : Colors.white,
                  actif: _aime,
                  onTap: () => setState(() => _aime = !_aime),
                ),
                _Action(
                  icone: Icons.chat_bubble_rounded,
                  texte: p.commentaires,
                  onTap: () => ouvrirCommentaires(context, p),
                ),
                _Action(
                  icone: _enregistre
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  texte: 'Garder',
                  couleur: _enregistre ? LiveColors.ambre : Colors.white,
                  actif: _enregistre,
                  onTap: () => setState(() => _enregistre = !_enregistre),
                ),
                _Action(
                  icone: Icons.reply_rounded,
                  texte: p.partages,
                  miroir: true,
                  onTap: () => partager(context, p.texte),
                ),
                _Action(
                  icone: Icons.more_horiz_rounded,
                  texte: 'Plus',
                  onTap: () => optionsPublication(context, p.auteur),
                ),
                const SizedBox(height: 4),
                RotationTransition(
                  turns: _disque,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          Color(0xFF111827),
                          Color(0xFF374151),
                          Color(0xFF111827),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 12,
            right: 80,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      p.auteur,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      color: LiveColors.ambre,
                      size: 16,
                    ),
                    if (p.distance != null)
                      Text(
                        ' · ${p.distance}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  p.texte,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14.5),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.music_note_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        p.son,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Sur grand écran, le panneau de droite montre déjà l'annonce.
                if (!context.grandEcran)
                  _PastilleAnnonce(
                    ouverte: _carteOuverte,
                    titre: titre,
                    prix: prix,
                    action: action,
                    extra: extra,
                    onTap: () => _carteOuverte
                        ? context.push(route)
                        : setState(() => _carteOuverte = true),
                    onAction: () => context.push(route),
                  ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _progression,
              builder: (_, _) => LinearProgressIndicator(
                value: _progression.value,
                minHeight: 2.5,
                backgroundColor: Colors.white24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar de l'auteur avec la pastille « + » pour s'abonner.
class _Auteur extends StatelessWidget {
  const _Auteur({
    required this.pub,
    required this.suivi,
    required this.onSuivre,
  });
  final Publication pub;
  final bool suivi;
  final VoidCallback onSuivre;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 60,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          GestureDetector(
            onTap: () => context.push(
              '/boutique/${pub.auteur.contains('palmiers') ? 'palmiers' : 'grace'}',
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Avatar(nom: pub.auteur, couleur: pub.couleur, taille: 44),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Semantics(
              button: true,
              label: suivi ? 'Abonné' : 'Suivre ${pub.auteur}',
              excludeSemantics: true,
              child: GestureDetector(
                onTap: onSuivre,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: suivi ? Colors.white : const Color(0xFFFF4D67),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    suivi ? Icons.check_rounded : Icons.add_rounded,
                    size: 16,
                    color: suivi ? const Color(0xFFFF4D67) : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pastille compacte de l'annonce liée, qui s'ouvre en carte au toucher.
class _PastilleAnnonce extends StatelessWidget {
  const _PastilleAnnonce({
    required this.ouverte,
    required this.titre,
    required this.prix,
    required this.action,
    required this.extra,
    required this.onTap,
    required this.onAction,
  });
  final bool ouverte;
  final String titre;
  final String prix;
  final String action;
  final String? extra;
  final VoidCallback onTap;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: courbeDouce,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: ouverte ? 0.96 : 0.88),
            borderRadius: BorderRadius.circular(ouverte ? 14 : 30),
          ),
          child: ouverte
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      prix,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (extra != null) Text(extra!),
                    const SizedBox(height: 8),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                      ),
                      onPressed: onAction,
                      child: Text(action),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_offer, size: 18),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '$titre · $prix',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$action ›',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icone,
    required this.texte,
    required this.onTap,
    this.couleur = Colors.white,
    this.actif = false,
    this.miroir = false,
  });
  final IconData icone;
  final String texte;
  final VoidCallback onTap;
  final Color couleur;
  final bool actif;
  final bool miroir;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Semantics(
        button: true,
        label: texte,
        excludeSemantics: true,
        child: Pressable(
          echelle: 0.85,
          onTap: onTap,
          child: Column(
            children: [
              AnimatedScale(
                scale: actif ? 1.15 : 1,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                child: Transform.flip(
                  flipX: miroir,
                  child: Icon(
                    icone,
                    color: couleur,
                    size: 34,
                    shadows: const [
                      Shadow(blurRadius: 6, color: Colors.black38),
                    ],
                  ),
                ),
              ),
              Text(
                texte,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
