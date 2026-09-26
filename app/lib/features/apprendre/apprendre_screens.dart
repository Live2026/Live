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

part 'contenu_fiche.dart';
part 'panier_achats.dart';
part 'lecteur.dart';
part 'vendre_contenu.dart';
part 'boutique_savoirs.dart';

/// E-APP-01 — Apprendre : cours, PDF, vidéos, livres, séries, QCM et
/// coaching vendus par des enseignants et créateurs vérifiés.
class EcranApprendre extends StatelessWidget {
  const EcranApprendre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnTeteRecherche(
        titre: const Text('Apprendre'),
        indice: context.t.apprendreRechercherUnCoursUn,
        onSubmitted: (q) => context.push('/recherche', extra: q),
        actions: [
          IconButton(
            tooltip: context.t.apprendreMesAchats,
            onPressed: () => context.push('/mes-achats'),
            icon: const Icon(Icons.download_for_offline_outlined),
          ),
          const BoutonPanier(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: const [SectionsApprendre()],
      ),
    );
  }
}

/// Contenu de l'espace Apprendre, aussi affiché dans l'univers « Savoirs »
/// du Market.
class SectionsApprendre extends ConsumerStatefulWidget {
  const SectionsApprendre({super.key});

  @override
  ConsumerState<SectionsApprendre> createState() => _SectionsApprendreState();
}

class _SectionsApprendreState extends ConsumerState<SectionsApprendre> {
  TypeContenu? _type;

  @override
  Widget build(BuildContext context) {
    final biblio = ref.watch(liveProvider.select((e) => e.bibliotheque));
    final marge = context.grandEcran ? 24.0 : 16.0;
    final liste = contenus
        .where((c) => _type == null || c.type == _type)
        .toList();
    final populaires = [...contenus]
      ..sort((a, b) => b.ventes.compareTo(a.ventes));
    Widget carte(Contenu c) =>
        CarteContenu(contenu: c, achete: biblio.contains(c.id));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: marge),
          child: const _BanniereBac(),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 86,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: marge - 8),
            children: [
              PuceIcone(
                icone: Icons.apps_rounded,
                texte: context.t.apprendreTout,
                active: _type == null,
                onTap: () => setState(() => _type = null),
              ),
              for (final t in TypeContenu.values)
                PuceIcone(
                  icone: t.icone,
                  texte: t.libelle,
                  active: _type == t,
                  onTap: () => setState(() => _type = _type == t ? null : t),
                ),
            ],
          ),
        ),
        if (_type == null) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(context.t.apprendreLesPlusSuivis),
          ),
          Carrousel(
            largeur: 220,
            hauteur: 236,
            marge: marge,
            enfants: [for (final c in populaires.take(6)) carte(c)],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(context.t.apprendreEnseignantsEtCreateurs),
          ),
          SizedBox(
            height: 104,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: marge),
              itemCount: auteursApprendre.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final a = auteursApprendre[i];
                return Semantics(
                  button: true,
                  label: a.nom,
                  excludeSemantics: true,
                  child: Pressable(
                    onTap: () => context.push('/boutique/${a.id}'),
                    child: SizedBox(
                      width: 80,
                      child: Column(
                        children: [
                          Avatar(
                            nom: a.nom,
                            couleur: a.couleur,
                            taille: 64,
                            anneau: i < 2,
                            verifie: true,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            a.nom,
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
        ],
        Padding(
          padding: EdgeInsets.symmetric(horizontal: marge),
          child: EnTeteSection(
            _type?.libelle ?? context.t.apprendreTousLesContenus,
            action: _type == null ? null : context.t.apprendreEffacer,
            onTap: _type == null ? null : () => setState(() => _type = null),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: marge),
          child: GrilleAdaptative(
            largeurMax: 260,
            espacement: 14,
            enfants: [
              for (final (i, c) in liste.indexed)
                Apparition(rang: i, child: carte(c)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(marge, 20, marge, 0),
          child: Bloc(
            fond: LiveColors.champ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t.apprendreVousEnseignezOuVous,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                Text(context.t.apprendreVendezVosCoursPdf),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.push('/apprendre/boutique'),
                        child: Text(context.t.apprendreMaBoutique),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => context.push('/apprendre/vendre'),
                        child: Text(context.t.apprendreVendre),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Bannière de rentrée : les cours du BAC, lisibles hors connexion.
class _BanniereBac extends StatelessWidget {
  const _BanniereBac();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.t.apprendreReussirLeBac2027,
      excludeSemantics: true,
      child: Pressable(
        onTap: () => context.push('/contenu/n1'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0xFF1D4ED8), LiveColors.nuit],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.apprendreReussirLeBac2027,
                      style: TextStyle(
                        color: LiveColors.ambreClair,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      context.t.apprendreLesCoursDesMeilleurs,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.school_rounded, color: Colors.white, size: 44),
            ],
          ),
        ),
      ),
    );
  }
}
