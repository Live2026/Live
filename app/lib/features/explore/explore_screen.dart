import 'dart:math' as math;

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
import '../../l10n/textes.dart';

part 'recherche.dart';
part 'carte.dart';
part 'explore_espace.dart';
part 'vue_rue.dart';

/// Les espaces de Live, dans l'ordre de la barre de recherche mentale :
/// acheter, se loger, se faire aider, se divertir, apprendre, travailler.
List<(IconData, String, String, String, Color)> _espaces(Textes t) => [
  (
    Icons.shopping_bag_rounded,
    'Market',
    t.acheterEtVendre,
    '/market',
    Color(0xFF13385C),
  ),
  (Icons.home_work_rounded, 'Immo', t.louerAcheter, '/immo', Color(0xFF166534)),
  (
    Icons.king_bed_rounded,
    t.sejours,
    t.aLaNuitMeuble,
    '/sejours',
    Color(0xFF9D174D),
  ),
  (
    Icons.handyman_rounded,
    t.services,
    t.trouverUnPro,
    '/services',
    Color(0xFF0369A1),
  ),
  (
    Icons.podcasts_rounded,
    t.directs,
    t.acheterEnDirect,
    '/directs',
    Color(0xFFDB2777),
  ),
  (
    Icons.auto_awesome_rounded,
    'Live IA',
    t.cvExercicesBusinessPlan,
    '/ia',
    Color(0xFFB45309),
  ),
  (
    Icons.school_rounded,
    t.savoir,
    t.coursPdfVideos,
    '/apprendre',
    Color(0xFF6D28D9),
  ),
  (
    Icons.work_rounded,
    t.emploi,
    t.boursesStagesEmplois,
    '/opportunites',
    Color(0xFF0F766E),
  ),
];

/// Argent et quotidien : ce qu'on ouvre chaque semaine (docs/21).
List<(IconData, String, String, String, Color)> _quotidien(Textes t) => [
  (
    Icons.account_balance_wallet_rounded,
    t.monArgent,
    t.soldeSequestreHistorique,
    '/portefeuille',
    Color(0xFF1D4ED8),
  ),
  (
    Icons.diversity_3_rounded,
    t.tontines,
    t.cotiserEtRecevoirSansRetard,
    '/tontines',
    Color(0xFFDB2777),
  ),
  (
    Icons.receipt_long_rounded,
    t.facturesEtCredit,
    t.electriciteEauTeleRecharge,
    '/factures',
    Color(0xFFCA8A04),
  ),
  (
    Icons.flight_land_rounded,
    t.diaspora,
    t.payerPourUnProcheEnvoyer,
    '/diaspora',
    Color(0xFF0369A1),
  ),
  (
    Icons.currency_exchange_rounded,
    'Live Transfert',
    t.envoyerRecevoirToutesDevises,
    '/transfert',
    Color(0xFF0F766E),
  ),
  (
    Icons.groups_2_rounded,
    t.achatsGroupes,
    t.aPlusieursPrixDeGros,
    '/achats-groupes',
    Color(0xFFB45309),
  ),
  (
    Icons.pin_drop_rounded,
    t.adresseLive,
    t.votreAdresseEnUnCode,
    '/adresse',
    Color(0xFF1D4ED8),
  ),
  (
    Icons.storefront_rounded,
    t.pointsRelais,
    t.colisEspecesEnMomo,
    '/points-relais',
    Color(0xFF15803D),
  ),
];

/// Outils de Live utiles à tous, rangés après les espaces.
List<(IconData, String, String, String, Color)> _outils(Textes t) => [
  (
    Icons.groups_rounded,
    t.groupesEtCanaux,
    t.quartierClassePassion,
    '/groupe/g1',
    Color(0xFF1D4ED8),
  ),
  (
    Icons.two_wheeler_rounded,
    'Live Livraison',
    t.coursesAMoto,
    '/livraison/LV-00482',
    Color(0xFFC2410C),
  ),
  (
    Icons.insights_rounded,
    t.studioCreateur,
    t.cadeauxFansStatistiques,
    '/studio',
    Color(0xFFDB2777),
  ),
  (
    Icons.bolt_rounded,
    'Live Plus',
    t.creditsIaChaqueMois,
    '/live-plus',
    Color(0xFFB45309),
  ),
  (
    Icons.campaign_rounded,
    t.publicite,
    t.videoSponsorisee,
    '/publicite',
    Color(0xFF13385C),
  ),
  (
    Icons.workspace_premium_rounded,
    t.offresPro,
    t.vendeurAgencePro,
    '/live-pro/offres',
    Color(0xFF166534),
  ),
  (
    Icons.account_balance_rounded,
    t.servicesFinanciers,
    t.n3FoisEpargneCredit,
    '/finance',
    Color(0xFF0F766E),
  ),
  (
    Icons.volunteer_activism_rounded,
    t.fondsCreateurs,
    t.financeParLaPublicite,
    '/fonds-createurs',
    Color(0xFF6D28D9),
  ),
];

/// E-EXP-01 — Explorer : tous les espaces de Live, puis le meilleur de chacun.
class EcranExplorer extends ConsumerWidget {
  const EcranExplorer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
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
      appBar: EnTeteRecherche(
        titleSpacing: marge,
        titre: Text(
          t.ongletExplorer,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        indice: t.rechercherSurLive,
        onSubmitted: (q) => context.push('/recherche', extra: q),
        actions: const [BoutonNotifications(), BoutonMessages()],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          grille(_espaces(context.t)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(t.argentEtQuotidien),
          ),
          grille(_quotidien(context.t)),
          titre(t.enDirectMaintenant, '/directs'),
          Carrousel(
            largeur: 150,
            hauteur: 240,
            marge: marge,
            enfants: [
              for (final d in directs.where((d) => d.enCours))
                CarteDirect(direct: d),
            ],
          ),
          titre(t.bonnesAffairesPresDeVous, '/market'),
          Carrousel(
            largeur: 160,
            hauteur: 250,
            marge: marge,
            enfants: [
              for (final p in produits.take(8))
                CarteProduit(produit: p, hero: false),
            ],
          ),
          titre(t.nouveauxLogementsVerifies, '/immo'),
          Carrousel(
            largeur: 230,
            hauteur: 276,
            marge: marge,
            enfants: [
              for (final b in biens.take(8)) CarteBien(bien: b, hero: false),
            ],
          ),
          titre(t.pourQuelquesNuits, '/sejours'),
          Carrousel(
            largeur: 230,
            hauteur: 250,
            marge: marge,
            enfants: [for (final s in sejours) CarteSejour(sejour: s)],
          ),
          titre(t.prosDisponiblesAujourdHui, '/services'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: GrilleAdaptative(
              largeurMax: 460,
              espacement: 10,
              enfants: [for (final s in prestataires.take(4)) CartePro(pro: s)],
            ),
          ),
          titre(t.apprendreAvecLiveSavoir, '/apprendre'),
          Carrousel(
            largeur: 220,
            hauteur: 236,
            marge: marge,
            enfants: [
              for (final c in contenus.take(6))
                CarteContenu(contenu: c, achete: biblio.contains(c.id)),
            ],
          ),
          titre(t.opportunitesASaisir, '/opportunites'),
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
            child: EnTeteSection(t.outilsEtServicesLive),
          ),
          grille(_outils(context.t)),
        ],
      ),
    );
  }
}
