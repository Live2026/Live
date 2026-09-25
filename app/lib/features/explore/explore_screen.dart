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
part 'explore_espace.dart';

/// Les espaces de Live, dans l'ordre de la barre de recherche mentale :
/// acheter, se loger, se faire aider, se divertir, apprendre, travailler.
const _espaces = [
  (
    Icons.shopping_bag_rounded,
    'Market',
    'Acheter et vendre',
    '/market',
    Color(0xFF13385C),
  ),
  (
    Icons.home_work_rounded,
    'Immo',
    'Louer, acheter',
    '/immo',
    Color(0xFF166534),
  ),
  (
    Icons.king_bed_rounded,
    'Séjours',
    'À la nuit, meublé',
    '/sejours',
    Color(0xFF9D174D),
  ),
  (
    Icons.handyman_rounded,
    'Services',
    'Trouver un pro',
    '/services',
    Color(0xFF0369A1),
  ),
  (
    Icons.podcasts_rounded,
    'Directs',
    'Acheter en direct',
    '/directs',
    Color(0xFFDB2777),
  ),
  (
    Icons.auto_awesome_rounded,
    'Live IA',
    'CV, exercices, business plan',
    '/ia',
    Color(0xFFB45309),
  ),
  (
    Icons.school_rounded,
    'Savoir',
    'Cours, PDF, vidéos',
    '/apprendre',
    Color(0xFF6D28D9),
  ),
  (
    Icons.work_rounded,
    'Emploi',
    'Bourses, stages, emplois',
    '/opportunites',
    Color(0xFF0F766E),
  ),
];

/// Outils de Live utiles à tous, rangés après les espaces.
const _outils = [
  (
    Icons.groups_rounded,
    'Groupes et canaux',
    'Quartier, classe, passion',
    '/groupe/g1',
    Color(0xFF1D4ED8),
  ),
  (
    Icons.two_wheeler_rounded,
    'Live Livraison',
    'Courses à moto',
    '/livraison/LV-00482',
    Color(0xFFC2410C),
  ),
  (
    Icons.insights_rounded,
    'Studio créateur',
    'Cadeaux, fans, statistiques',
    '/studio',
    Color(0xFFDB2777),
  ),
  (
    Icons.bolt_rounded,
    'Live Plus',
    'Crédits IA chaque mois',
    '/live-plus',
    Color(0xFFB45309),
  ),
  (
    Icons.campaign_rounded,
    'Publicité',
    'Vidéo sponsorisée',
    '/publicite',
    Color(0xFF13385C),
  ),
  (
    Icons.workspace_premium_rounded,
    'Offres Pro',
    'Vendeur, agence, pro',
    '/live-pro/offres',
    Color(0xFF166534),
  ),
  (
    Icons.account_balance_rounded,
    'Services financiers',
    '3 fois, épargne, crédit',
    '/finance',
    Color(0xFF0F766E),
  ),
  (
    Icons.volunteer_activism_rounded,
    'Fonds Créateurs',
    'Financé par la publicité',
    '/fonds-createurs',
    Color(0xFF6D28D9),
  ),
];

/// E-EXP-01 — Explorer : tous les espaces de Live, puis le meilleur de chacun.
class EcranExplorer extends ConsumerWidget {
  const EcranExplorer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    final biblio = ref.watch(liveProvider.select((e) => e.bibliotheque));
    Widget titre(String texte, String route) => Padding(
      padding: EdgeInsets.symmetric(horizontal: marge),
      child: EnTeteSection(texte, onTap: () => context.push(route)),
    );
    Widget grille(
      List<(IconData, String, String, String, Color)> liste,
    ) => Padding(
      padding: EdgeInsets.fromLTRB(marge, 8, marge, 0),
      child: GrilleAdaptative(
        largeurMax: 260,
        espacement: 10,
        hauteur: 116,
        enfants: [
          for (final (i, (icone, titre, sous, route, couleur)) in liste.indexed)
            Apparition(
              rang: i,
              child: _Espace(
                icone: icone,
                titre: titre,
                sous: sous,
                couleur: couleur,
                onTap: () =>
                    route == '/ia' ? context.go(route) : context.push(route),
              ),
            ),
        ],
      ),
    );
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
          grille(_espaces),
          titre('En direct maintenant', '/directs'),
          Carrousel(
            largeur: 150,
            hauteur: 240,
            marge: marge,
            enfants: [
              for (final d in directs.where((d) => d.enCours))
                CarteDirect(direct: d),
            ],
          ),
          titre('Bonnes affaires près de vous', '/market'),
          Carrousel(
            largeur: 160,
            hauteur: 250,
            marge: marge,
            enfants: [
              for (final p in produits.take(8))
                CarteProduit(produit: p, hero: false),
            ],
          ),
          titre('Nouveaux logements vérifiés', '/immo'),
          Carrousel(
            largeur: 230,
            hauteur: 276,
            marge: marge,
            enfants: [
              for (final b in biens.take(8)) CarteBien(bien: b, hero: false),
            ],
          ),
          titre('Pour quelques nuits', '/sejours'),
          Carrousel(
            largeur: 230,
            hauteur: 250,
            marge: marge,
            enfants: [for (final s in sejours) CarteSejour(sejour: s)],
          ),
          titre("Pros disponibles aujourd'hui", '/services'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: GrilleAdaptative(
              largeurMax: 460,
              espacement: 10,
              enfants: [for (final s in prestataires.take(4)) CartePro(pro: s)],
            ),
          ),
          titre('Apprendre avec Live Savoir', '/apprendre'),
          Carrousel(
            largeur: 220,
            hauteur: 236,
            marge: marge,
            enfants: [
              for (final c in contenus.take(6))
                CarteContenu(contenu: c, achete: biblio.contains(c.id)),
            ],
          ),
          titre('Opportunités à saisir', '/opportunites'),
          Carrousel(
            largeur: 300,
            hauteur: 168,
            marge: marge,
            enfants: [
              for (final o in opportunites) CarteOpportunite(opportunite: o),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: const EnTeteSection('Outils et services Live'),
          ),
          grille(_outils),
        ],
      ),
    );
  }
}
