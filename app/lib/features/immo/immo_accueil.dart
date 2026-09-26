part of 'immo_screens.dart';

/// E-IMMO-01 + E-IMMO-02 — Accueil Immo : louer ou acheter, catégories,
/// logements à la une, agences vérifiées, visites en vidéo et grille complète.
class EcranImmo extends StatefulWidget {
  const EcranImmo({super.key});

  @override
  State<EcranImmo> createState() => _EcranImmoState();
}

class _EcranImmoState extends State<EcranImmo> {
  var _vente = false;
  TypeBien? _type;
  String? _quartier;
  int? _budget;

  List<Bien> get _liste => biens
      .where(
        (b) =>
            b.vente == _vente &&
            (_type == null || b.type == _type) &&
            (_quartier == null || b.quartier == _quartier) &&
            (_budget == null || b.loyer <= _budget!),
      )
      .toList();

  Future<void> _filtres() async {
    final r = await ouvrirFiltresImmo(context, budget: _budget, vente: _vente);
    if (r != null) setState(() => _budget = r == 0 ? null : r);
  }

  @override
  Widget build(BuildContext context) {
    final marge = context.grandEcran ? 24.0 : 16.0;
    final liste = _liste;
    final aLaUne = biens.where((b) => b.sponsorise || b.nouveau).toList();
    final filtre = _type != null || _quartier != null || _budget != null;
    return Scaffold(
      appBar: EnTeteRecherche(
        titleSpacing: marge,
        indice: context.t.immoQuartierTypeDeLogement,
        onSubmitted: (q) => context.push('/recherche', extra: q),
        titre: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Immo'),
            TexteVille(
              context.t.immoVilleVerifies('{ville}'),
              style: TextStyle(
                fontSize: 12.5,
                color: LiveColors.gris,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: context.t.immoVoirSurLaCarte,
            onPressed: () => context.push('/carte'),
            icon: const Icon(Icons.map_outlined),
          ),
          const BoutonNotifications(),
          const BoutonMessages(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: Row(
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(
                        value: false,
                        label: Text(context.t.immoLouer),
                      ),
                      ButtonSegment(
                        value: true,
                        label: Text(context.t.immoAcheter),
                      ),
                    ],
                    selected: {_vente},
                    onSelectionChanged: (s) => setState(() {
                      _vente = s.first;
                      _budget = null;
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.outlined(
                  tooltip: context.t.immoFiltres,
                  onPressed: _filtres,
                  icon: Badge(
                    isLabelVisible: _budget != null,
                    smallSize: 8,
                    child: const Icon(Icons.tune_rounded),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 86,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: marge - 8),
              children: [
                PuceIcone(
                  icone: Icons.grid_view_rounded,
                  texte: context.t.immoTout,
                  active: _type == null,
                  onTap: () => setState(() => _type = null),
                ),
                for (final t in TypeBien.values)
                  PuceIcone(
                    icone: t.icone,
                    texte: t.libelle.split(' ').first,
                    active: _type == t,
                    onTap: () => setState(() => _type = _type == t ? null : t),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: marge),
              children: [
                for (final q in quartiersBrazzaville)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(q),
                      selected: _quartier == q,
                      onSelected: (v) =>
                          setState(() => _quartier = v ? q : null),
                    ),
                  ),
              ],
            ),
          ),
          if (!filtre) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: marge),
              child: EnTeteSection(context.t.immoALaUne),
            ),
            Carrousel(
              largeur: context.grandEcran ? 300 : 250,
              hauteur: context.grandEcran ? 330 : 290,
              marge: marge,
              enfants: [
                for (final b in aLaUne) CarteBien(bien: b, hero: false),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: marge),
              child: EnTeteSection(
                context.t.immoAgencesVerifiees,
                onTap: () => context.push('/boutique/palmiers'),
              ),
            ),
            _Agences(marge: marge),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: marge),
              child: EnTeteSection(context.t.immoVisitesEnVideo),
            ),
            Carrousel(
              largeur: 132,
              hauteur: 230,
              marge: marge,
              enfants: [for (final b in biens.take(8)) _VisiteVideo(bien: b)],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: marge),
              child: EnTeteSection(
                context.t.immoSejoursMeublesALa,
                onTap: () => context.push('/sejours'),
              ),
            ),
            Carrousel(
              largeur: 230,
              hauteur: 250,
              marge: marge,
              enfants: [for (final s in sejours) CarteSejour(sejour: s)],
            ),
            if (directs.any((d) => d.bien != null)) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: marge),
                child: EnTeteSection(
                  context.t.immoVisitesEnDirect,
                  onTap: () => context.push('/directs'),
                ),
              ),
              Carrousel(
                largeur: 150,
                hauteur: 240,
                marge: marge,
                enfants: [
                  for (final d in directs.where((d) => d.bien != null))
                    CarteDirect(direct: d),
                ],
              ),
            ],
          ],
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: EnTeteSection(
              filtre
                  ? context.t.immoNResultats(liste.length)
                  : _vente
                  ? context.t.immoBiensAVendre
                  : context.t.immoTousLesLogements,
              action: filtre ? context.t.immoEffacer : null,
              onTap: filtre
                  ? () => setState(() {
                      _type = null;
                      _quartier = null;
                      _budget = null;
                    })
                  : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: marge),
            child: liste.isEmpty
                ? EtatVide(
                    icone: Icons.search_off_rounded,
                    texte: context.t.immoAucunBienNeCorrespond,
                    action: context.t.immoCreerUneAlerte,
                    onTap: () => context.push('/alertes'),
                  )
                : GrilleAdaptative(
                    largeurMax: context.grandEcran ? 300 : 200,
                    espacement: 14,
                    enfants: [
                      for (final (i, b) in liste.indexed)
                        Apparition(
                          rang: i,
                          child: CarteBien(bien: b),
                        ),
                    ],
                  ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(marge, 24, marge, 0),
            child: _AppelPublier(),
          ),
        ],
      ),
    );
  }
}

/// Rangée des agences vérifiées : avatar, nom, note, nombre de biens.
class _Agences extends StatelessWidget {
  const _Agences({required this.marge});
  final double marge;

  @override
  Widget build(BuildContext context) {
    const agences = [palmiers, congoHabitat, mbemba];
    return Carrousel(
      largeur: 220,
      hauteur: 76,
      marge: marge,
      enfants: [
        for (final a in agences)
          Pressable(
            onTap: () => context.push('/boutique/${a.id}'),
            child: Bloc(
              padding: 10,
              child: Row(
                children: [
                  Avatar(nom: a.nom, couleur: a.couleur, verifie: true),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          a.nom,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          context.t.immoNoteBiens(
                            note(a.note),
                            biensDe(a).length,
                          ),
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
          ),
      ],
    );
  }
}

/// Vignette verticale façon TikTok : visite filmée du logement.
class _VisiteVideo extends StatelessWidget {
  const _VisiteVideo({required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context) {
    final b = bien;
    return Semantics(
      button: true,
      label: context.t.immoVisiteVideoDe(b.titre),
      child: Pressable(
        onTap: () => context.push('/bien/${b.id}'),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Vignette(couleur: b.couleur, icone: b.type.icone),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC041936)],
                  stops: [0.45, 1],
                ),
              ),
            ),
            const Positioned(
              left: 8,
              top: 8,
              child: Icon(Icons.play_arrow_rounded, color: Colors.white),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fcfaCourt(b.loyer),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${b.type.libelle} · ${b.quartier}',
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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

/// Invitation à publier un bien (débloque le pouvoir C-IMMO-PARTICULIER).
class _AppelPublier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [LiveColors.bleu, LiveColors.nuit],
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
                  context.t.immoVousAvezUnBien,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  context.t.immoPublicationGratuiteLesFrais,
                  style: TextStyle(color: LiveColors.brumeClaire, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: LiveColors.surface,
              foregroundColor: LiveColors.encre,
              minimumSize: const Size(0, 44),
            ),
            onPressed: () => context.push('/publier/bien'),
            child: Text(context.t.immoPublier),
          ),
        ],
      ),
    );
  }
}
