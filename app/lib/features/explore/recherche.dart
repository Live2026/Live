part of 'explore_screen.dart';

/// E-EXP-02 + E-EXP-03 — Recherche : suggestions avant la saisie, puis
/// résultats par espace (produits, logements, pros).
class EcranRecherche extends ConsumerStatefulWidget {
  const EcranRecherche({super.key, this.initiale});

  /// Texte déjà saisi dans la loupe d'un en-tête.
  final String? initiale;

  @override
  ConsumerState<EcranRecherche> createState() => _EcranRechercheState();
}

class _EcranRechercheState extends ConsumerState<EcranRecherche> {
  late final _champ = TextEditingController(text: widget.initiale ?? '');
  var _onglet = 0;

  static const _recentes = [
    'iPhone',
    'studio Poto-Poto',
    'plombier',
    'pagne wax',
  ];
  static const _tendances = [
    'Climatiseur',
    'Appartement Moungali',
    'Robe wax',
    'Saka-saka',
    'Tresses à domicile',
    'Galaxy A14',
  ];

  void _chercher(String t) => setState(() => _champ.text = t);

  /// Requête effectivement cherchée (corrigée si elle ne donnait rien).
  String? _corrigee;

  /// F-RECH-01 : mot le plus proche du vocabulaire du catalogue (distance
  /// d'édition au plus 2), pour « Vouliez-vous dire… ».
  static String? correction(String q) {
    final mots = {
      for (final t in [
        ..._tendances,
        for (final (_, c) in categoriesMarket) c,
        for (final p in produits) p.titre,
        for (final p in prestataires) p.metier,
        ...quartiersBrazzaville,
      ])
        for (final m in t.split(RegExp(r'[ ,·()]')))
          if (m.length > 3) m.toLowerCase(),
    };
    String? meilleur;
    var distance = 3;
    for (final m in mots) {
      final d = _distance(q.toLowerCase(), m);
      if (d < distance) {
        distance = d;
        meilleur = m;
      }
    }
    return distance == 0 ? null : meilleur;
  }

  static int _distance(String a, String b) {
    var prec = List<int>.generate(b.length + 1, (i) => i);
    for (var i = 1; i <= a.length; i++) {
      final cour = [i, ...List<int>.filled(b.length, 0)];
      for (var j = 1; j <= b.length; j++) {
        final cout = a[i - 1] == b[j - 1] ? 0 : 1;
        cour[j] = [
          prec[j] + 1,
          cour[j - 1] + 1,
          prec[j - 1] + cout,
        ].reduce((x, y) => x < y ? x : y);
      }
      prec = cour;
    }
    return prec[b.length];
  }

  bool _correspond(String texte) {
    final q = (_corrigee ?? _champ.text).toLowerCase().trim();
    // Tolérance simple aux fautes : on compare aussi sans accents.
    String sans(String s) => s
        .toLowerCase()
        .replaceAll(RegExp('[éèêë]'), 'e')
        .replaceAll(RegExp('[àâ]'), 'a')
        .replaceAll(RegExp('[îï]'), 'i');
    return sans(texte).contains(sans(q)) ||
        q
            .split(' ')
            .where((m) => m.length > 2)
            .any((m) => sans(texte).contains(sans(m)));
  }

  @override
  Widget build(BuildContext context) {
    final q = _champ.text.trim();
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _champ,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Ex. climatiseur, studio, plombier…',
            suffixIcon: q.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Effacer',
                    onPressed: () => setState(_champ.clear),
                    icon: const Icon(Icons.close_rounded),
                  ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: q.isEmpty ? _suggestions(marge) : _resultats(marge),
    );
  }

  Widget _suggestions(double marge) {
    return ListView(
      padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
      children: [
        const EnTeteSection('Recherches récentes'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final r in _recentes)
              ActionChip(
                avatar: const Icon(Icons.history_rounded, size: 18),
                label: Text(r),
                onPressed: () => _chercher(r),
              ),
          ],
        ),
        const EnTeteSection('Tendances à Brazzaville'),
        for (final (i, t) in _tendances.indexed)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Text(
              '${i + 1}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: i < 3 ? LiveColors.orangeVif : LiveColors.gris,
              ),
            ),
            title: Text(t),
            trailing: const Icon(Icons.north_west_rounded, size: 18),
            onTap: () => _chercher(t),
          ),
        const EnTeteSection('Parcourir'),
        Wrap(
          children: [
            for (final (icone, nom) in categoriesMarket)
              PuceIcone(icone: icone, texte: nom, onTap: () => _chercher(nom)),
          ],
        ),
      ],
    );
  }

  Widget _resultats(double marge) {
    _corrigee = null;
    var prods = _chercherTout();
    if (prods.$4 == 0) {
      final c = correction(_champ.text.trim());
      if (c != null) {
        _corrigee = c;
        prods = _chercherTout();
        if (prods.$4 == 0) _corrigee = null;
      }
    }
    return _liste(marge, prods.$1, prods.$2, prods.$3, prods.$4);
  }

  (List<Produit>, List<Bien>, List<Prestataire>, int) _chercherTout() {
    final prods = produits
        .where((p) => _correspond('${p.titre} ${p.categorie}'))
        .toList();
    final logements = biens
        .where((b) => _correspond('${b.titre} ${b.type.libelle} ${b.quartier}'))
        .toList();
    final pros = prestataires
        .where((p) => _correspond('${p.nom} ${p.metier} ${p.zone}'))
        .toList();
    final total = prods.length + logements.length + pros.length;
    return (prods, logements, pros, total);
  }

  Widget _liste(
    double marge,
    List<Produit> prods,
    List<Bien> logements,
    List<Prestataire> pros,
    int total,
  ) {
    return ListView(
      padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
      children: [
        if (_corrigee != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Résultats pour '),
                  TextSpan(
                    text: '« $_corrigee »',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: LiveColors.bleu,
                    ),
                  ),
                  TextSpan(
                    text: '. Aucun résultat pour « ${_champ.text.trim()} ».',
                  ),
                ],
              ),
            ),
          ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final (i, (nom, n)) in [
                ('Tout', total),
                ('Produits', prods.length),
                ('Logements', logements.length),
                ('Pros', pros.length),
              ].indexed)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('$nom · $n'),
                    selected: _onglet == i,
                    onSelected: (_) => setState(() => _onglet = i),
                  ),
                ),
            ],
          ),
        ),
        if (total == 0)
          EtatVide(
            icone: Icons.search_off_rounded,
            texte:
                'Aucun résultat pour « ${_champ.text} ». Créez une alerte : '
                'nous vous prévenons dès qu’une annonce arrive.',
            action: 'Créer une alerte',
            onTap: () {
              ref.read(liveProvider.notifier).ajouterAlerte(_champ.text.trim());
              context.push('/alertes');
            },
          ),
        if ((_onglet == 0 || _onglet == 1) && prods.isNotEmpty) ...[
          const EnTeteSection('Produits'),
          GrilleAdaptative(
            largeurMax: context.grandEcran ? 220 : 180,
            espacement: 14,
            enfants: [
              for (final (i, p) in prods.indexed)
                Apparition(
                  rang: i,
                  child: CarteProduit(produit: p),
                ),
            ],
          ),
        ],
        if ((_onglet == 0 || _onglet == 2) && logements.isNotEmpty) ...[
          const EnTeteSection('Logements'),
          GrilleAdaptative(
            largeurMax: context.grandEcran ? 280 : 200,
            espacement: 14,
            enfants: [for (final b in logements) CarteBien(bien: b)],
          ),
        ],
        if ((_onglet == 0 || _onglet == 3) && pros.isNotEmpty) ...[
          const EnTeteSection('Professionnels'),
          GrilleAdaptative(
            largeurMax: 460,
            espacement: 10,
            enfants: [for (final s in pros) CartePro(pro: s)],
          ),
        ],
        if (total > 0) ...[
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              ref.read(liveProvider.notifier).ajouterAlerte(_champ.text.trim());
              context.push('/alertes');
            },
            icon: const Icon(Icons.notifications_active_outlined),
            label: Text('Créer une alerte « ${_champ.text.trim()} »'),
          ),
        ],
      ],
    );
  }
}

/// E-EXP-05 — Mes alertes : recherches sauvegardées et notifiées.
class EcranAlertes extends ConsumerWidget {
  const EcranAlertes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertes = ref.watch(liveProvider).alertes;
    return Scaffold(
      appBar: AppBar(title: const Text('Mes alertes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Live vous prévient dès qu’une annonce correspond. Plus besoin de '
            'chercher tous les jours.',
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 12),
          for (final (i, (libelle, active)) in alertes.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Bloc(
                padding: 12,
                child: Row(
                  children: [
                    Icon(
                      active
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_off_outlined,
                      color: active ? LiveColors.bleu : LiveColors.gris,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            libelle,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            i == 0
                                ? '2 nouveaux résultats aujourd’hui'
                                : 'Aucun nouveau résultat',
                            style: const TextStyle(
                              color: LiveColors.gris,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: active,
                      onChanged: (_) =>
                          ref.read(liveProvider.notifier).basculerAlerte(i),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: FilledButton.icon(
          onPressed: () => context.push('/recherche'),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Nouvelle alerte'),
        ),
      ),
    );
  }
}

/// Correction d'une recherche mal orthographiée (F-RECH-01), ou nul.
String? corrigerRecherche(String q) => _EcranRechercheState.correction(q);
