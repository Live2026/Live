import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../shared/logo.dart';
import 'adaptatif.dart';
import 'theme.dart';

part 'barre_laterale.dart';

/// Navigation principale adaptative (docs/ecrans/00, section 8) :
/// barre d'onglets en bas sur téléphone, rail à gauche sur grand écran.
class NavigationPrincipale extends StatelessWidget {
  const NavigationPrincipale({super.key, required this.shell});
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

/// Adresses des cinq onglets, dans l'ordre de la barre.
const racinesOnglets = ['/accueil', '/explorer', '/publier', '/ia', '/moi'];

/// Pages rangées sous « Moi » : compte, argent, outils, créateur.
const _pagesMoi = [
  '/pouvoirs',
  '/live-pro',
  '/verifier',
  '/espace',
  '/profil/moi',
  '/parametres',
  '/donnees',
  '/paiements',
  '/abonnes',
  '/suivis',
  '/bloques',
  '/enregistres',
  '/alertes',
  '/commandes',
  '/mes-ventes',
  '/vente/',
  '/gains',
  '/retirer',
  '/recu',
  '/studio',
  '/live-plus',
  '/publicite',
  '/fonds-createurs',
  '/finance',
  '/partenaires',
  '/mes-achats',
  '/mes-candidatures',
  '/agence',
  '/pro/interventions',
  '/pro/devis',
  '/reclamation',
  '/avis',
  '/probleme',
  '/suivi/',
];

/// Pages sans onglet propre (ouvertes depuis l'en-tête).
const _pagesEnTete = [
  '/messages',
  '/conversation',
  '/groupe',
  '/notifications',
];

/// Onglet auquel se rattache une page secondaire, pour la barre latérale ;
/// -1 si aucun.
int ongletDe(String chemin) {
  if (_pagesEnTete.any(chemin.startsWith) &&
      !chemin.startsWith('/notifications/preferences')) {
    return -1;
  }
  if (chemin.startsWith('/ia')) return 3;
  if (chemin.startsWith('/publier') || chemin == '/vendre') return 2;
  if (_pagesMoi.any(chemin.startsWith) ||
      chemin.startsWith('/notifications/preferences')) {
    return 4;
  }
  return 1;
}

/// Sur ordinateur, chaque page garde la barre latérale : on reste dans
/// l'application, où qu'on soit. Sur téléphone, la page s'affiche seule.
class CadreOrdinateur extends StatelessWidget {
  const CadreOrdinateur({super.key, required this.chemin, required this.child});
  final String chemin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final taille = context.taille;
    if (taille == Taille.compacte) return child;
    return Scaffold(
      body: Row(
        children: [
          _BarreLaterale(
            etendue: taille == Taille.etendue,
            selection: ongletDe(chemin),
            onglets: NavigationPrincipale._onglets,
            onTap: (i) => context.go(racinesOnglets[i]),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Semantics(
              container: true,
              explicitChildNodes: true,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
