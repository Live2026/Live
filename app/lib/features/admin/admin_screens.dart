import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/navigation.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

part 'admin_piliers.dart';
part 'admin_tableau.dart';
part 'admin_dossiers.dart';
part 'admin_finance.dart';
part 'admin_connexion.dart';
part 'admin_equipe.dart';
part 'admin_gouvernance.dart';

/// Back-office de Live (E-ADM-01 à 08) : outil interne des agents, pensé pour
/// l'ordinateur. Accès par authentification forte (2FA) et permissions par fonction.

const _sections = [
  (Icons.dashboard_outlined, 'Tableau de bord', '/admin'),
  (Icons.badge_outlined, 'Vérifications KYC', '/admin/kyc'),
  (Icons.shield_outlined, 'Modération', '/admin/moderation'),
  (Icons.gavel_rounded, 'Litiges', '/admin/litiges'),
  (Icons.account_balance_outlined, 'Finance', '/admin/finance'),
  (Icons.currency_exchange_rounded, 'Argent et quotidien', '/admin/quotidien'),
  (Icons.auto_awesome_outlined, 'Live IA', '/admin/ia'),
  (Icons.people_outline, 'Utilisateurs', '/admin/utilisateurs'),
  (Icons.tune_rounded, 'Configuration', '/admin/configuration'),
  (Icons.fact_check_outlined, 'À valider (4 yeux)', '/admin/validations'),
  (Icons.history_rounded, 'Journal d’audit', '/admin/journal'),
  (Icons.admin_panel_settings_outlined, 'Équipe Live', '/admin/equipe'),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F8),
      drawer: grand ? null : Drawer(child: _MenuAdmin(section: section)),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(titre),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  size: 18,
                  color: LiveColors.succes,
                ),
                // Sur téléphone, seule l'icône : le titre garde la place.
                if (grand) ...[
                  const SizedBox(width: 6),
                  const Text(
                    'Direction générale · Super administrateur',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      body: grand
          ? Row(
              children: [
                _MenuAdmin(section: section, pliable: true),
                const VerticalDivider(width: 1),
                Expanded(child: corps),
              ],
            )
          : corps,
    );
  }
}

class _MenuAdmin extends StatelessWidget {
  const _MenuAdmin({required this.section, this.pliable = false});
  final int section;

  /// Vrai sur ordinateur : le menu se replie en colonne d'icônes.
  final bool pliable;

  @override
  Widget build(BuildContext context) {
    if (!pliable) return _contenu(context, true, false);
    return ValueListenableBuilder<bool>(
      valueListenable: barreRepliee,
      builder: (context, replie, _) => AnimatedContainer(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        width: replie ? 76 : 240,
        child: ClipRect(
          child: LayoutBuilder(
            builder: (context, c) =>
                _contenu(context, c.maxWidth > 170, replie),
          ),
        ),
      ),
    );
  }

  Widget _contenu(BuildContext context, bool large, bool replie) {
    Widget entree(IconData icone, String nom, bool actif, VoidCallback onTap) {
      final teinte = actif ? Colors.white : const Color(0xFF9AA7B8);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Tooltip(
          message: large ? '' : nom,
          child: Material(
            color: actif
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: large ? 14 : 0,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: large
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Icon(
                      icone,
                      color: teinte,
                      semanticLabel: large ? null : nom,
                    ),
                    if (large) ...[
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          nom,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: actif
                                ? Colors.white
                                : const Color(0xFFD7DCE4),
                            fontWeight: actif
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      color: LiveColors.nuit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(large ? 20 : 0, 0, 12, 12),
                  child: large
                      ? const Row(
                          children: [
                            LogoLive(taille: 30, couleur: Colors.white),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Back-office',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Color(0xFFFBCC6A)),
                              ),
                            ),
                          ],
                        )
                      : const Center(child: LogoLive(taille: 34, nom: false)),
                ),
                for (final (i, (icone, nom, route)) in _sections.indexed)
                  entree(icone, nom, i == section, () => context.go(route)),
                const Divider(color: Colors.white24, height: 16),
                entree(
                  Icons.phone_android_rounded,
                  'Retour à l’application',
                  false,
                  () => context.go('/moi'),
                ),
                entree(
                  Icons.logout_rounded,
                  'Se déconnecter',
                  false,
                  () => context.go('/admin/connexion'),
                ),
              ],
            ),
          ),
          if (pliable)
            entree(
              replie
                  ? Icons.keyboard_double_arrow_right_rounded
                  : Icons.keyboard_double_arrow_left_rounded,
              replie ? 'Déplier le menu' : 'Replier le menu',
              false,
              () => barreRepliee.value = !replie,
            ),
          const SizedBox(height: 12),
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
      5 => ('Argent et quotidien', const _ArgentQuotidien()),
      6 => ('Live IA : coûts et usage', const _LiveIaAdmin()),
      7 => ('Utilisateurs', const _Utilisateurs()),
      8 => ('Configuration', const _Configuration()),
      9 => ('Double validation', const _Validations()),
      10 => ('Journal d’audit', const _JournalAudit()),
      _ => ('Équipe Live', const _EquipeLive()),
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
