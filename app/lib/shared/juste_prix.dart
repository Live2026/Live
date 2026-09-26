import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/theme.dart';

/// « Le juste prix » de Live IA : fourchette observée sur les ventes et les
/// locations réelles du même type, dans le même quartier, et position du
/// prix affiché dans cette fourchette.
class JustePrix extends StatelessWidget {
  const JustePrix({
    super.key,
    required this.prix,
    required this.bas,
    required this.haut,
    required this.base,
    this.suffixe = '',
  });
  final int prix;
  final int bas;
  final int haut;

  /// Ce sur quoi repose l'estimation (« 38 ventes de ce modèle à Brazzaville »).
  final String base;

  /// « / mois » pour un loyer.
  final String suffixe;

  @override
  Widget build(BuildContext context) {
    final (verdict, couleur, icone) = prix < bas
        ? ('Bon prix', LiveColors.succes, Icons.thumb_up_alt_rounded)
        : prix > haut
        ? ('Au-dessus du marché', LiveColors.erreur, Icons.trending_up_rounded)
        : (
            'Prix du marché',
            const Color(0xFF0369A1),
            Icons.check_circle_rounded,
          );
    // L'échelle va de 70 % du bas à 130 % du haut.
    final min = bas * 0.7;
    final max = haut * 1.3;
    double pos(num v) => ((v - min) / (max - min)).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LiveColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LiveColors.filet),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: LiveColors.orange),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Le juste prix · Live IA',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Icon(icone, color: couleur, size: 18),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  verdict,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: couleur, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              return SizedBox(
                height: 34,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 12,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF86EFAC),
                              Color(0xFF93C5FD),
                              Color(0xFFFCA5A5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Fourchette du marché.
                    Positioned(
                      left: w * pos(bas),
                      width: w * (pos(haut) - pos(bas)),
                      top: 9,
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF0369A1),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: pos(prix)),
                      duration: MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, _) => Positioned(
                        left: (w * v - 9).clamp(0, w - 18),
                        top: 0,
                        child: Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 18,
                          color: couleur,
                          shadows: const [Shadow(blurRadius: 2)],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Text(
            'Marché : ${fcfa(bas)} à ${fcfa(haut)}$suffixe',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          Text(
            base,
            style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

/// Fourchette du marché de démonstration pour un prix donné : selon la
/// graine, l'annonce est un bon prix, au prix du marché ou au-dessus.
(int, int) fourchetteMarche(int prix, int graine) {
  final (b, h) = switch (graine % 3) {
    0 => (1.04, 1.22),
    1 => (0.9, 1.1),
    _ => (0.72, 0.9),
  };
  int arrondi(double v) => (v / 500).round() * 500;
  return (arrondi(prix * b), arrondi(prix * h));
}
