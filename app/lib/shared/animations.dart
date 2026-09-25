import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Courbe douce inspirée des animations d'iOS (démarrage vif, arrivée amortie).
const courbeDouce = Cubic(0.2, 0.8, 0.2, 1);

/// Toutes les animations respectent le réglage « réduire les animations » du téléphone.

/// Élément tapable qui s'enfonce légèrement au toucher (retour tactile visuel).
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.echelle = 0.97,
  });
  final Widget child;
  final VoidCallback? onTap;
  final double echelle;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  var _presse = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: widget.onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _presse = true),
        onTapCancel: () => setState(() => _presse = false),
        onTapUp: (_) => setState(() => _presse = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _presse ? widget.echelle : 1,
          duration: const Duration(milliseconds: 140),
          curve: courbeDouce,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Apparition en fondu avec une légère montée, décalée selon le rang (cascade).
class Apparition extends StatelessWidget {
  const Apparition({super.key, required this.child, this.rang = 0});
  final Widget child;
  final int rang;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    final retard = (rang.clamp(0, 12)) * 45;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + retard),
      curve: Interval(retard / (420 + retard), 1, curve: courbeDouce),
      builder: (_, t, enfant) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - t)),
          child: enfant,
        ),
      ),
      child: child,
    );
  }
}

/// Nombre qui défile jusqu'à sa valeur (soldes, statistiques).
class ChiffreAnime extends StatelessWidget {
  const ChiffreAnime({
    super.key,
    required this.valeur,
    required this.format,
    this.style,
  });
  final int valeur;
  final String Function(int) format;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Text(format(valeur), style: style);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(end: valeur.toDouble()),
      duration: const Duration(milliseconds: 900),
      curve: courbeDouce,
      builder: (_, v, _) => Text(format(v.round()), style: style),
    );
  }
}

/// Coche de réussite qui apparaît avec un léger rebond.
class CocheAnimee extends StatelessWidget {
  const CocheAnimee({
    super.key,
    this.taille = 88,
    this.couleur = LiveColors.succes,
  });
  final double taille;
  final Color couleur;

  @override
  Widget build(BuildContext context) {
    final sansAnimation = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: sansAnimation ? 1 : 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticOut,
      builder: (_, t, _) => Transform.scale(
        scale: 0.4 + 0.6 * t,
        child: Opacity(
          opacity: t.clamp(0, 1),
          child: Container(
            width: taille,
            height: taille,
            decoration: BoxDecoration(
              color: couleur.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: couleur,
              size: taille * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
