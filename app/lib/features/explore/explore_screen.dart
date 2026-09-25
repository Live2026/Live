import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/widgets.dart';

part 'recherche.dart';
part 'carte.dart';

/// Modules des phases suivantes (document 04, section 5), en aperçu.
const _prochainement = [
  (
    Icons.podcasts_rounded,
    'Live Direct',
    'Phase 2 · vendre en direct',
    '/directs',
  ),
  (
    Icons.insights_rounded,
    'Studio créateur',
    'Phase 2 · cadeaux, fans',
    '/studio',
  ),
  (
    Icons.king_bed_rounded,
    'Séjours meublés',
    'Phase 2 · à la nuit',
    '/sejours',
  ),
  (
    Icons.groups_rounded,
    'Groupes et canaux',
    'Phase 2 · quartier, classe',
    '/groupe/g1',
  ),
  (
    Icons.bolt_rounded,
    'Live Plus',
    'Phase 2 · crédits IA chaque mois',
    '/live-plus',
  ),
  (
    Icons.campaign_rounded,
    'Publicité',
    'Phase 2 · vidéo sponsorisée',
    '/publicite',
  ),
  (
    Icons.workspace_premium_rounded,
    'Offres Pro',
    'Phase 2 · vendeur, agence, pro',
    '/live-pro/offres',
  ),
  (
    Icons.school_rounded,
    'Live Savoir',
    'Phase 3 · cours, PDF, vidéos',
    '/apprendre',
  ),
  (
    Icons.work_rounded,
    'Live Emploi',
    'Phase 3 · bourses, stages, emplois',
    '/opportunites',
  ),
  (
    Icons.two_wheeler_rounded,
    'Live Livraison',
    'Phase 3 · courses à moto',
    '/livraison/LV-00482',
  ),
  (
    Icons.volunteer_activism_rounded,
    'Fonds Créateurs',
    'Phase 3 · financé par la pub',
    '/fonds-createurs',
  ),
  (
    Icons.account_balance_rounded,
    'Services financiers',
    'Phase 3 · 3 fois, épargne, crédit',
    '/finance',
  ),
];

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
        actions: const [BoutonNotifications(), BoutonMessages()],
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: const EnTeteSection('Bientôt sur Live'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: GrilleAdaptative(
              largeurMax: 260,
              espacement: 10,
              hauteur: 116,
              enfants: [
                for (final (i, (icone, titre, sous, route))
                    in _prochainement.indexed)
                  Apparition(
                    rang: i,
                    child: _Espace(
                      icone: icone,
                      titre: titre,
                      sous: sous,
                      couleur: sous.startsWith('Phase 2')
                          ? const Color(0xFFDB2777)
                          : const Color(0xFF6D28D9),
                      onTap: () => context.push(route),
                    ),
                  ),
              ],
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
