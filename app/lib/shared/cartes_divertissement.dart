import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/format.dart';
import '../core/theme.dart';
import '../data/mock.dart';
import 'animations.dart';
import 'composants.dart';
import 'medias.dart';
import '../l10n/textes.dart';

/// Vignette verticale d'un direct : pastille EN DIRECT, spectateurs, hôte.
class CarteDirect extends StatelessWidget {
  const CarteDirect({super.key, required this.direct});
  final Direct direct;

  @override
  Widget build(BuildContext context) {
    final d = direct;
    return Semantics(
      button: true,
      label: context.t.carteDirectDe(d.hote.nom, d.titre),
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push('/direct/${d.id}'),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Vignette(
                couleur: d.couleur,
                icone: Icons.videocam_rounded,
                rayon: 0,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xCC000000)],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                right: 8,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: PastilleDirect(spectateurs: d.spectateurs),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.titre,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Avatar(
                          nom: d.hote.nom,
                          couleur: d.hote.couleur,
                          taille: 24,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            d.hote.nom,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ),
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

/// Pastille rouge « EN DIRECT » qui pulse doucement.
class PastilleDirect extends StatelessWidget {
  const PastilleDirect({super.key, this.spectateurs, this.libelle});
  final int? spectateurs;

  /// Mot après le nombre, par exemple « directs ».
  final String? libelle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFE2C55),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, size: 7, color: Colors.white),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              spectateurs == null
                  ? context.t.carteEnDirect
                  : context.t.carteEnDirectSpectateurs(
                      compact(spectateurs!),
                      libelle == null ? '' : ' $libelle',
                    ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte d'un séjour meublé : même format que les cartes de biens.
class CarteSejour extends StatelessWidget {
  const CarteSejour({super.key, required this.sejour});
  final Sejour sejour;

  @override
  Widget build(BuildContext context) {
    final s = sejour;
    return Semantics(
      button: true,
      label: '${s.titre}, ${context.t.carteLaNuit(fcfa(s.nuit))}',
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push('/sejour/${s.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Vignette(couleur: s.couleur, icone: Icons.king_bed_rounded),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Etiquette(
                      context.t.carteNVoyageurs(s.voyageurs),
                      icone: Icons.people_alt_rounded,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Etiquette(
                      note(s.note).replaceAll('/5', ''),
                      icone: Icons.star_rounded,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              s.titre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              '${s.quartier} · ${s.hote.nom}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: LiveColors.gris, fontSize: 12.5),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: fcfa(s.nuit),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: context.t.carteLaNuitSuffixe,
                    style: TextStyle(color: LiveColors.gris),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
