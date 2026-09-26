part of 'ia_screens.dart';

/// E-IA-07 et E-IA-08 — Exercice par photo, en mode apprentissage ou solution complète.
class EcranExercice extends ConsumerStatefulWidget {
  const EcranExercice({super.key});

  @override
  ConsumerState<EcranExercice> createState() => _EcranExerciceState();
}

class _EcranExerciceState extends ConsumerState<EcranExercice> {
  var _photo = false;
  late var _niveau = context.t.iaLycee;
  var _apprentissage = true;
  var _etape = -1; // -1 : saisie ; 0..2 : étapes ; 3 : fin
  String? _retour;

  late final _etapes = [
    (
      context.t.iaOnVeutIsolerX,
      [context.t.iaLeSoustraireDesDeux, context.t.iaLeMultiplierPar2],
      0,
      context.t.iaN2x3311,
    ),
    (
      context.t.iaOnA2x8,
      [context.t.iaDiviserLesDeuxCotes, context.t.iaAjouter2DesDeux],
      0,
      context.t.iaX82Donc,
    ),
    (context.t.iaVerifionsQueVaut2, ['11', '10'], 0, context.t.iaN2438),
  ];

  Future<void> _envoyer() async {
    final prix = _apprentissage ? 5 : 8;
    if (!await confirmerPrix(
      context,
      ref,
      context.t.iaExerciceParPhoto,
      prix,
    )) {
      return;
    }
    ref.read(liveProvider.notifier).ajouterDocument(
      'exercice',
      'Exercice · Équation',
      [
        ('Résoudre 2x + 3 = 11', 'x = 4'),
        ('Méthode', 'Soustraire 3, puis diviser par 2, puis vérifier.'),
      ],
    );
    setState(() => _etape = _apprentissage ? 0 : 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _etape < 0
              ? context.t.iaExerciceParPhoto
              : context.t.iaEquationNiveau(_niveau),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Credits(ref.watch(liveProvider).credits)),
          ),
        ],
      ),
      body: _etape < 0 ? _saisie() : _resolution(),
      bottomNavigationBar: _etape < 0 && !context.grandEcran
          ? BarreAction(child: _boutonEnvoyer())
          : null,
    );
  }

  Widget _boutonEnvoyer() => FilledButton(
    onPressed: _photo ? _envoyer : null,
    child: Text(
      _photo
          ? context.t.iaEnvoyerCredits(_apprentissage ? 5 : 8)
          : context.t.iaPrenezDAbordLa,
    ),
  );

  Widget _saisie() {
    return DeuxColonnes(
      principale: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: _photo
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      color: LiveColors.surface,
                      child: Text(
                        context.t.iaExercice3Resoudre2x,
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : Text(
                      context.t.iaCadrezLEnonce,
                      style: TextStyle(color: Colors.white70),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_photo)
          Text(
            context.t.iaPhotoNetteTexteLisible,
            style: TextStyle(color: LiveColors.bleu),
          ),
        OutlinedButton.icon(
          onPressed: () => setState(() => _photo = true),
          icon: const Icon(Icons.photo_camera),
          label: Text(
            _photo ? context.t.iaReprendreLaPhoto : context.t.iaPrendreLaPhoto,
          ),
        ),
      ],
      secondaire: [
        Text(context.t.iaNiveau, style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: [
            for (final n in [
              context.t.iaCollege,
              context.t.iaLycee,
              context.t.iaUniversite,
            ])
              ChoiceChip(
                label: Text(n),
                selected: _niveau == n,
                onSelected: (_) => setState(() => _niveau = n),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Choix(
          titre: context.t.iaMAiderAComprendre,
          sousTitre: context.t.iaEtapeParEtapeAvec,
          selectionne: _apprentissage,
          onTap: () => setState(() => _apprentissage = true),
        ),
        Choix(
          titre: context.t.iaSolutionComplete,
          sousTitre: context.t.iaSolutionRedigeeEtJustifiee,
          selectionne: !_apprentissage,
          onTap: () => setState(() => _apprentissage = false),
        ),
        if (context.grandEcran) ...[
          const SizedBox(height: 12),
          _boutonEnvoyer(),
        ],
      ],
    );
  }

  Widget _resolution() {
    if (_etape >= 3) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(context.t.iaEnonceResoudre2x3),
          const SizedBox(height: 16),
          for (final e in _etapes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: LiveColors.bleu),
                  const SizedBox(width: 8),
                  Expanded(child: Text(e.$4)),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Text(
            context.t.iaSolutionX4,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.go('/ia'),
            child: Text(context.t.iaRetourALiveIa),
          ),
        ],
      );
    }
    final (question, choix, bon, explication) = _etapes[_etape];
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(context.t.iaEnonceResoudre2x3),
        const SizedBox(height: 16),
        Text(
          context.t.iaEtapeSur(_etape + 1, _etapes.length),
          style: const TextStyle(
            color: LiveColors.bleu,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(question, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        for (final (i, c) in choix.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OutlinedButton(
              onPressed: () => setState(
                () => _retour = i == bon
                    ? context.t.iaBravo(explication)
                    : context.t.iaPasTout(explication),
              ),
              child: Text(c),
            ),
          ),
        if (_retour != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: LiveColors.fondProtection,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_retour!),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => setState(() {
              _etape++;
              _retour = null;
            }),
            child: Text(
              _etape + 1 < _etapes.length
                  ? context.t.iaEtapeSuivante
                  : context.t.iaVoirLeRecapitulatif,
            ),
          ),
        ],
      ],
    );
  }
}

/// E-IA-11 — Mes documents.
class EcranMesDocuments extends ConsumerWidget {
  const EcranMesDocuments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docs = ref.watch(liveProvider).documents;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.iaMesDocuments)),
      body: docs.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  context.t.iaAucunDocumentPourLe,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GrilleAdaptative(
                  largeurMax: 420,
                  enfants: [
                    for (final d in docs)
                      Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(d.titre),
                          subtitle: Text(d.quand),
                          onTap: () => context.push('/ia/document/${d.id}'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
    );
  }
}
