import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/adaptatif.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/mock.dart';
import '../../data/store.dart';
import '../../shared/animations.dart';
import '../../shared/feuilles.dart';
import '../../shared/widgets.dart';
import '../../l10n/textes.dart';

part 'relations_lignes.dart';
part 'suivis.dart';
part 'bloques.dart';

enum _Tri { recents, nom, populaires }

/// E-SOC-01 — Mes relations, comme les grandes applications : abonnés,
/// abonnements et suggestions ; recherche, filtres par type de compte, tri,
/// « Vous suit », « Suivre en retour », menu par compte (retirer, sourdine,
/// cloche, bloquer, signaler) et invitation des contacts.
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
  var _tri = _Tri.recents;
  final _recherche = TextEditingController();
  final _ecartes = <String>{};

  @override
  void didUpdateWidget(EcranAbonnes ancien) {
    super.didUpdateWidget(ancien);
    // Même page ouverte avec un autre onglet (lien `?onglet=`).
    if (ancien.onglet != widget.onglet) _onglet = widget.onglet;
  }

  List<Compte> _trier(List<Compte> l) => switch (_tri) {
    _Tri.recents => l,
    _Tri.nom => [...l]..sort((a, b) => a.nom.compareTo(b.nom)),
    _Tri.populaires => [...l]..sort((a, b) => b.abonnes.compareTo(a.abonnes)),
  };

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(liveProvider);
    final abonnes = abonnesDemo
        .where(
          (c) => !etat.retires.contains(c.id) && !etat.bloques.contains(c.id),
        )
        .toList();
    final idsAbonnes = {for (final c in abonnes) c.id};
    final abonnements = comptes
        .where((c) => etat.suivis.contains(c.id))
        .toList();
    final suggestions = comptes
        .where(
          (c) =>
              !etat.suivis.contains(c.id) &&
              !idsAbonnes.contains(c.id) &&
              !etat.bloques.contains(c.id) &&
              !_ecartes.contains(c.id),
        )
        .toList();
    final q = _recherche.text.trim().toLowerCase();
    final source = [abonnes, abonnements, suggestions][_onglet];
    final liste = _trier(
      source
          .where((c) => _filtre == null || c.type == _filtre)
          .where((c) => q.isEmpty || c.nom.toLowerCase().contains(q))
          .toList(),
    );
    final marge = context.grandEcran ? 24.0 : 16.0;
    final total = [
      abonnes.length + 122,
      abonnements.length,
      suggestions.length,
    ];
    return Scaffold(
      appBar: EnTeteRecherche(
        titre: Text(context.t.socialMesRelations),
        indice: context.t.socialRechercherUnNom,
        onChanged: (v) => setState(() => _recherche.text = v),
        actions: [
          PopupMenuButton<_Tri>(
            tooltip: context.t.socialTrier,
            initialValue: _tri,
            onSelected: (t) => setState(() => _tri = t),
            icon: const Icon(Icons.swap_vert_rounded),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _Tri.recents,
                child: Text(context.t.socialLesPlusRecents),
              ),
              PopupMenuItem(
                value: _Tri.nom,
                child: Text(context.t.socialNomDeAA),
              ),
              PopupMenuItem(
                value: _Tri.populaires,
                child: Text(context.t.socialLesPlusSuivis),
              ),
            ],
          ),
          IconButton(
            tooltip: context.t.socialInviterDesContacts,
            onPressed: () => _inviter(context),
            icon: const Icon(Icons.person_add_alt_1_outlined),
          ),
          IconButton(
            tooltip: context.t.socialComptesBloques,
            onPressed: () => context.push('/bloques'),
            icon: Badge(
              isLabelVisible: etat.bloques.isNotEmpty,
              label: Text('${etat.bloques.length}'),
              child: const Icon(Icons.block_rounded),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _OngletsRelations(
            actif: _onglet,
            libelles: [
              context.t.socialAbonnes,
              context.t.socialAbonnements,
              context.t.socialSuggestions,
            ],
            nombres: total,
            onTap: (i) => setState(() => _onglet = i),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(marge, 6, marge, 0),
              children: [
                for (final t in <TypeCompte?>[null, ...TypeCompte.values])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        t?.plurielDe(context.t) ?? context.t.socialTous,
                      ),
                      selected: _filtre == t,
                      onSelected: (_) => setState(() => _filtre = t),
                    ),
                  ),
              ],
            ),
          ),
          if (_onglet == 2) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(marge, 8, marge, 4),
              child: _CarteInviter(onTap: () => _inviter(context)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: marge),
              child: EnTeteSection(context.t.socialVousPourriezLesConnaitre),
            ),
            if (liste.isEmpty) const _Vide(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: marge),
              child: GrilleAdaptative(
                largeurMax: 200,
                espacement: 10,
                hauteur: 248,
                enfants: [
                  for (final (i, c) in liste.indexed)
                    Apparition(
                      rang: i,
                      child: _CarteSuggestion(
                        compte: c,
                        onEcarter: () => setState(() => _ecartes.add(c.id)),
                      ),
                    ),
                ],
              ),
            ),
          ] else ...[
            Padding(
              padding: EdgeInsets.fromLTRB(marge, 10, marge, 4),
              child: Text(
                q.isEmpty
                    ? (_onglet == 0
                          ? context.t.socialLesPersonnesQuiVous
                          : context.t.socialLesComptesQueVous)
                    : context.t.socialNResultatsPour(
                        liste.length,
                        _recherche.text.trim(),
                      ),
                style: const TextStyle(color: LiveColors.gris, fontSize: 13),
              ),
            ),
            if (liste.isEmpty) const _Vide(),
            for (final (i, c) in liste.indexed)
              Apparition(
                rang: i,
                child: _LigneCompte(
                  compte: c,
                  marge: marge,
                  abonne: idsAbonnes.contains(c.id),
                  ongletAbonnes: _onglet == 0,
                ),
              ),
            if (_onglet == 1)
              Padding(
                padding: EdgeInsets.fromLTRB(marge, 16, marge, 0),
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/suivis'),
                  icon: const Icon(Icons.dynamic_feed_rounded),
                  label: Text(context.t.socialVoirLActiviteDe),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _Vide extends StatelessWidget {
  const _Vide();

  @override
  Widget build(BuildContext context) => EtatVide(
    icone: Icons.person_search_rounded,
    texte: context.t.socialAucunCompteNeCorrespond,
  );
}

/// Onglets soulignés avec un trait qui glisse sous l'onglet actif.
class _OngletsRelations extends StatelessWidget {
  const _OngletsRelations({
    required this.actif,
    required this.libelles,
    required this.nombres,
    required this.onTap,
  });
  final int actif;
  final List<String> libelles;
  final List<int> nombres;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final largeur = c.maxWidth / libelles.length;
        return SizedBox(
          height: 58,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(height: 1, color: LiveColors.filet),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 260),
                curve: courbeDouce,
                left: largeur * actif + 16,
                width: largeur - 32,
                bottom: 0,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: LiveColors.bleu,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  for (final (i, l) in libelles.indexed)
                    Expanded(
                      child: Semantics(
                        button: true,
                        selected: actif == i,
                        label: '${nombres[i]} $l',
                        excludeSemantics: true,
                        child: InkWell(
                          onTap: () => onTap(i),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChiffreAnime(
                                valeur: nombres[i],
                                format: (n) => '$n',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: actif == i
                                      ? LiveColors.encre
                                      : LiveColors.gris,
                                ),
                              ),
                              Text(
                                l,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: actif == i
                                      ? LiveColors.encre
                                      : LiveColors.gris,
                                  fontWeight: actif == i
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
