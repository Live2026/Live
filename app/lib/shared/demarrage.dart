import 'dart:async';

import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Ce que l'on fait sur Live : un verbe par espace, avec sa couleur.
const versLive = [
  ('Achetez', Color(0xFFFB9618)),
  ('Vendez', Color(0xFFFCAF20)),
  ('Louez', Color(0xFF34D399)),
  ('Réservez', Color(0xFFF472B6)),
  ('Apprenez', Color(0xFFA78BFA)),
  ('Gagnez', Color(0xFF60A5FA)),
];

/// Les espaces de Live, en pastilles colorées (écrans de démarrage).
const espacesLive = [
  (Icons.shopping_bag_rounded, 'Market', Color(0xFFFB9618)),
  (Icons.home_work_rounded, 'Immo', Color(0xFF22C55E)),
  (Icons.handyman_rounded, 'Services', Color(0xFF38BDF8)),
  (Icons.podcasts_rounded, 'Directs', Color(0xFFF472B6)),
  (Icons.school_rounded, 'Savoir', Color(0xFFA78BFA)),
  (Icons.auto_awesome_rounded, 'Live IA', Color(0xFFFCAF20)),
];

/// Slogan dont le verbe change toutes les deux secondes : « Achetez »,
/// « Vendez », « Louez »… Fixe quand les animations sont réduites.
class SloganAnime extends StatefulWidget {
  const SloganAnime({super.key, this.taille = 34, this.couleur = Colors.white});
  final double taille;
  final Color couleur;

  @override
  State<SloganAnime> createState() => _SloganAnimeState();
}

class _SloganAnimeState extends State<SloganAnime> {
  var _rang = 0;
  Timer? _minuteur;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _minuteur?.cancel();
    if (!MediaQuery.disableAnimationsOf(context)) {
      _minuteur = Timer.periodic(
        const Duration(milliseconds: 2000),
        (_) => setState(() => _rang = (_rang + 1) % versLive.length),
      );
    }
  }

  @override
  void dispose() {
    _minuteur?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (verbe, couleur) = versLive[_rang];
    final style = TextStyle(
      fontSize: widget.taille,
      height: 1.12,
      fontWeight: FontWeight.w900,
      color: widget.couleur,
    );
    return Semantics(
      label: 'Achetez, vendez, louez, apprenez et gagnez, en toute confiance.',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            reverseDuration: const Duration(milliseconds: 120),
            switchInCurve: courbeSortie,
            transitionBuilder: (enfant, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.35),
                  end: Offset.zero,
                ).animate(animation),
                child: enfant,
              ),
            ),
            child: Text(
              verbe,
              key: ValueKey(verbe),
              style: style.copyWith(color: couleur),
            ),
          ),
          Text('en toute confiance.', style: style),
        ],
      ),
    );
  }
}

/// Courbe d'arrivée des éléments du démarrage.
const courbeSortie = Curves.easeOutCubic;

/// Pastille d'un espace : icône colorée et nom, sur fond sombre.
class PastilleEspace extends StatelessWidget {
  const PastilleEspace({
    super.key,
    required this.icone,
    required this.nom,
    required this.couleur,
  });
  final IconData icone;
  final String nom;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x26FFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: couleur.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icone, size: 16, color: couleur),
          ),
          const SizedBox(width: 8),
          Text(
            nom,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Fond du démarrage : dégradé nuit et halos de couleur qui respirent.
class FondDemarrage extends StatefulWidget {
  const FondDemarrage({super.key, required this.child});
  final Widget child;

  @override
  State<FondDemarrage> createState() => _FondDemarrageState();
}

class _FondDemarrageState extends State<FondDemarrage>
    with SingleTickerProviderStateMixin {
  late final _anim = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 7),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _anim.stop();
    } else if (!_anim.isAnimating) {
      _anim.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, enfant) {
        final t = Curves.easeInOut.transform(_anim.value);
        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B2A4A), LiveColors.nuit],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _Halo(
                alignement: Alignment(-1.1 + 0.3 * t, -0.8),
                couleur: LiveColors.orange,
              ),
              _Halo(
                alignement: Alignment(1.2 - 0.3 * t, -0.1 + 0.2 * t),
                couleur: const Color(0xFF7C3AED),
              ),
              _Halo(
                alignement: Alignment(-0.6, 1.1 - 0.25 * t),
                couleur: const Color(0xFF0EA5E9),
              ),
              enfant!,
            ],
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _Halo extends StatelessWidget {
  const _Halo({required this.alignement, required this.couleur});
  final Alignment alignement;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignement,
      child: IgnorePointer(
        child: Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                couleur.withValues(alpha: 0.35),
                couleur.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
