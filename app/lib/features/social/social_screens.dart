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

/// E-SOC-01 — Abonnés et abonnements, avec filtres par type de compte
/// (personnes, organisations, créateurs, enseignants).
class EcranAbonnes extends ConsumerStatefulWidget {
  const EcranAbonnes({super.key, required this.id, this.onglet = 0});
  final String id;
  final int onglet;

  @override
  ConsumerState<EcranAbonnes> createState() => _EcranAbonnesState();
}

class _EcranAbonnesState extends ConsumerState<EcranAbonnes> {
  late var _onglet = widget.onglet;
  TypeCompte? _filtre;

  @override
  Widget build(BuildContext context) {
    final suivis = ref.watch(liveProvider.select((e) => e.suivis));
    final abonnements = comptes
        .where((c) => suivis.contains(c.id) || c.verifie)
        .toList();
    final source = _onglet == 0 ? abonnesDemo : abonnements;
    final liste = source
        .where((c) => _filtre == null || c.type == _filtre)
        .toList();
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Mes relations')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: Row(
              children: [
                for (final (i, t) in [
                  '${abonnesDemo.length + 122} abonnés',
                  '${abonnements.length} abonnements',
                ].indexed)
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _onglet = i),
                      child: Container(
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 3,
                              color: _onglet == i
                                  ? LiveColors.bleu
                                  : const Color(0xFFE4E8EE),
                            ),
                          ),
                        ),
                        child: Text(
                          t,
                          style: TextStyle(
                            fontWeight: _onglet == i
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: _onglet == i
                                ? LiveColors.nuit
                                : LiveColors.gris,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(marge, 8, marge, 0),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('Tous'),
                    selected: _filtre == null,
                    onSelected: (_) => setState(() => _filtre = null),
                  ),
                ),
                for (final t in TypeCompte.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(t.pluriel),
                      selected: _filtre == t,
                      onSelected: (_) =>
                          setState(() => _filtre = _filtre == t ? null : t),
                    ),
                  ),
              ],
            ),
          ),
          if (liste.isEmpty)
            const EtatVide(
              icone: Icons.people_outline_rounded,
              texte: 'Aucun compte dans cette catégorie.',
            ),
          for (final (i, c) in liste.indexed)
            Apparition(
              rang: i,
              child: _LigneCompte(compte: c, marge: marge),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(marge, 16, marge, 0),
            child: OutlinedButton.icon(
              onPressed: () => context.push('/suivis'),
              icon: const Icon(Icons.dynamic_feed_rounded),
              label: const Text('Voir l’activité de mes abonnements'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ligne d'un compte : avatar, nom, type, bio et bouton Suivre.
class _LigneCompte extends ConsumerWidget {
  const _LigneCompte({required this.compte, required this.marge});
  final Compte compte;
  final double marge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = compte;
    final suivi = ref.watch(
      liveProvider.select((e) => e.suivis.contains(c.id)),
    );
    return InkWell(
      onTap: c.route == null ? null : () => context.push(c.route!),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: marge, vertical: 8),
        child: Row(
          children: [
            Avatar(
              nom: c.nom,
              couleur: c.couleur,
              taille: 48,
              verifie: c.verifie,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.nom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${c.type.libelle} · ${compact(c.abonnes)} abonnés',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: LiveColors.gris,
                      fontSize: 12.5,
                    ),
                  ),
                  Text(
                    c.bio,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 96,
              child: suivi
                  ? OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 36),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () =>
                          ref.read(liveProvider.notifier).basculerSuivi(c.id),
                      child: const Text('Abonné'),
                    )
                  : FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 36),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () =>
                          ref.read(liveProvider.notifier).basculerSuivi(c.id),
                      child: const Text('Suivre'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// E-SOC-02 — Activité des comptes suivis : cours, bourses, articles,
/// logements et directs, comme un fil d'abonnements.
class EcranSuivis extends StatelessWidget {
  const EcranSuivis({super.key});

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Mes abonnements')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(marge, 8, marge, 0),
              itemCount: activitesSuivis.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final c = activitesSuivis[i].compte;
                return Semantics(
                  button: true,
                  label: c.nom,
                  excludeSemantics: true,
                  child: Pressable(
                    onTap: () => context.push(activitesSuivis[i].route),
                    child: SizedBox(
                      width: 72,
                      child: Column(
                        children: [
                          Avatar(
                            nom: c.nom,
                            couleur: c.couleur,
                            taille: 58,
                            anneau: true,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.nom,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 16),
          for (final (i, a) in activitesSuivis.indexed)
            Apparition(
              rang: i,
              child: Padding(
                padding: EdgeInsets.fromLTRB(marge, 6, marge, 6),
                child: _CarteActivite(activite: a),
              ),
            ),
        ],
      ),
    );
  }
}

/// Carte d'activité : qui, quoi, aperçu cliquable. Hauteur fixe.
class _CarteActivite extends StatelessWidget {
  const _CarteActivite({required this.activite});
  final Activite activite;

  @override
  Widget build(BuildContext context) {
    final a = activite;
    return Pressable(
      onTap: () => context.push(a.route),
      child: Bloc(
        padding: 12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Avatar(
                  nom: a.compte.nom,
                  couleur: a.compte.couleur,
                  taille: 38,
                  verifie: a.compte.verifie,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: a.compte.nom,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: ' ${a.action}'),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  a.quand,
                  style: const TextStyle(color: LiveColors.gris, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 72,
              child: Row(
                children: [
                  SizedBox(
                    width: 108,
                    child: Vignette(
                      couleur: a.couleur,
                      icone: a.icone,
                      rayon: 8,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.titre,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          a.detail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: LiveColors.gris,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
