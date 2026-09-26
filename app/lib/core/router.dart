import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/store.dart';
import '../features/admin/admin_screens.dart';
import '../features/aide/aide_screens.dart';
import '../features/apprendre/apprendre_screens.dart';
import '../features/auth/auth_screens.dart';
import '../features/compte/compte_screens.dart';
import '../features/confiance/confiance_screens.dart';
import '../features/createurs/createurs_screens.dart';
import '../features/croissance/croissance_screens.dart';
import '../features/direct/direct_screens.dart';
import '../features/expansion/expansion_screens.dart';
import '../features/explore/explore_screen.dart';
import '../features/feed/feed_screen.dart';
import '../features/ia/ia_screens.dart';
import '../features/immo/immo_screens.dart';
import '../features/market/market_screens.dart';
import '../features/messages/messages_screens.dart';
import '../features/opportunites/opportunites_screens.dart';
import '../features/pay/pay_screens.dart';
import '../features/piliers/piliers_screens.dart';
import '../features/publish/publish_screen.dart';
import '../features/services/services_screens.dart';
import '../features/social/social_screens.dart';
import '../features/test/scenarios_screen.dart';
import 'cadre_demarrage.dart';
import 'navigation.dart';

/// Démarrage : sur ordinateur, page blanche et colonne centrée façon
/// WhatsApp (CadreDemarrage).
const _demarrage = {
  '/langue',
  '/telephone',
  '/connexion',
  '/connexion/qr',
  '/code',
  '/profil',
  '/interets',
  '/pin',
};

/// Pages qui occupent tout l'écran, même sur ordinateur : accueil (motif
/// plein écran), back-office (qui a sa propre barre), caméra, direct et
/// lecteur.
bool _pleinEcran(String chemin) =>
    const {
      '/demarrage',
      '/bienvenue',
      '/publier/media',
      '/direct/:id',
      '/lecteur/:id',
    }.contains(chemin) ||
    chemin.startsWith('/admin');

GoRoute _route(
  String chemin,
  Widget Function(GoRouterState s) ecran, {
  bool cadre = true,
}) => GoRoute(
  path: chemin,
  builder: (_, s) => _demarrage.contains(chemin)
      ? CadreDemarrage(
          chemin: chemin,
          largeur: chemin == '/connexion/qr' ? 760 : 460,
          child: ecran(s),
        )
      : !cadre || _pleinEcran(chemin)
      ? ecran(s)
      : CadreOrdinateur(chemin: s.uri.path, child: ecran(s)),
);

String _p(GoRouterState s, String nom) => s.pathParameters[nom]!;

final routeur = GoRouter(
  initialLocation: '/demarrage',
  routes: [
    // Démarrage et compte
    _route('/demarrage', (_) => const EcranSplash()),
    _route('/bienvenue', (_) => const EcranBienvenue()),
    _route('/langue', (_) => const EcranLangue()),
    _route('/telephone', (_) => const EcranTelephone()),
    _route('/connexion/qr', (_) => const EcranConnexionQr()),
    _route('/connexion', (_) => const EcranConnexion()),
    _route('/code', (s) {
      final (tel, op) = s.extra as (String, String)? ?? ('06 123 45 67', 'MTN');
      return EcranCode(telephone: tel, operateur: op);
    }),
    _route('/profil', (s) {
      final (tel, op) = s.extra as (String, String)? ?? ('06 123 45 67', 'MTN');
      return EcranProfil(telephone: tel, operateur: op);
    }),
    _route('/interets', (_) => const EcranInterets()),
    _route('/pin', (s) {
      final (prenom, tel, op) =
          s.extra as (String, String, String)? ??
          ('Grâce', '06 123 45 67', 'MTN');
      return EcranPin(prenom: prenom, telephone: tel, operateur: op);
    }),
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => NavigationPrincipale(shell: shell),
      branches: [
        for (final (chemin, ecran) in <(String, Widget)>[
          ('/accueil', const EcranFil()),
          ('/explorer', const EcranExplorer()),
          ('/publier', const EcranPublier()),
          ('/ia', const EcranIa()),
          ('/moi', const EcranMoi()),
        ])
          StatefulShellBranch(
            routes: [_route(chemin, (_) => ecran, cadre: false)],
          ),
      ],
    ),
    // Super-pouvoirs, profil et réglages
    _route('/pouvoirs', (_) => const EcranPouvoirs()),
    _route('/live-pro', (_) => const EcranPro()),
    _route('/verifier', (_) => const EcranVerifier()),
    _route('/espace/nouveau', (_) => const EcranCreerEspace()),
    _route('/espace/equipe', (_) => const EcranEquipe()),
    _route('/profil/:id', (s) => EcranProfilPublic(id: _p(s, 'id'))),
    _route('/boutique/:id', (s) => EcranBoutique(id: _p(s, 'id'))),
    _route('/parametres', (_) => const EcranParametres()),
    _route('/aide', (_) => const EcranAide()),
    _route(
      '/aide/ecrire',
      (s) => EcranEcrireSupport(sujet: s.uri.queryParameters['sujet']),
    ),
    _route('/aide/demandes', (_) => const EcranDemandesSupport()),
    _route('/legal/:type', (s) => EcranLegal(type: _p(s, 'type'))),
    _route('/notifications', (_) => const EcranNotifications()),
    _route('/notifications/preferences', (_) => const EcranPreferencesNotif()),
    _route('/donnees', (_) => const EcranDonnees()),
    _route('/paiements', (_) => const EcranGuidePaiements()),
    _route(
      '/abonnes/:id',
      (s) => EcranAbonnes(
        id: _p(s, 'id'),
        onglet: int.tryParse(s.uri.queryParameters['onglet'] ?? '') ?? 0,
      ),
    ),
    _route('/suivis', (_) => const EcranSuivis()),
    _route('/bloques', (_) => const EcranBloques()),
    _route('/enregistres', (_) => const EcranEnregistres()),
    // Recherche
    _route('/recherche', (s) => EcranRecherche(initiale: s.extra as String?)),
    _route('/alertes', (_) => const EcranAlertes()),
    _route(
      '/rue',
      (s) => EcranVueRue(lieu: s.uri.queryParameters['lieu'] ?? 'Brazzaville'),
    ),
    _route(
      '/carte',
      (s) => EcranCarte(espace: s.uri.queryParameters['espace'] ?? 'immo'),
    ),
    // Market
    _route('/market', (_) => const EcranMarket()),
    _route(
      '/market/liste',
      (s) => EcranListeMarket(
        categorie: s.uri.queryParameters['categorie'],
        tri: int.tryParse(s.uri.queryParameters['tri'] ?? '') ?? 0,
      ),
    ),
    _route('/commandes', (_) => const EcranMesCommandes()),
    _route('/produit/:id', (s) => EcranProduit(id: _p(s, 'id'))),
    _route(
      '/commande/:id',
      (s) => EcranCommande(
        id: _p(s, 'id'),
        variante: s.uri.queryParameters['variante'],
        quantite: int.tryParse(s.uri.queryParameters['qte'] ?? '') ?? 1,
      ),
    ),
    _route('/suivi/:id', (s) => EcranSuiviCommande(id: _p(s, 'id'))),
    _route('/vendre', (_) => const EcranVendre()),
    _route('/mes-ventes', (_) => const EcranMesVentes()),
    _route('/vente/:id', (s) => EcranRemise(id: _p(s, 'id'))),
    _route('/vente/:id/qr', (s) => EcranQrPaiement(id: _p(s, 'id'))),
    // Phase 2 : Live Direct
    _route('/directs', (_) => const EcranDirects()),
    _route('/direct/lancer', (_) => const EcranLancerDirect()),
    _route('/direct/:id', (s) => EcranDirect(id: _p(s, 'id'))),
    _route('/studio', (_) => const EcranStudio()),
    _route('/fans/:id', (s) => EcranFans(id: _p(s, 'id'))),
    _route('/sejours', (_) => const EcranSejours()),
    _route('/sejour/:id', (s) => EcranSejour(id: _p(s, 'id'))),
    _route('/live-plus', (_) => const EcranLivePlus()),
    _route('/publicite', (_) => const EcranPublicite()),
    _route('/live-pro/offres', (_) => const EcranOffresPro()),
    // Phase 3
    _route('/livraison/:id', (s) => EcranLivraison(id: _p(s, 'id'))),
    _route('/fonds-createurs', (_) => const EcranFondsCreateurs()),
    _route('/finance', (_) => const EcranFinance()),
    _route('/partenaires', (_) => const EcranPartenaires()),
    // Piliers « référence » (docs/21)
    _route('/tontines', (_) => const EcranTontines()),
    _route('/tontine/:id', (s) => EcranTontine(id: _p(s, 'id'))),
    _route('/achats-groupes', (_) => const EcranAchatsGroupes()),
    _route('/diaspora', (_) => const EcranDiaspora()),
    _route(
      '/transfert',
      (s) =>
          EcranTransfert(recevoir: s.uri.queryParameters['sens'] == 'recevoir'),
    ),
    _route('/factures', (_) => const EcranFactures()),
    _route('/adresse', (_) => const EcranAdresseLive()),
    _route('/points-relais', (_) => const EcranPointsRelais()),
    // Apprendre (contenus numériques)
    _route('/apprendre', (_) => const EcranApprendre()),
    _route('/apprendre/vendre', (_) => const EcranVendreContenu()),
    _route('/apprendre/boutique', (_) => const EcranBoutiqueSavoirs()),
    _route('/contenu/:id', (s) => EcranContenu(id: _p(s, 'id'))),
    _route('/lecteur/:id', (s) => EcranLecteur(id: _p(s, 'id'))),
    _route('/panier', (_) => const EcranPanier()),
    _route('/mes-achats', (_) => const EcranMesAchats()),
    // Opportunités
    _route('/opportunites', (_) => const EcranOpportunites()),
    _route('/opportunite/:id', (s) => EcranOpportunite(id: _p(s, 'id'))),
    _route('/opportunite/:id/postuler', (s) => EcranPostuler(id: _p(s, 'id'))),
    _route('/mes-candidatures', (_) => const EcranMesCandidatures()),
    _route('/publier/opportunite', (_) => const EcranPublierOpportunite()),
    // Immo
    _route('/immo', (_) => const EcranImmo()),
    _route('/bien/:id', (s) => EcranBien(id: _p(s, 'id'))),
    _route('/bien/:id/visite', (s) => EcranReserverVisite(id: _p(s, 'id'))),
    _route('/visite/:id', (s) => EcranVisite(id: _p(s, 'id'))),
    _route('/visite/:id/offre', (s) => EcranOffreReservation(id: _p(s, 'id'))),
    _route('/agence', (_) => const EcranAgence()),
    _route('/agence/visite/:id', (s) => EcranValiderVisite(id: _p(s, 'id'))),
    // Services
    _route('/services', (_) => const EcranServices()),
    _route('/services/demande', (_) => const EcranDemandeDevis()),
    _route('/services/devis', (_) => const EcranDevisRecus()),
    _route(
      '/services/devis/:id',
      (s) => EcranDetailDevis(prestataireId: _p(s, 'id')),
    ),
    _route('/prestation/:id', (s) => EcranPrestation(id: _p(s, 'id'))),
    _route('/pro/interventions', (_) => const EcranInterventions()),
    _route('/pro/devis/nouveau', (_) => const EcranCreerDevis()),
    _route('/pro/:id', (s) => EcranProfilPrestataire(id: _p(s, 'id'))),
    _route(
      '/pro/:id/reserver/:service',
      (s) => EcranServiceFixe(proId: _p(s, 'id'), serviceId: _p(s, 'service')),
    ),
    // Publier
    _route('/publier/media', (_) => const EcranPublierMedia()),
    _route('/publier/bien', (_) => const EcranPublierBien()),
    _route('/publier/service', (_) => const EcranProposerService()),
    _route('/publier/envois', (_) => const EcranEnvois()),
    // Confiance
    _route(
      '/avis/:type/:id',
      (s) => EcranAvis(type: _p(s, 'type'), id: _p(s, 'id')),
    ),
    _route(
      '/probleme/:type/:id',
      (s) => EcranProbleme(type: _p(s, 'type'), id: _p(s, 'id')),
    ),
    _route('/reclamation/:id', (s) => EcranReclamation(id: _p(s, 'id'))),
    // Live IA
    _route('/ia/credits', (_) => const EcranCredits()),
    _route('/ia/exercice', (_) => const EcranExercice()),
    _route('/ia/documents', (_) => const EcranMesDocuments()),
    _route('/ia/business-plan', (_) => const EcranBusinessPlan()),
    _route('/ia/assistant', (_) => const EcranAssistant()),
    _route('/ia/tuteur', (_) => const EcranTuteur()),
    _route('/ia/service/:id', (s) => EcranGenerateur(serviceId: _p(s, 'id'))),
    _route('/ia/document/:id', (s) => EcranDocument(id: _p(s, 'id'))),
    // Paiement et gains
    _route('/payer', (_) => const EcranPaiement()),
    _route(
      '/payer/attente',
      (s) => EcranAttente(moyen: s.extra as String? ?? 'MTN Mobile Money'),
    ),
    _route('/payer/ok', (s) {
      final (type, id, moyen) =
          s.extra as (TypePaiement, String, String)? ??
          (TypePaiement.commande, 'LV-00482', 'MTN Mobile Money');
      return EcranPaiementReussi(type: type, id: id, moyen: moyen);
    }),
    _route('/portefeuille', (_) => const EcranPortefeuille()),
    _route('/gains', (_) => const EcranGains()),
    _route('/retirer', (_) => const EcranRetrait()),
    _route('/recu/:id', (s) => EcranRecu(id: _p(s, 'id'))),
    // Messages
    _route('/messages', (_) => const EcranMessages()),
    _route('/conversation', (_) => const EcranConversation()),
    _route('/groupe/:id', (s) => EcranGroupe(id: _p(s, 'id'))),
    _route('/messages/demandes', (_) => const EcranDemandes()),
    _route('/messages/archives', (_) => const EcranArchives()),
    _route('/messages/parametres', (_) => const EcranReglagesMessages()),
    // Back-office (outil interne, sur ordinateur)
    _route('/admin', (_) => const EcranAdmin(section: 0)),
    _route('/admin/kyc', (_) => const EcranAdmin(section: 1)),
    _route('/admin/kyc/:id', (s) => EcranDossierKyc(id: _p(s, 'id'))),
    _route('/admin/moderation', (_) => const EcranAdmin(section: 2)),
    _route('/admin/litiges', (_) => const EcranAdmin(section: 3)),
    _route('/admin/litiges/:id', (s) => EcranLitige(id: _p(s, 'id'))),
    _route('/admin/finance', (_) => const EcranAdmin(section: 4)),
    _route('/admin/quotidien', (_) => const EcranAdmin(section: 5)),
    _route('/admin/ia', (_) => const EcranAdmin(section: 6)),
    _route('/admin/utilisateurs', (_) => const EcranAdmin(section: 7)),
    _route(
      '/admin/utilisateurs/:id',
      (s) => EcranFicheUtilisateur(id: _p(s, 'id')),
    ),
    _route('/admin/configuration', (_) => const EcranAdmin(section: 8)),
    _route('/admin/validations', (_) => const EcranAdmin(section: 9)),
    _route('/admin/journal', (_) => const EcranAdmin(section: 10)),
    _route('/admin/equipe', (_) => const EcranAdmin(section: 11)),
    _route('/admin/connexion', (_) => const EcranConnexionAdmin()),
    _route('/scenarios', (_) => const EcranScenarios()),
  ],
);
