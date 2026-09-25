part of 'ia_screens.dart';

/// E-IA-07 et E-IA-08 — Exercice par photo, en mode apprentissage ou solution complète.
class EcranExercice extends ConsumerStatefulWidget {
  const EcranExercice({super.key});

  @override
  ConsumerState<EcranExercice> createState() => _EcranExerciceState();
}

class _EcranExerciceState extends ConsumerState<EcranExercice> {
  var _photo = false;
  var _niveau = 'Lycée';
  var _apprentissage = true;
  var _etape = -1; // -1 : saisie ; 0..2 : étapes ; 3 : fin
  String? _retour;

  static const _etapes = [
    (
      'On veut isoler x. Que faut-il faire avec le « + 3 » ?',
      ['Le soustraire des deux côtés', 'Le multiplier par 2'],
      0,
      '2x + 3 − 3 = 11 − 3, donc 2x = 8.',
    ),
    (
      'On a 2x = 8. Comment trouver x ?',
      ['Diviser les deux côtés par 2', 'Ajouter 2 des deux côtés'],
      0,
      'x = 8 ÷ 2, donc x = 4.',
    ),
    (
      'Vérifions : que vaut 2 × 4 + 3 ?',
      ['11', '10'],
      0,
      '2 × 4 + 3 = 8 + 3 = 11. La solution x = 4 est juste.',
    ),
  ];

  Future<void> _envoyer() async {
    final prix = _apprentissage ? 5 : 8;
    if (!await confirmerPrix(context, ref, 'Exercice par photo', prix)) return;
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
        title: Text(_etape < 0 ? 'Exercice par photo' : 'Équation · $_niveau'),
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
          ? 'Envoyer · ${_apprentissage ? 5 : 8} crédits'
          : 'Prenez d\'abord la photo',
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
                      color: Colors.white,
                      child: const Text(
                        'Exercice 3 : Résoudre 2x + 3 = 11',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : const Text(
                      'Cadrez l\'énoncé',
                      style: TextStyle(color: Colors.white70),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_photo)
          const Text(
            'Photo nette · texte lisible',
            style: TextStyle(color: LiveColors.bleu),
          ),
        OutlinedButton.icon(
          onPressed: () => setState(() => _photo = true),
          icon: const Icon(Icons.photo_camera),
          label: Text(_photo ? 'Reprendre la photo' : 'Prendre la photo'),
        ),
      ],
      secondaire: [
        const Text('Niveau', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: [
            for (final n in const ['Collège', 'Lycée', 'Université'])
              ChoiceChip(
                label: Text(n),
                selected: _niveau == n,
                onSelected: (_) => setState(() => _niveau = n),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Choix(
          titre: 'M\'aider à comprendre',
          sousTitre: 'Étape par étape, avec des questions · 5 crédits',
          selectionne: _apprentissage,
          onTap: () => setState(() => _apprentissage = true),
        ),
        Choix(
          titre: 'Solution complète',
          sousTitre: 'Solution rédigée et justifiée · 8 crédits',
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
          const Text('Énoncé : Résoudre 2x + 3 = 11'),
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
          const Text(
            'Solution : x = 4',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.go('/ia'),
            child: const Text('Retour à Live IA'),
          ),
        ],
      );
    }
    final (question, choix, bon, explication) = _etapes[_etape];
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Énoncé : Résoudre 2x + 3 = 11'),
        const SizedBox(height: 16),
        Text(
          'ÉTAPE ${_etape + 1} SUR ${_etapes.length}',
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
                    ? 'Bravo ! $explication'
                    : 'Pas tout à fait. $explication',
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
                  ? 'Étape suivante'
                  : 'Voir le récapitulatif',
            ),
          ),
        ],
      ],
    );
  }
}

/// E-IA-11 — Mes documents.
class EcranMesDocuments extends ConsumerStatefulWidget {
  const EcranMesDocuments({super.key});

  @override
  ConsumerState<EcranMesDocuments> createState() => _EcranMesDocumentsState();
}

class _EcranMesDocumentsState extends ConsumerState<EcranMesDocuments> {
  /// Type affiché ; nul pour tous les documents.
  String? _type;

  @override
  Widget build(BuildContext context) {
    final docs = ref.watch(liveProvider).documents;
    final types = {for (final d in docs) d.type}.toList();
    final affiches = docs.where((d) => _type == null || d.type == _type);
    return Scaffold(
      appBar: AppBar(title: const Text('Mes documents')),
      body: docs.isEmpty
          ? const EtatVide(
              icone: Icons.folder_open,
              texte: 'Aucun document pour le moment. Vos CV, lettres et business plans apparaîtront ici.',
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (types.length > 1) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in [null, ...types])
                        ChoiceChip(
                          label: Text(
                            t == null ? 'Tous' : serviceParId(t).titre,
                          ),
                          selected: _type == t,
                          onSelected: (_) => setState(() => _type = t),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                GrilleAdaptative(
                  largeurMax: 420,
                  enfants: [
                    for (final d in affiches)
                      Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          leading: const Icon(Icons.description),
                          title: Text(d.titre),
                          subtitle: Text(
                            '${serviceParId(d.type).titre} · ${d.quand}',
                          ),
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
