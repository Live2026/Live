import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';

part 'recherche.dart';

/// E-EXP-01 — Explorer : les 4 espaces, puis les meilleures annonces de chacun.
class EcranExplorer extends StatelessWidget {
  const EcranExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    final espaces = [
      (
        Icons.shopping_bag_rounded,
        'Market',
        'Acheter et vendre',
        '/market',
        const Color(0xFF13385C),
      ),
      (
        Icons.home_work_rounded,
        'Immo',
        'Louer, acheter',
        '/immo',
        const Color(0xFF166534),
      ),
      (
        Icons.handyman_rounded,
        'Services',
        'Trouver un pro',
        '/services',
        const Color(0xFF0369A1),
      ),
      (
        Icons.auto_awesome_rounded,
        'Live IA',
        'CV, exercices, business plan',
        '/ia',
        const Color(0xFFB45309),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: marge,
        title: TextField(
          readOnly: true,
          onTap: () => context.push('/recherche'),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Rechercher sur Live…',
          ),
        ),
        actions: const [BoutonMessages()],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(marge, 8, marge, 0),
            child: GrilleAdaptative(
              largeurMax: 260,
              espacement: 10,
              hauteur: 116,
              enfants: [
                for (final (i, (icone, titre, sous, route, couleur))
                    in espaces.indexed)
                  Apparition(
                    rang: i,
                    child: _Espace(
                      icone: icone,
                      titre: titre,
                      sous: sous,
                      couleur: couleur,
                      onTap: () => route == '/ia'
                          ? context.go(route)
                          : context.push(route),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(
              'Bonnes affaires près de vous',
              onTap: () => context.push('/market'),
            ),
          ),
          Carrousel(
            largeur: 160,
            hauteur: 250,
            marge: marge,
            enfants: [
              for (final p in produits.take(8))
                CarteProduit(produit: p, hero: false),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(
              'Nouveaux logements vérifiés',
              onTap: () => context.push('/immo'),
            ),
          ),
          Carrousel(
            largeur: 230,
            hauteur: 276,
            marge: marge,
            enfants: [
              for (final b in biens.take(8)) CarteBien(bien: b, hero: false),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(
              "Pros disponibles aujourd'hui",
              onTap: () => context.push('/services'),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: GrilleAdaptative(
              largeurMax: 460,
              espacement: 10,
              enfants: [for (final s in prestataires.take(4)) CartePro(pro: s)],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tuile d'un espace : même taille pour les quatre.
class _Espace extends StatelessWidget {
  const _Espace({
    required this.icone,
    required this.titre,
    required this.sous,
    required this.couleur,
    required this.onTap,
  });
  final IconData icone;
  final String titre;
  final String sous;
  final Color couleur;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$titre, $sous',
      excludeSemantics: true,
      child: Pressable(
        onTap: onTap,
        child: Bloc(
          padding: 12,
          child: LayoutBuilder(
            builder: (context, c) {
              final pastille = Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: couleur.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icone, color: couleur),
              );
              final textes = [
                Text(
                  titre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                Text(
                  sous,
                  maxLines: c.maxWidth < 170 ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: LiveColors.gris,
                  ),
                ),
              ];
              // Tuile étroite (petit téléphone) : icône au-dessus du texte.
              if (c.maxWidth < 170) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [pastille, const Spacer(), ...textes],
                );
              }
              return Row(
                children: [
                  pastille,
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: textes,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
