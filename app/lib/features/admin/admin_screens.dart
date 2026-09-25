import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

part 'admin_tableau.dart';
part 'admin_dossiers.dart';
part 'admin_finance.dart';

/// Back-office de Live (E-ADM-01 à 08) : outil interne des agents, pensé pour
/// l'ordinateur. Accès par authentification forte (2FA) et permissions par fonction.

const _sections = [
  (Icons.dashboard_outlined, 'Tableau de bord', '/admin'),
  (Icons.badge_outlined, 'Vérifications KYC', '/admin/kyc'),
  (Icons.shield_outlined, 'Modération', '/admin/moderation'),
  (Icons.gavel_rounded, 'Litiges', '/admin/litiges'),
  (Icons.account_balance_outlined, 'Finance', '/admin/finance'),
  (Icons.people_outline, 'Utilisateurs', '/admin/utilisateurs'),
  (Icons.tune_rounded, 'Configuration', '/admin/configuration'),
];

/// Coque du back-office : menu latéral (ordinateur) ou tiroir (téléphone).
class _CoqueAdmin extends StatelessWidget {
  const _CoqueAdmin({
    required this.section,
    required this.titre,
    required this.corps,
  });
  final int section;
  final String titre;
  final Widget corps;

  @override
  Widget build(BuildContext context) {
    final grand = context.grandEcran;
    final menu = _MenuAdmin(section: section);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      drawer: grand ? null : Drawer(child: menu),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(titre),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 18,
                  color: LiveColors.succes,
                ),
                SizedBox(width: 6),
                Text('Aïcha · Superviseure', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
      body: grand
          ? Row(
              children: [
                SizedBox(width: 240, child: menu),
                const VerticalDivider(width: 1),
                Expanded(child: corps),
              ],
            )
          : corps,
    );
  }
}

class _MenuAdmin extends StatelessWidget {
  const _MenuAdmin({required this.section});
  final int section;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LiveColors.nuit,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Text(
              'LIVE · Back-office',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
          for (final (i, (icone, nom, route)) in _sections.indexed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Material(
                color: i == section
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  dense: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  leading: Icon(
                    icone,
                    color: i == section
                        ? Colors.white
                        : const Color(0xFF9AA7B8),
                  ),
                  title: Text(
                    nom,
                    style: TextStyle(
                      color: i == section
                          ? Colors.white
                          : const Color(0xFFD7DCE4),
                      fontWeight: i == section
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                  onTap: () => context.go(route),
                ),
              ),
            ),
          const Divider(color: Colors.white24, height: 32),
          ListTile(
            dense: true,
            leading: const Icon(
              Icons.phone_android_rounded,
              color: Color(0xFF9AA7B8),
            ),
            title: const Text(
              'Retour à l’application',
              style: TextStyle(color: Color(0xFFD7DCE4)),
            ),
            onTap: () => context.go('/moi'),
          ),
        ],
      ),
    );
  }
}

/// Point d'entrée : une section du back-office.
class EcranAdmin extends StatelessWidget {
  const EcranAdmin({super.key, required this.section});
  final int section;

  @override
  Widget build(BuildContext context) {
    final (titre, corps) = switch (section) {
      0 => ('Tableau de bord', const _TableauDeBord()),
      1 => ('Vérifications KYC', const _FileKyc()),
      2 => ('Modération', const _FileModeration()),
      3 => ('Litiges', const _FileLitiges()),
      4 => ('Finance et réconciliation', const _Finance()),
      5 => ('Utilisateurs', const _Utilisateurs()),
      _ => ('Configuration', const _Configuration()),
    };
    return _CoqueAdmin(section: section, titre: titre, corps: corps);
  }
}

/// En-tête de tableau (colonnes alignées) réutilisé par les files de travail.
class _Tableau extends StatelessWidget {
  const _Tableau({required this.colonnes, required this.lignes, this.onTap});
  final List<(String, int)> colonnes;
  final List<List<Widget>> lignes;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    return Bloc(
      padding: 0,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFF8FAFC),
            child: Row(
              children: [
                for (final (nom, flex) in colonnes)
                  Expanded(
                    flex: flex,
                    child: Text(
                      nom,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: LiveColors.gris,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          for (final (i, l) in lignes.indexed)
            InkWell(
              onTap: onTap == null ? null : () => onTap!(i),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE4E8EE))),
                ),
                child: Row(
                  children: [
                    for (final (j, cellule) in l.indexed)
                      Expanded(flex: colonnes[j].$2, child: cellule),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Pastille d'état (couleur sémantique).
Widget _etat(String texte) {
  final (fond, couleur) = switch (texte) {
    'Urgent' ||
    'Bloqué' ||
    'Écart' ||
    'Rejeté' => (const Color(0xFFFDECEC), LiveColors.erreur),
    'Validé' ||
    'Réconcilié' ||
    'Actif' ||
    'Résolu' => (const Color(0xFFE7F4EC), LiveColors.succes),
    _ => (const Color(0xFFFFF4E0), LiveColors.cuivre),
  };
  return Align(
    alignment: Alignment.centerLeft,
    child: Etiquette(texte, fond: fond, couleur: couleur),
  );
}
