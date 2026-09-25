part of 'opportunites_screens.dart';

/// E-OPP-05 — Publier une opportunité en 4 étapes : informations, détails,
/// conditions et coûts (transparence obligatoire), aperçu.
class EcranPublierOpportunite extends ConsumerStatefulWidget {
  const EcranPublierOpportunite({super.key});

  @override
  ConsumerState<EcranPublierOpportunite> createState() =>
      _EcranPublierOpportuniteState();
}

class _EcranPublierOpportuniteState
    extends ConsumerState<EcranPublierOpportunite> {
  static const _titres = [
    'Informations',
    'Détails',
    'Conditions et coûts',
    'Aperçu',
  ];

  var _etape = 0;
  var _type = TypeOpportunite.stage;
  final _titre = TextEditingController(text: 'Stage en communication digitale');
  var _lieu = 'Brazzaville';
  var _places = 4;
  var _jours = 21;
  var _video = false;
  var _gratuit = true;
  var _frais = 5000;
  var _certifie = false;
  var _publie = false;

  bool get _valide => switch (_etape) {
    0 => _titre.text.trim().isNotEmpty,
    3 => _certifie,
    _ => true,
  };

  Opportunite get _apercu => Opportunite(
    id: 'apercu',
    type: _type,
    titre: _titre.text,
    organisation: Vendeur(
      ref.read(liveProvider).espaces.isEmpty
          ? '${ref.read(liveProvider).prenom} Mabiala'
          : ref.read(liveProvider).espaces.first.nom,
      couleur: LiveColors.bleu,
    ),
    lieu: _lieu,
    dateLimite: 'dans $_jours jours',
    joursRestants: _jours,
    places: _places,
    frais: _gratuit ? 0 : _frais,
    description: '',
  );

  @override
  Widget build(BuildContext context) {
    if (_publie) return _succes(context);
    final marge = context.grandEcran ? 24.0 : 16.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Publier une opportunité')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(marge, 8, marge, 24),
        children: [
          EtapesAssistant(titres: _titres, etape: _etape),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(key: ValueKey(_etape), child: _contenu()),
          ),
        ],
      ),
      bottomNavigationBar: BarreAction(
        child: BoutonsAssistant(
          etape: _etape,
          derniere: _etape == _titres.length - 1,
          onRetour: () => setState(() => _etape--),
          onSuivant: !_valide
              ? null
              : () {
                  if (_etape < _titres.length - 1) {
                    setState(() => _etape++);
                  } else {
                    ref
                        .read(liveProvider.notifier)
                        .publierOpportunite(_titre.text);
                    setState(() => _publie = true);
                  }
                },
        ),
      ),
    );
  }

  Widget _compteur(String libelle, int valeur, ValueChanged<int> changer) {
    return Row(
      children: [
        Expanded(child: Text(libelle)),
        IconButton.outlined(
          tooltip: 'Moins',
          onPressed: valeur > 1 ? () => changer(valeur - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 44,
          child: Text(
            '$valeur',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
        ),
        IconButton.outlined(
          tooltip: 'Plus',
          onPressed: () => changer(valeur + 1),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _contenu() {
    return switch (_etape) {
      0 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Type', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in TypeOpportunite.values)
                ChoiceChip(
                  avatar: Icon(t.icone, size: 18),
                  label: Text(t.libelle),
                  selected: _type == t,
                  onSelected: (_) => setState(() => _type = t),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titre,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Titre'),
          ),
          const SizedBox(height: 12),
          const Text('Lieu', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final l in [
                'Brazzaville',
                'Pointe-Noire',
                'Dolisie',
                'En ligne',
              ])
                ChoiceChip(
                  label: Text(l),
                  selected: _lieu == l,
                  onSelected: (_) => setState(() => _lieu = l),
                ),
            ],
          ),
        ],
      ),
      1 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextField(
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Missions, profil recherché, calendrier…',
            ),
          ),
          const SizedBox(height: 12),
          _compteur(
            'Nombre de places',
            _places,
            (v) => setState(() => _places = v),
          ),
          const SizedBox(height: 8),
          _compteur(
            'Date limite (jours)',
            _jours,
            (v) => setState(() => _jours = v),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _video,
            onChanged: (v) => setState(() => _video = v),
            title: const Text('Ajouter une vidéo verticale de 30 s'),
            subtitle: const Text(
              'Les annonces avec vidéo reçoivent 3 fois plus de candidatures',
            ),
          ),
        ],
      ),
      2 => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextField(
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Conditions',
              hintText: 'Diplôme, âge, disponibilité…',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Frais demandés aux candidats',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Choix(
            titre: 'Aucun frais',
            sousTitre: 'Recommandé : badge « Gratuit » sur l’annonce',
            icone: Icons.money_off_rounded,
            selectionne: _gratuit,
            onTap: () => setState(() => _gratuit = true),
          ),
          Choix(
            titre: 'Frais officiels de dossier',
            sousTitre: 'Payés en direct, contre reçu officiel',
            icone: Icons.receipt_long_rounded,
            selectionne: !_gratuit,
            onTap: () => setState(() => _gratuit = false),
          ),
          if (!_gratuit)
            Wrap(
              spacing: 8,
              children: [
                for (final f in [2000, 5000, 10000, 15000])
                  ChoiceChip(
                    label: Text(fcfa(f)),
                    selected: _frais == f,
                    onSelected: (_) => setState(() => _frais = f),
                  ),
              ],
            ),
          const SizedBox(height: 12),
          Bloc(
            fond: LiveColors.fondAlerte,
            child: const Text(
              'Transparence obligatoire : tout frais non déclaré ici est '
              'interdit. Une annonce qui demande de l’argent en message est '
              'retirée et son auteur suspendu.',
            ),
          ),
        ],
      ),
      _ => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Voici comment les candidats verront votre annonce :',
            style: TextStyle(color: LiveColors.gris),
          ),
          const SizedBox(height: 8),
          SizedBox(height: 168, child: CarteOpportunite(opportunite: _apercu)),
          const SizedBox(height: 12),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _certifie,
            onChanged: (v) => setState(() => _certifie = v ?? false),
            title: const Text(
              'Je certifie que cette offre est réelle et que tous les frais '
              'sont indiqués.',
            ),
          ),
        ],
      ),
    };
  }

  Widget _succes(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const CocheAnimee(taille: 96),
              const Text(
                'Opportunité publiée',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '« ${_titre.text} » est vérifiée par Live puis diffusée aux '
                'personnes intéressées.',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go('/opportunites'),
                child: const Text('Voir les opportunités'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
