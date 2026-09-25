import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'adaptatif.dart';

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
