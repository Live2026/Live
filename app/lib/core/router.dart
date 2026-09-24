import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/store.dart';
import '../features/auth/auth_screens.dart';
import '../features/explore/explore_screen.dart';
import '../features/feed/feed_screen.dart';
import '../features/ia/ia_screens.dart';
import '../features/immo/immo_screens.dart';
import '../features/market/market_screens.dart';
import '../features/me/me_screen.dart';
import '../features/messages/messages_screens.dart';
import '../features/pay/pay_screens.dart';
import '../features/publish/publish_screen.dart';
import '../features/services/services_screens.dart';
import '../features/test/scenarios_screen.dart';
import 'adaptatif.dart';

GoRoute _route(String chemin, Widget Function(GoRouterState s) ecran) =>
    GoRoute(path: chemin, builder: (_, s) => ecran(s));

final routeur = GoRouter(
  initialLocation: '/bienvenue',
  routes: [
    _route('/bienvenue', (_) => const EcranBienvenue()),
    _route('/telephone', (_) => const EcranTelephone()),
    _route('/code', (s) {
      final (tel, op) = s.extra as (String, String)? ?? ('06 123 45 67', 'MTN');
      return EcranCode(telephone: tel, operateur: op);
    }),
    _route('/profil', (s) {
      final (tel, op) = s.extra as (String, String)? ?? ('06 123 45 67', 'MTN');
      return EcranProfil(telephone: tel, operateur: op);
    }),
    _route('/pin', (s) {
      final (prenom, tel, op) =
          s.extra as (String, String, String)? ??
          ('Grâce', '06 123 45 67', 'MTN');
      return EcranPin(prenom: prenom, telephone: tel, operateur: op);
    }),
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => _Navigation(shell: shell),
      branches: [
        for (final (chemin, ecran) in <(String, Widget)>[
          ('/accueil', const EcranFil()),
          ('/explorer', const EcranExplorer()),
          ('/publier', const EcranPublier()),
          ('/ia', const EcranIa()),
          ('/moi', const EcranMoi()),
        ])
          StatefulShellBranch(routes: [_route(chemin, (_) => ecran)]),
      ],
    ),
    // Market
    _route('/recherche', (_) => const EcranRecherche()),
    _route('/produit/:id', (s) => EcranProduit(id: s.pathParameters['id']!)),
    _route('/commande/:id', (s) => EcranCommande(id: s.pathParameters['id']!)),
    _route(
      '/suivi/:id',
      (s) => EcranSuiviCommande(id: s.pathParameters['id']!),
    ),
    _route('/vendre', (_) => const EcranVendre()),
    _route('/mes-ventes', (_) => const EcranMesVentes()),
    _route('/vente/:id', (s) => EcranRemise(id: s.pathParameters['id']!)),
    // Immo
    _route('/immo', (_) => const EcranImmo()),
    _route('/bien/:id', (s) => EcranBien(id: s.pathParameters['id']!)),
    _route(
      '/bien/:id/visite',
      (s) => EcranReserverVisite(id: s.pathParameters['id']!),
    ),
    _route('/visite/:id', (s) => EcranVisite(id: s.pathParameters['id']!)),
    // Services
    _route('/services', (_) => const EcranServices()),
    _route('/services/demande', (_) => const EcranDemandeDevis()),
    _route('/services/devis', (_) => const EcranDevisRecus()),
    _route(
      '/services/devis/:id',
      (s) => EcranDetailDevis(prestataireId: s.pathParameters['id']!),
    ),
    _route(
      '/prestation/:id',
      (s) => EcranPrestation(id: s.pathParameters['id']!),
    ),
    // Live IA
    _route('/ia/credits', (_) => const EcranCredits()),
    _route('/ia/exercice', (_) => const EcranExercice()),
    _route('/ia/documents', (_) => const EcranMesDocuments()),
    _route(
      '/ia/service/:id',
      (s) => EcranGenerateur(serviceId: s.pathParameters['id']!),
    ),
    _route(
      '/ia/document/:id',
      (s) => EcranDocument(id: s.pathParameters['id']!),
    ),
    // Paiement et gains
    _route('/payer', (_) => const EcranPaiement()),
    _route(
      '/payer/attente',
      (s) => EcranAttente(moyen: s.extra as String? ?? 'MTN Mobile Money'),
    ),
    _route('/payer/ok', (s) {
      final (type, id, moyen) = s.extra! as (TypePaiement, String, String);
      return EcranPaiementReussi(type: type, id: id, moyen: moyen);
    }),
    _route('/gains', (_) => const EcranGains()),
    _route('/retirer', (_) => const EcranRetrait()),
    // Messages (icône en haut des écrans principaux)
    _route('/messages', (_) => const EcranMessages()),
    _route('/conversation', (_) => const EcranConversation()),
    _route('/scenarios', (_) => const EcranScenarios()),
  ],
);

/// Navigation principale adaptative (docs/ecrans/00, section 8) :
/// barre d'onglets en bas sur téléphone, rail à gauche sur grand écran.
class _Navigation extends StatelessWidget {
  const _Navigation({required this.shell});
  final StatefulNavigationShell shell;

  static const _onglets = [
    (Icons.home_outlined, Icons.home, 'Accueil'),
    (Icons.search, Icons.search, 'Explorer'),
    (Icons.add_circle_outline, Icons.add_circle, 'Publier'),
    (Icons.auto_awesome_outlined, Icons.auto_awesome, 'IA'),
    (Icons.person_outline, Icons.person, 'Moi'),
  ];

  void _aller(int i) =>
      shell.goBranch(i, initialLocation: i == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final taille = context.taille;
    if (taille == Taille.compacte) {
      return Scaffold(
        body: shell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: _aller,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            for (final (icone, active, libelle) in _onglets)
              NavigationDestination(
                icon: Icon(icone),
                selectedIcon: Icon(active),
                label: libelle,
              ),
          ],
        ),
      );
    }
    final etendu = taille == Taille.etendue;
    return Scaffold(
      body: Row(
        children: [
          _BarreLaterale(
            etendue: etendu,
            selection: shell.currentIndex,
            onglets: _onglets,
            onTap: _aller,
          ),
          const VerticalDivider(width: 1),
          // Conteneur d'accessibilité propre : sans lui, la barrière modale des
          // pages masque la barre latérale (dessinée avant) aux lecteurs d'écran.
          Expanded(
            child: Semantics(
              container: true,
              explicitChildNodes: true,
              child: shell,
            ),
          ),
        ],
      ),
    );
  }
}

/// Barre latérale des grands écrans (remplace NavigationRail, dont les éléments
/// n'étaient pas exposés aux lecteurs d'écran sur le web).
class _BarreLaterale extends StatelessWidget {
  const _BarreLaterale({
    required this.etendue,
    required this.selection,
    required this.onglets,
    required this.onTap,
  });
  final bool etendue;
  final int selection;
  final List<(IconData, IconData, String)> onglets;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bleu = Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: etendue ? 220 : 88,
      child: Material(
        color: Colors.white,
        child: SafeArea(
          right: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(etendue ? 24 : 0, 20, 0, 24),
                child: Text(
                  'LIVE',
                  textAlign: etendue ? TextAlign.start : TextAlign.center,
                  style: TextStyle(
                    fontSize: etendue ? 26 : 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    color: bleu,
                  ),
                ),
              ),
              for (final (i, (icone, active, libelle)) in onglets.indexed)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  child: Material(
                    color: i == selection
                        ? const Color(0xFFE6EBF2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => onTap(i),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: etendue ? 14 : 0,
                          vertical: etendue ? 12 : 10,
                        ),
                        child: etendue
                            ? Row(
                                children: [
                                  Icon(
                                    i == selection ? active : icone,
                                    color: i == selection
                                        ? bleu
                                        : const Color(0xFF5B6573),
                                  ),
                                  const SizedBox(width: 14),
                                  Text(
                                    libelle,
                                    style: TextStyle(
                                      fontWeight: i == selection
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: i == selection
                                          ? bleu
                                          : const Color(0xFF041936),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Icon(
                                    i == selection ? active : icone,
                                    color: i == selection
                                        ? bleu
                                        : const Color(0xFF5B6573),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    libelle,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: i == selection
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: i == selection
                                          ? bleu
                                          : const Color(0xFF5B6573),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
